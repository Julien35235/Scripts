#!/bin/bash
#Mise à jour du système
sudo dnf update && sudo dnf upgrade -y
#Installation de glances
sudo dnf install wget nala htop glances -y 
#Lancement de glances
glances --fetch
#Lancement de glances avec une interface web GUI
glances --browser -w
