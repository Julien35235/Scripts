#!/bin/bash

# Nom du fichier log avec date
LOGFILE="/var/log/setup_$(date +"%Y%m%d_%H%M%S").log"

# Fonction pour afficher + logguer
log() {
    echo -e "$1" | tee -a "$LOGFILE"
}

log "===== DÉBUT DU SCRIPT : $(date) ====="
log "Fichier de log : $LOGFILE"
log ""

log " Mise à jour du système..."
sudo apt update 2>&1 | tee -a "$LOGFILE"
sudo apt full-upgrade -y 2>&1 | tee -a "$LOGFILE"
log " Mise à jour terminée."
log ""

log " Installation des paquets : htop, nala, wget, curl..."
sudo apt install -y htop nala wget curl 2>&1 | tee -a "$LOGFILE"
log " Paquets installés."
log ""

log " Installation de RaspAP pour la WiFi..."
curl -sL https://install.raspap.com | bash 2>&1 | tee -a "$LOGFILE"
log " RaspAP installé."
log ""

log "===== FIN DU SCRIPT : $(date) ====="