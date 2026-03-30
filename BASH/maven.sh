#!/bin/bash
# Mise à jour du système  
sudo apt update && sudo apt full-upgrade -y
# Installation des packets pour Apache Maven 
apt install htop nala maven default-jdk ca-certificates curl -y
#Activation du service apache2
sudo systemctl enable apache2
sudo systemctl start apache2
