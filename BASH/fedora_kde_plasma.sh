#!/bin/bash
#Mise à jour du système 
sudo dnf update
sudo dnf upgrade -y
#Installation de l'enviromment bureau de KDE Plasma Desktop dans Fedora
sudo dnf install kde-desktop
sudo systemctl set-default graphical.target
#Deactivation de l'enviromment bureau de Gnome pour passer sous KDE Plasma
sudo systemctl disable gdm
sudo reboot