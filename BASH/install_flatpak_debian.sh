#!/bin/bash
#Update repo
sudo apt update
#installation des flatpak pour Debian
sudo apt install flatpak
sudo apt install gnome-software-plugin-flatpak
#Ajouter le dépôt Flathub
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo