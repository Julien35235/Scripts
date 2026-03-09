#!/bin/bash

# Arrêt si une commande échoue
set -e

# Emplacement du fichier log
LOGFILE="/var/log/adguard_install.log"

# Création et permissions du fichier log
sudo touch "$LOGFILE"
sudo chmod 644 "$LOGFILE"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOGFILE"
}

log "=== Début du script d'installation AdGuardHome ==="

log "Mise à jour du système..."
sudo apt update 2>&1 | tee -a "$LOGFILE"
sudo apt upgrade -y 2>&1 | tee -a "$LOGFILE"

log "Installation de curl, htop et nala..."
sudo apt install -y curl htop nala 2>&1 | tee -a "$LOGFILE"

log "Installation du serveur DNS AdGuardHome..."
curl -s -S -L \
  https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh \
  | sh -s -- -v 2>&1 | tee -a "$LOGFILE"

log "Démarrage du service AdGuardHome..."
sudo service AdGuardHome start 2>&1 | tee -a "$LOGFILE"

log "=== Installation terminée avec succès ==="
