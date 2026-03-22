#!/bin/bash

# Emplacement du fichier log
LOGFILE="/var/log/xivo_install.log"

# Fonction de log
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOGFILE"
}

# Début du script
log "Mise à jour du système..."
sudo apt update 2>&1 | tee -a "$LOGFILE"
sudo apt full-upgrade -y 2>&1 | tee -a "$LOGFILE"

log "Installation des paquets nécessaires..."
sudo apt install -y htop wget nala 2>&1 | tee -a "$LOGFILE"

log "Téléchargement du script d'installation XiVO..."
cd /opt || exit
wget http://mirror.xivo.solutions/xivo_install.sh -O xivo_install.sh 2>&1 | tee -a "$LOGFILE"

log "Application des permissions..."
chmod +x xivo_install.sh

log "Lancement de l'installation XiVO..."
./xivo_install.sh 2>&1 | tee -a "$LOGFILE"

log "Installation terminée."