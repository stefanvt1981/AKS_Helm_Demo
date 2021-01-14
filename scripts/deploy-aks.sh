#!/bin/sh

LOCATION="westeurope"
VNETRESOURCEGROUP="xprtz-dev-infra"
VNETNAME="xprtz-dev-infra"
AKSVNETSUBNET="xprtz-dev-k8s"
RESOURCEGROUP="xprtz-dev-k8s" 
CLUSTERNAME="xprtz-dev-k8s-cluster"
ADMIN_GROUP="All Developers"
AKS_MANAGED_IDENTITY_NAME="xprtz-dev-aks-managed-identity"

# az login

# Resouce groups
echo "=== Creating resource groups ==="
RESOURCEGROUP_CHECK=$(az group create --name $RESOURCEGROUP --location $LOCATION 2>&1 1>/dev/null)
if [ $? -eq 2 ]; then
    echo "=== Error creating resource group $RESOURCEGROUP ==="
    exit 2
fi

VNETRESOURCEGROUP_CHECK=$(az group create --name $VNETRESOURCEGROUP --location $LOCATION 2>&1 1>/dev/null)
if [ $? -eq 2 ]; then
    echo "=== Error creating resource group $VNETRESOURCEGROUP ==="
    exit 2
fi

# VNET
echo "=== Creating VNET ==="
AKSVNETSUBNET_ID=$(az network vnet create --resource-group $VNETRESOURCEGROUP -n $VNETNAME \
    --address-prefix 192.168.0.0/16 \
    --subnet-name $AKSVNETSUBNET \
    --subnet-prefix 192.168.42.0/24 | jq '.newVNet.subnets[0].id' | sed 's/.//;s/.$//')

ADMIN_GROUP_ID=$(az ad group list --filter "displayname eq 'All Developers'" -o tsv | cut -f9)

# Identity
echo "=== Creating AKS cluster Identity ==="
IDENTITY_RESULT=$(az identity create --resource-group $RESOURCEGROUP --name $AKS_MANAGED_IDENTITY_NAME \
 | jq '. | {principalId, id}')

IDENTITY_ID=$(echo $IDENTITY_RESULT | jq .id | sed 's/.//;s/.$//')
IDENTITY_PRINCIPAL=$(echo $IDENTITY_RESULT | jq .principalId | sed 's/.//;s/.$//')

echo "=== Assigning permissions to the AKS cluster Identity ==="
PERMISSIONS_CHECK=$(az role assignment create --assignee $IDENTITY_PRINCIPAL --scope $AKSVNETSUBNET_ID --role "Network Contributor" 2>&1 1>/dev/null)
if [ $? -eq 2 ]; then
    echo "=== Error setting permissions to the AKS cluster Identity ==="
    exit 2
fi

echo "=== Creating AKS cluster ==="
AKS_CHECK=$(az aks create --resource-group $RESOURCEGROUP --name $CLUSTERNAME \
    --enable-aad \
    --aad-admin-group-object-ids $ADMIN_GROUP_ID \
    --enable-managed-identity \
    --assign-identity $IDENTITY_ID \
    --network-plugin azure \
    --vnet-subnet-id $AKSVNETSUBNET_ID \
    --docker-bridge-address 172.17.0.1/16 \
    --dns-service-ip 10.2.0.10 \
    --service-cidr 10.2.0.0/24 \
    --generate-ssh-keys 2>&1 1>/dev/null)

if [ $? -eq 2 ]; then
    echo "=== Error creating AKS cluster ==="
    exit 2
fi