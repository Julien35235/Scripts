#!/bin/bash
# Mets à jour le système 
sudo apt update && sudo apt full-upgrade -y
#Installation de wget
sudo apt install wget nala htop -y
#Installation de la base de données de MongoDB
wget http://ftp.debian.org/debian/pool/main/o/openssl/libssl1.1_1.1.1w-0+deb11u1_amd64.deb -O libssl.deb && sudo dpkg -i libssl.deb
wget https://repo.mongodb.org/apt/debian/dists/buster/mongodb-org/4.4/main/binary-amd64/mongodb-org-server_4.4.27_amd64.deb -O mongodb.deb && sudo dpkg -i mongodb.deb -y
#Activation du demarrage automatique de MongoDB
sudo systemctl enable mongodb && sudo systemctl start MongoDB
#Installation de java 
sudo apt install default-jdk -y
#Installation Unifi 
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/ubiquiti-archive-keyring.gpg] https://www.ui.com/downloads/unifi/debian stable ubiquiti' | sudo tee /etc/apt/sources.list.d/100-ubnt-unifi.list >/dev/null
curl https://dl.ui.com/unifi/unifi-repo.gpg | sudo tee /usr/share/keyrings/ubiquiti-archive-keyring.gpg >/dev/null
sudo apt update && sudo apt install unifi -y




