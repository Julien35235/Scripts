#!/bin/bash
#Mise à jour du système 
sudo dnf update
sudo dnf upgrade -y
#Installation de la prise en main à distance xrdp
sudo dnf install -y xrdp 
#Activation du service xrdp 
systemctl enable xrdp
#Activation du service xrdp en automatique
systemctl start xrdp
echo gnome-session > ~/.xsession
ufw allow 3389/tcp
#Redémarage du système
sudo reboot