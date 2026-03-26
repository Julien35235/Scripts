#!/bin/bash

# ---- Configuration du fichier de log ----
LOGFILE="/var/log/proxmox-install.log"
mkdir -p /var/log
touch "$LOGFILE"

# Fonction pour logguer avec horodatage
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOGFILE"
}

log "=== Début du script d'installation Proxmox ==="

# ---- Configuration du dépôt Proxmox 9----
log "Création du fichier de dépôt Proxmox 9..."
cat > /etc/apt/sources.list.d/pve-install-repo.sources << EOL
Types: deb
URIs: http://download.proxmox.com/debian/pve
Suites: trixie
Components: pve-no-subscription
Signed-By: /usr/share/keyrings/proxmox-archive-keyring.gpg
EOL

log "Mise à jour des dépôts..."
sudo apt update 2>&1 | tee -a "$LOGFILE"

log "Mise à niveau complète du système..."
sudo apt full-upgrade -y 2>&1 | tee -a "$LOGFILE"

log "Installation des paquets Proxmox..."
sudo apt install -y proxmox-default-kernel proxmox-ve postfix open-iscsi chrony 2>&1 | tee -a "$LOGFILE"

log "Mise à jour de GRUB..."
update-grub 2>&1 | tee -a "$LOGFILE"

log "Installation terminée. Redémarrage en cours..."
sudo reboot