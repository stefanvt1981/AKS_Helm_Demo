echo "Maak resourcegroep: \n"

az group create --name aks_helm_demo --location westeurope

read -p "Press enter to continue"

#az aks create --resource-group myResourceGroup --name HelmDemoCluster --node-count 2 --enable-addons monitoring --generate-ssh-keys

echo "Maak aks cluster met 2 nodes: \n"

PASSWORD_WIN="P@ssw0rd1234"

az aks create \
    --resource-group aks_helm_demo \
    --name myAKSCluster \
    --node-count 2 \
    --enable-addons monitoring \
    --generate-ssh-keys \
    --windows-admin-password $PASSWORD_WIN \
    --windows-admin-username azureuser \
    --vm-set-type VirtualMachineScaleSets \
    --network-plugin azure

read -p "Press enter to continue"