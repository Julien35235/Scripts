#!/bin/bash
#Mise à jour du système 
sudo apt update && sudo apt full-upgrade -y
#Installation de wget curl
sudo apt installl htop nala curl wget -y
#Installation du Cloud de RunTipi
sudo curl -L https://setup.runtipi.io | bash
