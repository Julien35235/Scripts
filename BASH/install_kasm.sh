#!/bin/bash

# Arrêt du script en cas d'erreur
set -e

# Emplacement du fichier log
LOGFILE="/var/log/kasm_install.log"

# Création du fichier log avec permissions
sudo touch "$LOGFILE"
sudo chmod 644 "$LOGFILE"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOGFILE"
}

log "=== Début du script d'installation KASM ==="

log "Mise à jour du système..."
sudo apt update 2>&1 | tee -a "$LOGFILE"
sudo apt full-upgrade -y 2>&1 | tee -a "$LOGFILE"

log "Installation des paquets requis (curl, nala, htop)..."
sudo apt install -y curl nala htop 2>&1 | tee -a "$LOGFILE"

log "Déplacement dans /tmp..."
cd /tmp

log "Téléchargement de KASM Workspaces..."
curl -O https://kasm-static-content.s3.amazonaws.com/kasm_release_1.17.0.7f020d.tar.gz 2>&1 | tee -a "$LOGFILE"

log "Extraction de l'archive..."
tar -xf kasm_release_1.17.0.7f020d.tar.gz 2>&1 | tee -a "$LOGFILE"

log "Lancement de l'installation de KASM..."
sudo bash kasm_release/install.sh 2>&1 | tee -a "$LOGFILE"

log "=== Installation KASM terminée avec succès ==="
