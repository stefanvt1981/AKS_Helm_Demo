echo "Maak resourcegroep: \n"

az group create --name aks_helm_demo --location westeurope

read -p "Press enter to continue"

#az aks create --resource-group myResourceGroup --name HelmDemoCluster --node-count 2 --enable-addons monitoring --generate-ssh-keys

echo "\n\nMaak aks cluster met 2 nodes: \n"

PASSWORD_WIN="StefanStefanStefan2020!"

az aks create \
    --resource-group aks_helm_demo \
    --name myAKSCluster \
    --node-count 2 \
    --enable-addons monitoring \
    --generate-ssh-keys \
    --windows-admin-password $PASSWORD_WIN \
    --windows-admin-username azureuser \
    --vm-set-type VirtualMachineScaleSets \
    --network-plugin azure \
    

read -p "Press enter to continue"

echo "\n\nVoeg een windows cluster toe: \n"

az aks nodepool add \
    --resource-group aks_helm_demo \
    --cluster-name myAKSCluster \
    --os-type Windows \
    --name npwin \
    --node-count 2

read -p "Press enter to continue"

echo "Klaar! ga verder met connecten..."