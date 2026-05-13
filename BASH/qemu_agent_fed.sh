#!/bin/bash
#Mise à jour du système 
sudo dnf update && sudo dnf upgrade -y
#Installation du QEMU Guest Agent 
sudo dnf install qemu-guest-agent -y
#Une fois installé, démarrez le service et activez-le au démarrage
sudo systemctl start qemu-guest-agent
sudo systemctl enable qemu-guest-agent