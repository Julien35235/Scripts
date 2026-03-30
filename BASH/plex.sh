#!/bin/bash
sudo apt update && sudo apt full-upgrade -y
sudo apt install wget nala htop curl apt-transport-https -y 
sudo wget -O- https://downloads.plex.tv/plex-keys/PlexSign.key | gpg --dearmor | sudo tee /usr/share/keyrings/plex.gpg
echo deb [signed-by=/usr/share/keyrings/plex.gpg] https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
sudo apt update
nala install plexmediaserver -y
