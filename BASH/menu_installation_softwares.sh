#!/bin/bash

# Update repo
sudo apt update

# Installation de nala et htop
sudo apt install -y nala htop

# Installation des flatpak pour Debian
sudo apt install -y flatpak
sudo apt install -y gnome-software-plugin-flatpak

# Ajouter le dépôt Flathub
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Fonction pour installer les logiciels bureautiques
install_bureautique() {
    echo "Installation des logiciels bureautiques..."
    sudo flatpak install flathub org.libreoffice.LibreOffice -y
    sudo flatpak install flathub org.mozilla.firefox -y
    sudo flatpak install flathub com.anydesk.Anydesk -y
    sudo flatpak install flathub com.google.Chrome -y
    sudo flatpak install flathub com.google.EarthPro -y
    sudo flatpak install flathub com.slack.Slack -y
    sudo flatpak install flathub chat.rocket.RocketChat -y
    sudo flatpak install flathub us.zoom.Zoom -y
    sudo flatpak install flathub org.onlyoffice.desktopeditors -y
    sudo flatpak install flathub com.opera.Opera -y
    sudo flatpak install flathub org.keepassxc.KeePassXC -y
    sudo flatpak install flathub com.bitwarden.desktop -y
    sudo flatpak install flathub com.malwarebytes.Malwarebytes -y
    echo "Installation bureautique terminée."
}

# Fonction pour installer les logiciels gaming
install_gaming() {
    echo "Installation des logiciels gaming..."
    sudo flatpak install flathub com.valvesoftware.Steam -y
    sudo flatpak install flathub com.discordapp.Discord -y
    sudo flatpak install flathub com.obsproject.Studio -y
    sudo flatpak install flathub org.keepassxc.KeePassXC -y
    echo "Installation gaming terminée."
}

# Menu interactif
while true; do
    echo "----------------------------------------"
    echo "       Menu d'installation"
    echo "----------------------------------------"
    echo "1. Installation Bureautique"
    echo "2. Installation Gaming"
    echo "3. Quitter"
    echo "----------------------------------------"
    read -p "Choisissez une option (1-3) : " choix

    case $choix in
        1)
            install_bureautique
            ;;
        2)
            install_gaming
            ;;
        3)
            echo "Au revoir !"
            exit 0
            ;;
        *)
            echo "Option invalide, veuillez réessayer."
            ;;
    esac
done
