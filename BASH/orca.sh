#!/bin/bash

# =========================================================
# Installation automatique d'Orca sur Ubuntu / Linux Mint / Edubuntu
# avec journalisation complète des logs
# =========================================================

LOGFILE="$HOME/install_orca.log"

# Fonction d'affichage
log() {
    echo -e "\n[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Vérification sudo
if [ "$EUID" -ne 0 ]; then
    log "Relance avec sudo..."
    exec sudo bash "$0" "$@"
fi

# Début journalisation
exec > >(tee -a "$LOGFILE") 2>&1

log "Début de l'installation d'Orca"

# Mise à jour des paquets
log "Mise à jour des dépôts APT..."
apt update

log "Mise à jour du système..."
apt upgrade -y

# Installation Orca
log "Installation d'Orca et des dépendances..."
apt install -y \
    orca \
    speech-dispatcher \
    espeak-ng \
    gnome-accessibility-themes \
    pulseaudio

# Vérification installation
if command -v orca >/dev/null 2>&1; then
    log "Orca installé avec succès."
else
    log "Erreur : Orca ne semble pas installé."
    exit 1
fi

# Activation accessibilité GNOME
log "Activation des fonctionnalités d'accessibilité..."
sudo -u "$SUDO_USER" gsettings set org.gnome.desktop.a11y.applications screen-reader-enabled true 2>/dev/null

# Informations finales
log "Installation terminée."
log "Fichier log disponible ici : $LOGFILE"

echo ""
echo "================================================="
echo "Pour lancer Orca :"
echo "    orca"
echo ""
echo "Raccourci clavier GNOME : Super + Alt + S"
echo "================================================="