#!/bin/bash
#Mise à jour du système
sudo apt update && sudo apt full-upgrade -y
#Installation de cockpit
sudo apt install cockpit -y
#Activation du démarrage automatique de cockpit
sudo systemctl enable cockpit.socket
#Demmarge du service de cockpit
sudo systemctl start cockpit.socket
