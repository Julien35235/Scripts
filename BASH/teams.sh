#!/bin/bash

# Met à jour la liste des logiciels disponibles
sudo apt update

# Met à jour tous les logiciels installés automatiquement
sudo apt full-upgrade -y

# Installe des outils utiles :
# - htop : pour voir les processus
# - nala : alternative plus lisible à apt
# - wget : pour télécharger des fichiers
sudo apt install htop nala wget -y

# Va dans le dossier /opt (pour installer des programmes)
cd /opt

# Télécharge Microsoft Teams (version Linux)
wget https://github.com/IsmaelMartinez/teams-for-linux/releases/download/v2.7.12/teams-for-linux_2.7.12_amd64.deb

# Installe le fichier téléchargé
sudo apt install ./teams-for-linux_2.7.12_amd64.deb
