#!/bin/bash
#Mise à jour du système Debian s
sudo apt update && sudo apt full-upgrade -y
sed -i 's/bookworm/trixie/g' /etc/apt/sources.list
sudo apt update
sudo apt full-upgrade -y
sudo reboot