#!/bin/bash

# Arrêt du script en cas d'erreur
set -e

# Fichier log
LOGFILE="/var/log/freepbx_install.log"

# Création du fichier log
sudo touch "$LOGFILE"
sudo chmod 644 "$LOGFILE"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOGFILE"
}

log "=== Début du script d'installation FreePBX ==="

log "Mise à jour du système..."
sudo apt update 2>&1 | tee -a "$LOGFILE"
sudo apt upgrade -y 2>&1 | tee -a "$LOGFILE"

log "Déplacement dans /tmp..."
cd /tmp

log "Téléchargement du script d'installation FreePBX..."
wget https://github.com/FreePBX/sng_freepbx_debian_install/raw/master/sng_freepbx_debian_install.sh \
    -O /tmp/sng_freepbx_debian_install.sh 2>&1 | tee -a "$LOGFILE"

log "Rendre le script exécutable..."
sudo chmod +x /tmp/sng_freepbx_debian_install.sh

log "Exécution du script d'installation FreePBX..."
sudo bash /tmp/sng_freepbx_debian_install.sh 2>&1 | tee -a "$LOGFILE"

log "=== Installation FreePBX terminée avec succès ==="
