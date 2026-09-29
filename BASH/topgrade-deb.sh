#!/bin/bash
# Mise à jour du système Debian 
sudo apt update && sudo apt full-upgrade -y
#Installation de la commande topgrade 
sudo apt install cargo libssl-dev pkg-config nala htop -y
sudo cargo install topgrade
export PATH=$PATH:/home/username/.cargo/bin