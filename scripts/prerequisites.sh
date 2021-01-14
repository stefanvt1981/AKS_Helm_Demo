# PIP:

sudo apt update
sudo apt install python3-pip

# Azure cli:

sudo apt update
sudo apt install azure-cli

# az aks extention:

az extension list-available --output table
az extension add --name aks-preview

# kubectl

sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2 curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

# windows:
# curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.20.0/bin/windows/amd64/kubectl.exe
# of installeer docker voor windows
