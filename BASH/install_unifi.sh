#!/bin/bash

# Arrêt du script si une commande échoue
set -e

# Emplacement du fichier log
LOGFILE="/var/log/unifi_install.log"

# Création du fichier log
sudo touch "$LOGFILE"
sudo chmod 644 "$LOGFILE"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOGFILE"
}

log "=== Début de l'installation Unifi + MongoDB ==="

log "Mise à jour du système..."
sudo apt update 2>&1 | tee -a "$LOGFILE"
sudo apt full-upgrade -y 2>&1 | tee -a "$LOGFILE"

log "Installation des outils requis..."
sudo apt install -y wget nala htop software-properties-common apt-transport-https gnupg 2>&1 | tee -a "$LOGFILE"


##############################
# INSTALLATION MONGODB 4.4
##############################

log "Téléchargement libssl1.1..."
wget http://ftp.debian.org/debian/pool/main/o/openssl/libssl1.1_1.1.1w-0+deb11u1_amd64.deb \
    -O libssl.deb 2>&1 | tee -a "$LOGFILE"

log "Installation libssl1.1..."
sudo dpkg -i libssl.deb 2>&1 | tee -a "$LOGFILE" || sudo apt --fix-broken install -y

log "Téléchargement MongoDB 4.4..."
wget https://repo.mongodb.org/apt/debian/dists/buster/mongodb-org/4.4/main/binary-amd64/mongodb-org-server_4.4.27_amd64.deb \
    -O mongodb.deb 2>&1 | tee -a "$LOGFILE"

log "Installation MongoDB..."
sudo dpkg -i mongodb.deb 2>&1 | tee -a "$LOGFILE" || sudo apt --fix-broken install -y

log "Activation du service MongoDB..."
sudo systemctl enable mongod 2>&1 | tee -a "$LOGFILE"
sudo systemctl start mongod 2>&1 | tee -a "$LOGFILE"


##############################
# INSTALLATION DE JAVA
##############################

log "Installation de Java..."
sudo apt install -y default-jdk 2>&1 | tee -a "$LOGFILE"


##############################
# INSTALLATION UNIFI
##############################

log "Ajout du dépôt Unifi..."
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/ubiquiti-archive-keyring.gpg] https://www.ui.com/downloads/unifi/debian stable ubiquiti' \
    | sudo tee /etc/apt/sources.list.d/100-ubnt-unifi.list >/dev/null

log "Téléchargement de la clé GPG..."
curl https://dl.ui.com/unifi/unifi-repo.gpg | sudo tee /usr/share/keyrings/ubiquiti-archive-keyring.gpg >/dev/null

log "Mise à jour APT..."
sudo apt update 2>&1 | tee -a "$LOGFILE"

log "Installation du contrôleur Unifi..."
sudo apt install -y unifi 2>&1 | tee -a "$LOGFILE"

log "=== Installation complète : MongoDB + Unifi opérationnels ==="
``
