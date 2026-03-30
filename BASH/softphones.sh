#!/bin/bash
# Mise à jour du système  
sudo apt update && sudo apt full-upgrade -y
# Installation des packets pour les softphones
apt install htop nala wget curl linphone -y
cd /opt
wget https://www.zoiper.com/en/voip-softphone/download/zoiper5/for/linux-deb
apt install ./linux-deb

