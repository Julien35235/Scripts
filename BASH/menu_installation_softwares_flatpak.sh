#!/bin/bash

# ==================================================
# MISE À JOUR DU SYSTÈME
# ==================================================
sudo apt update && sudo apt full-upgrade -y

# ==================================================
# OUTILS DE BASE
# ==================================================
sudo apt install nala htop flatpak gnome-software-plugin-flatpak -y

# ==================================================
# AJOUT DU DÉPÔT FLATHUB
# ==================================================
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# ==================================================
# BUREAUTIQUE
# ==================================================
install_bureautique() {
    echo "Installation des logiciels bureautiques..."

    sudo flatpak install flathub -y \
        org.mozilla.firefox \
        com.anydesk.Anydesk \
        com.google.Chrome \
        com.google.EarthPro \
        com.slack.Slack \
        chat.rocket.RocketChat \
        org.telegram.desktop \
        us.zoom.Zoom \
        org.onlyoffice.desktopeditors \
        com.vivaldi.Vivaldi \
        org.keepassxc.KeePassXC \
        com.bitwarden.desktop \
        org.signal.Signal \
        org.gnome.Calculator \
        com.adobe.Reader \
        org.filezillaproject.Filezilla \
        org.gnome.TextEditor \
        org.gnome.Calendar \
        org.gnome.SimpleScan \
        net.code_industry.MasterPDFEditor \
        com.nextcloud.desktopclient.nextcloud \
        org.gnome.Papers \
        app.drey.Dialect \
        com.adobe.Flash-Player-Projector \
        com.malwarebytes.Malwarebytes \
        io.github.bytezz.IPLookup

    echo " Bureautique terminé."
}

# ==================================================
# GAMING
# ==================================================
install_gaming() {
    echo "Installation des logiciels gaming..."

    sudo flatpak install flathub -y \
        com.vivaldi.Vivaldi \
        org.mozilla.firefox \
        com.anydesk.Anydesk \
        com.google.Chrome \
        com.opera.Opera \
        com.valvesoftware.Steam \
        com.discordapp.Discord \
        com.obsproject.Studio \
        org.keepassxc.KeePassXC \
        org.telegram.desktop \
        org.signal.Signal \
        com.valvesoftware.SteamLink \
        org.vinegarhq.Sober \
        com.warlordsoftwares.youtube-downloader-4ktube \
        rocks.shy.VacuumTube \
        io.github.ryubing.Ryujinx \
        com.teamspeak.TeamSpeak \
        com.ktechpit.ultimate-media-downloader \
        dev.fredol.open-tv \
        info.cemu.Cemu \
        io.github.diegopvlk.Cine \
        io.github.arunsivaramanneo.GPUViewer \
        io.github.spacingbat3.webcord \
        org.kde.audiotube \
        com.atlauncher.ATLauncher \
        io.github.congard.qnvsm \
        app.drey.Dialect \
        org.DolphinEmu.dolphin-emu \
        org.desmume.DeSmuME \
        xyz.hyperplay.HyperPlay \
        net.kuribo64.melonDS

    echo " Gaming terminé."
}

# ==================================================
# DÉVELOPPEMENT
# ==================================================
install_developpements() {
    echo "Installation des logiciels de développement..."

    sudo flatpak install flathub -y \
        com.bitwarden.desktop \
        org.mozilla.firefox \
        com.google.Chrome \
        com.slack.Slack \
        chat.rocket.RocketChat \
        us.zoom.Zoom \
        org.onlyoffice.desktopeditors \
        org.keepassxc.KeePassXC \
        com.visualstudio.code \
        org.telegram.desktop \
        org.signal.Signal \
        org.audacityteam.Audacity \
        com.google.AndroidStudio \
        org.kde.gwenview \
        org.gnome.Calculator \
        com.adobe.Reader \
        org.gnome.TextEditor \
        io.github.shiftey.Desktop \
        org.gnome.Calendar \
        org.gnome.Papers \
        com.jetbrains.PyCharm-Professional \
        com.jetbrains.IntelliJ-IDEA-Ultimate \
        com.jetbrains.Rider \
        com.jetbrains.CLion \
        app.drey.Dialect \
        cc.arduino.arduinoide \
        com.adobe.Flash-Player-Projector \
        com.jetbrains.WebStorm \
        io.github.bytezz.IPLookup

    echo " Développement terminé."
}

# ==================================================
# GESTION DE PAIE
# ==================================================
install_paie() {
    echo "Installation des logiciels de gestion de paie..."

    sudo flatpak install flathub -y \
        org.gnucash.GnuCash \
        org.kde.kmymoney \
        org.libreoffice.LibreOffice \
        com.adobe.Reader \
        net.code_industry.MasterPDFEditor \
        org.kde.okular \
        com.nextcloud.desktopclient.nextcloud \
        org.onlyoffice.desktopeditors \
        org.keepassxc.KeePassXC \
        org.gnome.SimpleScan \
        org.mozilla.firefox \
        com.google.Chrome \
        com.vivaldi.Vivaldi

    echo "Gestion de paie terminée."
}

# ==================================================
# COMPTABILITÉ
# ==================================================
install_comptabilite() {
    echo "Installation des logiciels de comptabilité..."

    sudo flatpak install flathub -y \
        org.gnucash.GnuCash \
        org.kde.kmymoney \
        org.libreoffice.LibreOffice \
        com.adobe.Reader \
        net.code_industry.MasterPDFEditor \
        org.kde.okular \
        com.nextcloud.desktopclient.nextcloud \
        org.keepassxc.KeePassXC

    echo " Comptabilité terminée."
}

# ==================================================
# MENU INTERACTIF
# ==================================================
while true; do
    echo "----------------------------------------"
    echo "        MENU D'INSTALLATION"
    echo "----------------------------------------"
    echo "1. Bureautique"
    echo "2. Gaming"
    echo "3. Développement"
    echo "4. Gestion de Paie"
    echo "5. Comptabilité"
    echo "6. Quitter"
    echo "----------------------------------------"

    read -p "Choisissez une option (1-6) : " choix

    case $choix in
        1) install_bureautique ;;
        2) install_gaming ;;
        3) install_developpements ;;
        4) install_paie ;;
        5) install_comptabilite ;;
        6)
            echo "Au revoir !"
            exit 0
            ;;
        *)
            echo " Option invalide, veuillez réessayer."
            ;;
    esac
done
