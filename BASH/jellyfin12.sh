#!/bin/bash
sudo apt update && sudo apt full-upgrade -y
sudo apt install wget nala htop curl apt-transport-https sudo -y 
wget -O - https://repo.jellyfin.org/debian/jellyfin_team.gpg.key | sudo apt-key add -
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/jellyfin-archive-keyring.gpg] https://repo.jellyfin.org/debian bullseye main" | sudo tee /etc/apt/sources.list.d/jellyfin.list
sudo apt update
sudo nala install jellyfin -y
sudo systemctl enable jellyfin
sudo systemctl start jellyfin