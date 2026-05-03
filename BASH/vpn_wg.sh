#!/bin/bash

# On installe les outils de base (sudo, git, iptables)
apt-get install sudo git iptables -y && \ 

# Mise à jour des dépôts (toujours faire ça proprement)
sudo apt-get update && \

# Installation de wireguard + outils réseau
sudo apt install wireguard-tools net-tools && \

# On clone le dashboard WireGuard depuis GitHub
git clone https://github.com/WGDashboard/WGDashboard.git && \

# On se déplace dans le dossier source
cd ./WGDashboard/src && \

# On rend le script exécutable (sinon ça marche pas hein)
chmod +x ./wgd.sh && \

# Lancement de l’installation du dashboard
./wgd.sh install && \

# Activation du forwarding IP (indispensable pour le VPN)
sudo echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf && \

# Application des changements système
sudo sysctl -p /etc/sysctl.conf

# On retourne dans le dossier du dashboard (au cas où)
cd /root/WGDashboard/src

# On démarre le service WireGuard Dashboard
./wgd.sh start