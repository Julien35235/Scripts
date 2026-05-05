#!/bin/bash
#Mise à jour du système 
sudo apt update && sudo apt full upgrade -y
#Installation de l’environnement de XFCE 
sudo apt install lightdm xfce4 xfce4-goodies -y
#Redemarrage du système
sudo reboot