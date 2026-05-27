#!/bin/bash

# Arrêt du script en cas d'erreur
set -e

# Emplacement du fichier log
LOGFILE="/var/log/apache_phpmyadmin_install.log"

# Création du fichier log
sudo touch "$LOGFILE"
sudo chmod 644 "$LOGFILE"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOGFILE"
}

log "=== Début du script d'installation Apache2, MariaDB et phpMyAdmin ==="

log "Mise à jour du système..."
sudo apt update 2>&1 | tee -a "$LOGFILE"
sudo apt full-upgrade -y 2>&1 | tee -a "$LOGFILE"

log "Installation de phpMyAdmin, Apache2, MariaDB, Nala, Htop..."
sudo apt install -y phpmyadmin libapache2-mod-php apache2 nala htop mariadb-server 2>&1 | tee -a "$LOGFILE"

log "Activation du serveur Apache2 au démarrage..."
sudo systemctl enable apache2 2>&1 | tee -a "$LOGFILE"

log "Démarrage du serveur Apache2..."
sudo systemctl start apache2 2>&1 | tee -a "$LOGFILE"

log "=== Installation terminée avec succès ==="
