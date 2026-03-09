#!/bin/bash

set -e

# Fichier log
LOGFILE="/var/log/flatpak_install_menu.log"
sudo touch "$LOGFILE"
sudo chmod 644 "$LOGFILE"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOGFILE"
}

log "=== DÉMARRAGE DU SCRIPT ==="

# Update repo
log "Mise à jour des dépôts..."
sudo apt update 2>&1 | tee -a "$LOGFILE"

# Installation de nala et htop
log "Installation de nala et htop..."
sudo apt install -y nala htop 2>&1 | tee -a "$LOGFILE"

# Installation des flatpak pour Debian
log "Installation de Flatpak..."
sudo apt install -y flatpak gnome-software-plugin-flatpak 2>&1 | tee -a "$LOGFILE"

# Ajouter le dépôt Flathub
log "Ajout du dépôt Flathub..."
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo 2>&1 | tee -a "$LOGFILE"

##############################################
# FONCTIONS D’INSTALLATION
##############################################

install_bureautique() {
    log "Installation des logiciels bureautiques..."
    sudo flatpak install -y flathub org.mozilla.firefox
    sudo flatpak install -y flathub com.anydesk.Anydesk
    sudo flatpak install -y flathub com.google.Chrome
    sudo flatpak install -y flathub com.google.EarthPro
    sudo flatpak install -y flathub com.slack.Slack
    sudo flatpak install -y flathub chat.rocket.RocketChat
    sudo flatpak install -y flathub org.telegram.desktop
    sudo flatpak install -y flathub us.zoom.Zoom
    sudo flatpak install -y flathub org.onlyoffice.desktopeditors
    sudo flatpak install -y flathub com.vivaldi.Vivaldi
    sudo flatpak install -y flathub org.keepassxc.KeePassXC
    sudo flatpak install -y flathub com.bitwarden.desktop
    sudo flatpak install -y flathub org.signal.Signal
    sudo flatpak install -y flathub org.gnome.Calculator
    sudo flatpak install -y flathub com.adobe.Reader
    sudo flatpak install -y flathub org.filezillaproject.Filezilla
    sudo flatpak install -y flathub org.gnome.TextEditor
    sudo flatpak install -y flathub org.gnome.Calendar
    sudo flatpak install -y flathub org.gnome.SimpleScan
    sudo flatpak install -y flathub net.code_industry.MasterPDFEditor
    sudo flatpak install -y flathub com.nextcloud.desktopclient.nextcloud
    sudo flatpak install -y flathub org.gnome.Papers
    sudo flatpak install -y flathub app.drey.Dialect
    sudo flatpak install -y flathub com.adobe.Flash-Player-Projector || true
    sudo flatpak install -y flathub com.malwarebytes.Malwarebytes
    sudo flatpak install -y flathub io.github.bytezz.IPLookup
    sudo flatpak install -y flathub net.xmind.XMind
    log "Installation bureautique terminée."
}

