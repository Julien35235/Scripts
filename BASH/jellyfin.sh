#!/bin/bash
sudo apt update && sudo apt full-upgrade -y
sudo apt install wget nala htop curl apt-transport-https sudo -y 
wget -O- https://repo.jellyfin.org/install-debuntu.sh |  bash
sudo systemctl enable --now jellyfin.service
