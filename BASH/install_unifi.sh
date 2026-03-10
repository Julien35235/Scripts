#!/bin/bash
set -euo pipefail

# === CONFIG LOG ===
LOGFILE="/var/log/install_unifi.log"
touch "$LOGFILE"
chmod 644 "$LOGFILE"

log() {
    echo -e "$(date '+%Y-%m-%d %H:%M:%S') [INFO] $1" | tee -a "$LOGFILE"
}

error() {
    echo -e "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] $1" | tee -a "$LOGFILE"
    exit 1
}

log "=== DÉBUT DU SCRIPT D’INSTALLATION UNIFI ==="

# Vérification root
if [[ $EUID -ne 0 ]]; then
    error "Ce script doit être exécuté en root (sudo ./install.sh)."
fi

# --- Mise à jour système ---
log "Mise à jour du système..."
apt update 2>&1 | tee -a "$LOGFILE"
apt full-upgrade -y 2>&1 | tee -a "$LOGFILE"

# --- Installation des paquets ---
log "Installation des paquets : nala wget htop..."
apt install -y nala wget htop 2>&1 | tee -a "$LOGFILE"

# --- Téléchargement script UniFi GlennR via wget ---
UNIFI_SCRIPT="unifi-8.6.9.sh"
UNIFI_URL="https://get.glennr.nl/unifi/install/${UNIFI_SCRIPT}"

log "Téléchargement du script UniFi ($UNIFI_SCRIPT) avec wget..."
wget -q "$UNIFI_URL" -O "$UNIFI_SCRIPT" 2>&1 | tee -a "$LOGFILE"

# --- Exécution du script UniFi ---
log "Exécution du script UniFi..."
bash "$UNIFI_SCRIPT" 2>&1 | tee -a "$LOGFILE"

# --- Nettoyage ---
log "Nettoyage des fichiers temporaires..."
rm -f "$UNIFI_SCRIPT"

log "=== INSTALLATION TERMINÉE ==="
log "Accès au contrôleur : https://<IP-DU-SERVEUR>:8443"

echo -e "\n✔ Installation terminée. Consulte le log : $LOGFILE"