install_gaming() {
    log "Installation des logiciels gaming..."
    sudo flatpak install -y flathub com.vivaldi.Vivaldi
    sudo flatpak install -y flathub org.mozilla.firefox
    sudo flatpak install -y flathub com.anydesk.Anydesk
    sudo flatpak install -y flathub com.google.Chrome
    sudo flatpak install -y flathub com.opera.Opera
    sudo flatpak install -y flathub com.valvesoftware.Steam
    sudo flatpak install -y flathub com.discordapp.Discord
    sudo flatpak install -y flathub com.obsproject.Studio
    sudo flatpak install -y flathub org.keepassxc.KeePassXC
    sudo flatpak install -y flathub org.telegram.desktop
    sudo flatpak install -y flathub org.signal.Signal
    sudo flatpak install -y flathub com.valvesoftware.SteamLink
    sudo flatpak install -y flathub org.vinegarhq.Sober
    sudo flatpak install -y flathub com.warlordsoftwares.youtube-downloader-4ktube
    sudo flatpak install -y flathub rocks.shy.VacuumTube
    sudo flatpak install -y flathub io.github.ryubing.Ryujinx
    sudo flatpak install -y flathub com.teamspeak.TeamSpeak
    sudo flatpak install -y flathub com.ktechpit.ultimate-media-downloader
    sudo flatpak install -y flathub dev.fredol.open-tv
    sudo flatpak install -y flathub info.cemu.Cemu
    sudo flatpak install -y flathub io.github.diegopvlk.Cine
    sudo flatpak install -y flathub io.github.arunsivaramanneo.GPUViewer
    sudo flatpak install -y flathub io.github.spacingbat3.webcord
    sudo flatpak install -y flathub org.kde.audiotube
    sudo flatpak install -y flathub com.atlauncher.ATLauncher
    sudo flatpak install -y flathub io.github.congard.qnvsm
    sudo flatpak install -y flathub app.drey.Dialect
    sudo flatpak install -y flathub org.DolphinEmu.dolphin-emu
    sudo flatpak install -y flathub org.desmume.DeSmuME
    sudo flatpak install -y flathub xyz.hyperplay.HyperPlay
    sudo flatpak install -y flathub net.kuribo64.melonDS
    log "Installation gaming terminée."
}

install_developpements() {
    log "Installation des logiciels de développement..."
    sudo flatpak install -y flathub com.bitwarden.desktop
    sudo flatpak install -y flathub org.mozilla.firefox
    sudo flatpak install -y flathub com.google.Chrome
    sudo flatpak install -y flathub com.slack.Slack
    sudo flatpak install -y flathub chat.rocket.RocketChat
    sudo flatpak install -y flathub us.zoom.Zoom
    sudo flatpak install -y flathub org.onlyoffice.desktopeditors
    sudo flatpak install -y flathub org.keepassxc.KeePassXC
    sudo flatpak install -y flathub com.visualstudio.code -y
    sudo flatpak install -y flathub org.telegram.desktop
    sudo flatpak install -y flathub org.signal.Signal
    sudo flatpak install -y flathub org.audacityteam.Audacity
    sudo flatpak install -y flathub com.google.AndroidStudio
    sudo flatpak install -y flathub org.kde.gwenview
    sudo flatpak install -y flathub org.gnome.Calculator
    sudo flatpak install -y flathub com.adobe.Reader
    sudo flatpak install -y flathub org.gnome.TextEditor
    sudo flatpak install -y flathub io.github.shiftey.Desktop
    sudo flatpak install -y flathub org.gnome.Calendar
    sudo flatpak install -y flathub org.gnome.Papers
    sudo flatpak install -y flathub com.jetbrains.PyCharm-Professional
    sudo flatpak install -y flathub com.jetbrains.IntelliJ-IDEA-Ultimate
    sudo flatpak install -y flathub com.jetbrains.Rider
    sudo flatpak install -y flathub com.jetbrains.CLion
    sudo flatpak install -y flathub app.drey.Dialect
    sudo flatpak install -y flathub cc.arduino.arduinoide
    sudo flatpak install -y flathub com.adobe.Flash-Player-Projector || true
    sudo flatpak install -y flathub com.jetbrains.WebStorm
    sudo flatpak install -y flathub io.github.bytezz.IPLookup
    sudo flatpak install -y flathub net.xmind.XMind
    log "Installation développement terminée."
}

##############################################
# MENU INTERACTIF
##############################################

while true; do
    echo "----------------------------------------"
    echo "       Menu d'installation"
    echo "----------------------------------------"
    echo "1. Installation Bureautique"
    echo "2. Installation Gaming"
    echo "3. Installation Développement"
    echo "4. Quitter"
    echo "----------------------------------------"
    read -p "Choisissez une option (1-4) : " choix

    case $choix in
        1) install_bureautique ;;
        2) install_gaming ;;
        3) install_developpements ;;
        4) log "Fin du script." ; exit 0 ;;
        *) echo "Option invalide !" ;;
    esac
done
