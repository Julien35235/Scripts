#!/bin/bash

# Arrêt du script en cas d'erreur
set -e

# Emplacement du fichier log
LOGFILE="/var/log/powershell_install.log"

# Création du fichier log avec les permissions
sudo touch "$LOGFILE"
sudo chmod 644 "$LOGFILE"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOGFILE"
}

log "=== Début du script d'installation PowerShell ==="

log "Mise à jour du système..."
sudo apt update 2>&1 | tee -a "$LOGFILE"
sudo apt full-upgrade -y 2>&1 | tee -a "$LOGFILE"

log "Installation des paquets requis (wget, nala, htop)..."
sudo apt install -y wget nala htop 2>&1 | tee -a "$LOGFILE"

log "Téléchargement de PowerShell 7.4.2..."
wget https://github.com/PowerShell/PowerShell/releases/download/v7.4.2/powershell_7.4.2-1.deb_amd64.deb \
    -O powershell.deb 2>&1 | tee -a "$LOGFILE"

log "Installation du paquet PowerShell..."
sudo apt install ./powershell.deb -y 2>&1 | tee -a "$LOGFILE"

log "=== Installation PowerShell terminée avec succès ==="
``
