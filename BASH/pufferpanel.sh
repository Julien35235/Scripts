#!/bin/bash
sudo apt update && sudo apt full-upgrade -y
sudo apt install git curl unzip nala htop wget -y 
sudo curl -s https://packagecloud.io/install/repositories/pufferpanel/pufferpanel/script.deb.sh | bash
sudo apt install pufferpanel -y 
pufferpanel user add
sudo systemctl enable --now pufferpanel
