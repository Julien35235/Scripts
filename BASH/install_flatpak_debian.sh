#!/bin/bash

# Activer arrêt en cas d'erreur
set -e

# Fichier de log
LOGFILE="/var/log/flatpak_install.log"

# Créer le fichier de log si nécessaire
sudo touch "$LOGFILE"
sudo chmod 644 "$LOGFILE"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOGFILE"
}

log "=== Début du script d'installation Flatpak ==="

log "Mise à jour des dépôts..."
sudo apt update 2>&1 | tee -a "$LOGFILE"

log "Installation de Flatpak..."
sudo apt install -y flatpak 2>&1 | tee -a "$LOGFILE"

log "Installation du plugin GNOME Software pour Flatpak..."
sudo apt install -y gnome-software-plugin-flatpak 2>&1 | tee -a "$LOGFILE"

log "Ajout du dépôt Flathub..."
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo 2>&1 | tee -a "$LOGFILE"

log "=== Installation terminée avec succès ==="
``