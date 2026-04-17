#!/bin/bash

LOG_FILE="bitwarden_install.log"

log() {
    echo -e "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

error_exit() {
    echo -e "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
    exit 1
}

log "Début de l'installation de Bitwarden"

# Vérifier root
if [[ "$EUID" -ne 0 ]]; then
   error_exit "Ce script doit être exécuté en root."
fi

# Mise à jour système
log "Mise à jour des paquets..."
apt update && apt upgrade -y >> "$LOG_FILE" 2>&1 || error_exit "Échec de la mise à jour"

# Installer dépendances
log "Installation des dépendances (curl, docker)..."
apt install -y curl apt-transport-https ca-certificates gnupg >> "$LOG_FILE" 2>&1 || error_exit "Échec installation dépendances"

# Installer Docker
if ! command -v docker &> /dev/null; then
    log "Installation de Docker..."
    curl -fsSL https://get.docker.com | bash >> "$LOG_FILE" 2>&1 || error_exit "Échec installation Docker"
else
    log "Docker déjà installé"
fi

# Installer Docker Compose
if ! command -v docker-compose &> /dev/null; then
    log "Installation de Docker Compose..."
    apt install -y docker-compose >> "$LOG_FILE" 2>&1 || error_exit "Échec installation Docker Compose"
else
    log "Docker Compose déjà installé"
fi

# Créer dossier Bitwarden
INSTALL_DIR="/opt/bitwarden"
log "Création du dossier $INSTALL_DIR"
mkdir -p "$INSTALL_DIR" || error_exit "Impossible de créer le dossier"
cd "$INSTALL_DIR" || error_exit "Impossible d'accéder au dossier"

# Télécharger Bitwarden
log "Téléchargement du script officiel Bitwarden..."
curl -Lso bitwarden.sh https://go.btwrdn.co/bw-sh >> "$LOG_FILE" 2>&1 || error_exit "Échec téléchargement"

chmod +x bitwarden.sh

# Installation Bitwarden
log "Lancement de l'installation Bitwarden..."
./bitwarden.sh install >> "$LOG_FILE" 2>&1 || error_exit "Échec installation Bitwarden"

log "Démarrage de Bitwarden..."
./bitwarden.sh start >> "$LOG_FILE" 2>&1 || error_exit "Échec démarrage"

log "Installation terminée avec succès !"
log "Consulte le fichier de log : $LOG_FILE"