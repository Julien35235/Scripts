#!/bin/bash
#Mise à jour du système 
apt update && apt full upgrade -y
#Exécutez le script de vérification 
pve8to9
#Suppersion du packet systemd-boot 
apt remove systemd-boot -y
#Remplacement des dépôts de Debian
sed -i 's/bookworm/trixie/g' /etc/apt/sources.list
#Suppresion de ceph
rm /etc/apt/sources.list.d/ceph.list
#Actualisation des mises à jour
apt update
#Installation du packet amd64-microcode
apt install amd64-microcode -y
#Mise à jour du système 
apt update && sudo apt full upgrade -y
#Redemarrage du serveur 
#sudo reboot
