#!/bin/bash
# mets à jour mon système 
sudo apt update && sudo apt full-upgrade -y
#Installations des paquets  
sudo apt install nala htop curl wget htop gnupg2 debconf adduser procps gnupg apt-transport-https filebeat debhelper libcap2-bin -y
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import && chmod 644 /usr/share/keyrings/wazuh.gpg
#Ajout du dépôt wazuh
echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list
sudo apt update
curl -sO https://packages.wazuh.com/4.7/wazuh-certs-tool.sh && curl -sO https://packages.wazuh.com/4.7/config.yml
sudo bash ./wazuh-certs-tool.sh -A
tar -cvf ./wazuh-certificates.tar -C ./wazuh-certificates/ .
rm -rf ./wazuh-certificates
# Installation de wazuh-dashboard
sudo apt install wazuh-indexer wazuh-manager wazuh-dashboard -y
chmod 500 /etc/wazuh-indexer/certs
chmod 400 /etc/wazuh-indexer/certs/*
chown -R wazuh-indexer:wazuh-indexer /etc/wazuh-indexer/certs
# activation du démarrage le service wazuh-indexer
sudo systemctl daemon-reload
sudo systemctl enable wazuh-indexer
sudo systemctl start wazuh-indexer
