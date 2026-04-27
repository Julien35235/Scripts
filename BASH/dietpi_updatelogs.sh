#!/bin/bash

set -e

# Variables
DATE="$(date +%Y-%m-%d_%H-%M-%S)"
LOGFILE="$HOME/update_${DATE}.log"

# Fonction de log
log() {
    echo -e "$1" | tee -a "$LOGFILE"
}

log "=== Début de la mise à jour : $(date) ==="

# Mise à jour DietPi
log "\n--- dietpi-update ---"
sudo dietpi-update 2>&1 | tee -a "$LOGFILE"

# Mise à jour des dépôts
log "\n--- apt update ---"
sudo apt update 2>&1 | tee -a "$LOGFILE"

# Upgrade complet
log "\n--- apt full-upgrade ---"
sudo apt full-upgrade -y 2>&1 | tee -a "$LOGFILE"

# Nettoyage
log "\n--- apt autoremove ---"
sudo apt autoremove -y 2>&1 | tee -a "$LOGFILE"

log "\n=== Fin de la mise à jour : $(date) ==="
log "Logs enregistrés dans : $LOGFILE"