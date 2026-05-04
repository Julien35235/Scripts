#!/bin/bash
#Mise à jour du système 
sudo apt update && sudo apt full upgrade -y
#Installation de wget et de curl git
sudo apt install wget curl git -y
cd /opt
#Clonage du repository 
git clone https://github.com/FOGProject/fogproject.git
cd fogproject/bin
#Installation du serveur FOG pour faire du PXE
./installfog.sh
