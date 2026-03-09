#!/bin/bash
# Mets à jour le système 
sudo apt update && sudo apt full-upgrade -y
#Installation de wget
sudo apt install wget nala htop -y
#Telechargement de PowerShell pour Debian
wget https://github.com/PowerShell/PowerShell/releases/download/v7.4.2/powershell_7.4.2-1.deb_amd64.deb 
#Installation de PowerShell
sudo apt install ./powershell_7.4.2-1.deb_amd64.deb  -y