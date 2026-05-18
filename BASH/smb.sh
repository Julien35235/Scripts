#!/bin/bash
#Mise à jour du système
sudo apt update && sudo apt full-upgrade -y
#Installation du server de samba 
sudo apt install cifs-utils samba -y
systemctl enable smbd.service
systemctl start smbd.service
