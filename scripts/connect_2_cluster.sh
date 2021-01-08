echo "Install de CLI: \n"

az aks install-cli

read -p "Press enter to continue"

echo "\n\n vraag credentials op: \n"

az aks get-credentials --resource-group aks_helm_demo --name myAKSCluster

read -p "Press enter to continue"

echo "\n\n Bekijk aangemaakte nodes: \n"

kubectl get nodes