#!/bin/bash
#Mise à jour du système 
sudo apt update && sudo apt full upgrade -y
#Installation de l'enviromment bureau de KDE full dans Debian
sudo apt install install task-kde-desktop -y
sudo reboot