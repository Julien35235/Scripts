#!/bin/bash
# mise a jour du systeme
sudo apt update && sudo apt full-upgrade -y
# Installation des packets
sudo apt install nala htop atop wget curl -y
cd /opt
# Installation du serveur PiHole
curl -s5L https://install.pi-hole.net | bash
