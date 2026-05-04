#!/bin/bash
#Mise à jour du système 
sudo apt update && sudo apt full upgrade -y
#Installation des packets nécessaire pour le firewall sous Linux
sudo apt install iptables-persistent ufw -y 
#Activation du firewall 
sudo ufw enable 
systemctl enable ufw 
#Activation du démarrage automatique du firewall
systemctl start ufw 
sudo ufw allow OpenSSH
