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
    sudo flatpak install flathub org.mozilla.firefox -y
    sudo flatpak install flathub com.anydesk.Anydesk -y
    sudo flatpak install flathub com.google.Chrome -y
    sudo flatpak install flathub com.google.EarthPro -y
    sudo flatpak install flathub com.slack.Slack -y
    sudo flatpak install flathub chat.rocket.RocketChat -y
    sudo flatpak install flathub org.telegram.desktop -y
    sudo flatpak install flathub us.zoom.Zoom -y
    sudo flatpak install flathub org.onlyoffice.desktopeditors -y
    sudo flatpak install flathub com.vivaldi.Vivaldi -y
    sudo flatpak install flathub org.keepassxc.KeePassXC -y
    sudo flatpak install flathub com.bitwarden.desktop -y
    sudo flatpak install flathub org.signal.Signal -y
    sudo flatpak install flathub org.gnome.Calculator -y
    sudo flatpak install flathub com.adobe.Reader -y
    sudo flatpak install flathub org.filezillaproject.Filezilla -y
    sudo flatpak install flathub org.gnome.TextEditor -y
    sudo flatpak install flathub org.gnome.Calendar -y 
    sudo flatpak install flathub org.gnome.SimpleScan -y
    sudo flatpak install flathub net.code_industry.MasterPDFEditor -y
    sudo flatpak install flathub com.nextcloud.desktopclient.nextcloud -y
    sudo flatpak install flathub org.gnome.Papers -y
    sudo flatpak install flathub app.drey.Dialect -y
    sudo flatpak install flathub com.adobe.Flash-Player-Projector -y
    sudo flatpak install flathub com.malwarebytes.Malwarebytes -y
    sudo flatpak install flathub io.github.bytezz.IPLookup -y
    sudo flatpak install flathub net.xmind.XMind -y
    echo "Installation bureautique terminée."
}

# Fonction pour installer les logiciels gaming
install_gaming() {
    echo "Installation des logiciels gaming..."
    sudo flatpak install flathub com.vivaldi.Vivaldi -y
    sudo flatpak install flathub org.mozilla.firefox -y
    sudo flatpak install flathub com.anydesk.Anydesk -y
    sudo flatpak install flathub com.google.Chrome -y
    sudo flatpak install flathub com.opera.Opera -y
    sudo flatpak install flathub com.valvesoftware.Steam -y
    sudo flatpak install flathub com.discordapp.Discord -y
    sudo flatpak install flathub com.obsproject.Studio -y
    sudo flatpak install flathub org.keepassxc.KeePassXC -y
    sudo flatpak install flathub org.telegram.desktop -y
    sudo flatpak install flathub org.signal.Signal -y
    sudo flatpak install flathub com.valvesoftware.SteamLink -y
    sudo flatpak install flathub org.vinegarhq.Sober -y
    sudo flatpak install flathub com.warlordsoftwares.youtube-downloader-4ktube -y
    sudo flatpak install flathub rocks.shy.VacuumTube -y
    sudo flatpak install flathub io.github.ryubing.Ryujinx -y
    sudo flatpak install flathub com.teamspeak.TeamSpeak -y
    sudo flatpak install flathub com.ktechpit.ultimate-media-downloader -y
    sudo flatpak install flathub dev.fredol.open-tv -y
    sudo flatpak install flathub info.cemu.Cemu -y
    sudo flatpak install flathub io.github.diegopvlk.Cine -y
    sudo flatpak install flathub io.github.arunsivaramanneo.GPUViewer -y 
    sudo flatpak install flathub io.github.spacingbat3.webcord -y
    sudo flatpak install flathub org.kde.audiotube -y
    sudo flatpak install flathub com.atlauncher.ATLauncher -y
    sudo flatpak install flathub io.github.congard.qnvsm -y
    sudo flatpak install flathub app.drey.Dialect -y
    sudo flatpak install flathub org.DolphinEmu.dolphin-emu -y
    sudo flatpak install flathub org.desmume.DeSmuME -y
    sudo flatpak install flathub xyz.hyperplay.HyperPlay -y
    sudo flatpak install flathub net.kuribo64.melonDS -y
    echo "Installation gaming terminée."
}
# Fonction pour installer les logiciels des developpeurs
install_developpements() {
       echo "Installation des logiciels developpement..."
       sudo flatpak install flathub com.bitwarden.desktop -y
       sudo flatpak install flathub org.mozilla.firefox -y
       sudo flatpak install flathub com.google.Chrome -y
       sudo flatpak install flathub com.slack.Slack -y
       sudo flatpak install flathub chat.rocket.RocketChat -y
       sudo flatpak install flathub us.zoom.Zoom -y
       sudo flatpak install flathub org.onlyoffice.desktopeditors -y
       sudo flatpak install flathub org.keepassxc.KeePassXC -y
       sudo flatpak install flathub com.visualstudio.code
       sudo flatpak install flathub org.telegram.desktop -y
       sudo flatpak install flathub org.signal.Signal -y
       sudo flatpak install flathub org.audacityteam.Audacity -y
       sudo flatpak install flathub com.google.AndroidStudio -y
       sudo flatpak install flathub org.kde.gwenview -y
       sudo flatpak install flathub org.gnome.Calculator -y
       sudo flatpak install flathub com.adobe.Reader -y
       sudo flatpak install flathub org.gnome.TextEditor -y
       sudo flatpak install flathub io.github.shiftey.Desktop -y 
       sudo flatpak install flathub org.gnome.Calendar -y
       sudo flatpak install flathub org.gnome.Papers -y
       sudo flatpak install flathub com.jetbrains.PyCharm-Professional -y
       sudo flatpak install flathub com.jetbrains.IntelliJ-IDEA-Ultimate -y
       sudo flatpak install flathub com.jetbrains.Rider -y
       sudo flatpak install flathub com.jetbrains.CLion -y
        sudo flatpak install flathub app.drey.Dialect -y
        sudo flatpak install flathub cc.arduino.arduinoide -y
        sudo flatpak install flathub com.adobe.Flash-Player-Projector -y
        sudo flatpak install flathub com.jetbrains.WebStorm -y
        sudo flatpak install flathub io.github.bytezz.IPLookup -y
       sudo flatpak install flathub net.xmind.XMind -y
       echo "Installation developpements terminée."
       }
# Menu interactif
while true; do
    echo "----------------------------------------"
    echo "       Menu d'installation"
    echo "----------------------------------------"
    echo "1. Installation Bureautique"
    echo "2. Installation Gaming"
     echo "3. Installation Developpements"
    echo "4. Quitter"
    echo "----------------------------------------"
    read -p "Choisissez une option (1-4) : " choix

    case $choix in
        1)
            install_bureautique
            ;;
        2)
            install_gaming
            ;;
        3)
           install_developpements
           ;;
         4)
            echo "Au revoir !"
            exit 0
            ;;
        *)
            echo "Option invalide, veuillez réessayer."
            ;;
    esac
done