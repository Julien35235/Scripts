#!/bin/bash

# Arrêter le script en cas d'erreur
set -e

# Emplacement du fichier log
LOGFILE="/var/log/casaos_install.log"

# Création du fichier log avec les permissions
sudo touch "$LOGFILE"
sudo chmod 644 "$LOGFILE"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOGFILE"
}

log "=== Début du script d'installation CasaOS ==="

log "Mise à jour du système..."
sudo apt update 2>&1 | tee -a "$LOGFILE"
sudo apt upgrade -y 2>&1 | tee -a "$LOGFILE"

log "Téléchargement et installation de CasaOS..."
curl -fsSL https://get.casaos.io | sudo bash 2>&1 | tee -a "$LOGFILE"

log "=== Installation de CasaOS terminée avec succès ==="
