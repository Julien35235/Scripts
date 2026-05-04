#!/bin/bash
#Mise à jour du système 
sudo apt update && sudo apt full upgrade -y
#Installation des packets nécessaire pour RustDesk 
sudo apt install -y wget xvfb libgtk-3-0 libnotify4 libglib2.0-0 libnss3 libxss1 libasound2 libxrandr2 libatk1.0-0 libdrm2 libxcomposite1 libxdamage1 libxfixes3 wget curl
sudo apt install -f
sudo apt install -y pulseaudio alsa-utils
cd /opt
#Récupération du packets de RustDesk
wget https://github.com/rustdesk/rustdesk/releases/download/1.4.1/rustdesk-1.4.1-x86_64.deb
sudo apt install -f -y
#Installation de RustDesk
sudo apt install -y ./rustdesk-*.deb
