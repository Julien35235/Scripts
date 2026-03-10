#!/bin/bash

# Arrêt du script si une commande échoue
set -e

# Emplacement du fichier log
LOGFILE="/var/log/yunohost_install.log"

# Fonction de log
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOGFILE"
}

# Création du fichier log (si n'existe pas)
sudo touch "$LOGFILE"
sudo chmod 644 "$LOGFILE"

log "===== Début du script d'installation ====="

log "Mise à jour du système…"
if sudo apt update >> "$LOGFILE" 2>&1 && sudo apt upgrade -y >> "$LOGFILE" 2>&1; then
    log "Mise à jour du système : OK"
else
    log "ERREUR : la mise à jour a échoué"
    exit 1
fi

log "Installation de YunoHost…"
if curl https://install.yunohost.org | bash >> "$LOGFILE" 2>&1; then
    log "Installation de YunoHost : OK"
else
    log "ERREUR : l'installation de YunoHost a échoué"
    exit 1
fi

log "===== Fin du script ====="