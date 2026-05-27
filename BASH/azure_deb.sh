#!/bin/bash
#Mise à jour du système 
sudo apt update && sudo apt full-upgrade -y
#Installation des paquets 
sudo apt install  ca-certificates curl apt-transport-https lsb-release gnupg htop nala curl wget -y
#Il faut télécharger et ajouter la clé GPG de Microsoft sur sa machine locale
curl -sL https://packages.microsoft.com/keys/microsoft.asc |
   gpg --dearmor |
sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
#Ajouter un nouveau dépôt dédié à Azure CLI et mis à disposition par Microsoft, afin de pouvoir télécharger le paquet.
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
   sudo tee /etc/apt/sources.list.d/azure-cli.list
#Mettre à jour le cache des paquet et installer le paquet "azure-cli" 
sudo apt update
sudo apt install azure-cli -y


