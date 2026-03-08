#!/bin/bash
#Update repo
sudo apt update
# Lister les snaps installés
#supprestions des snaps 1 à 1.
snap list
snap remove firefox firmware-updater snap-store
snap remove gtk-common-themes gnome-42-2204 snapd-desktop-integration
snap remove core22 bare
snap remove snapd
#Supprimer le paquet snapd
apt autoremove snapd
#bloquer le paquet en paramétrant apt.
sed -i -e '/Package: snapd/a Pin: release *\nPin-Priority: -1' /etc/apt/preferences.d/nosnap
#Installation des logiciels complémentaires
apt install gnome-software-plugin-flatpak
