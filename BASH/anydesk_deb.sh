#!/bin/bash
#Mise à jour du système 
sudo apt update && sudo apt full upgrade -y
#Installation de extrepo 
apt install extrepo -y
sudo sed -i 's/# - non-free/- non-free/' /etc/extrepo/config.yaml
#Activation de repository d'Anydesk
sudo extrepo enable anydesk
#Mise à jour du système 
sudo apt update
#Installation d'Anydesk
sudo apt install anydesk -y
