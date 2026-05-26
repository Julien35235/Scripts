#!/bin/bash
#Mise à jour du système 
sudo dnf update
sudo dnf upgrade -y
#Installation de l'enviromment bureau de Gnome dans Fedora
sudo dnf groupinstall gnome -y
sudo dnf install gnome-tweak-tool -y
sudo systemctl stop sddm.service && systemctl disable sddm.service
sudo systemctl start gdm.service && systemctl enable gdm.service
sudo reboot
