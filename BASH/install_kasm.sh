#!/bin/bash
# Mets à jour le système 
sudo apt update && sudo apt full-upgrade -y
#installation des packets 
sudo apt install curl nala htop -y
#Installation du serveur KASM 
cd /tmp
curl -O https://kasm-static-content.s3.amazonaws.com/kasm_release_1.17.0.7f020d.tar.gz
tar -xf kasm_release_1.17.0.7f020d.tar.gz
sudo bash kasm_release/install.sh