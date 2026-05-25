#!/bin/bash
#Mise à jour du système
sudo dnf update && dnf upgrade -y
#Installation du serveur ssh
sudo dnf install openssh-server ssh -y
#Activation du service ssh en automatique
sudo systemctl enable ssh 
#Demarrage du service ssh
sudo systemctl start ssh
 
