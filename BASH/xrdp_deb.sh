#!/bin/bash
#Mise à jour du système 
sudo apt update && sudo apt full-upgrade -y
#Installation de la prise en main à distance xrdp
apt install ufw xrdp -y
#Activation du service xrdp 
systemctl enable xrdp
#Activation du service xrdp en automatique
systemctl start xrdp
echo gnome-session > ~/.xsession
ufw allow 3389/tcp
#Redémarage du système
sudo reboot
