#!/bin/bash
#Mise à jour du système
sudo apt update && sudo apt full-upgrade -y
#Installation de glances
sudo apt install wget nala htop glances -y 
#Lancement de glances
glances --fetch
#Lancement de glances avec une interface web GUI
glances --browser -w
