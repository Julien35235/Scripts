#!/bin/bash
#Mise à jour du système 
sudo apt update && sudo apt full upgrade -y
#Installaion des mises à jour du système omv
omv-release-upgrade
#Redemarrage du système
sudo reboot