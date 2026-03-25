#!/bin/bash

LOGFILE="/var/log/proxmox_install.log"

# Fonction de log
log() {
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOGFILE"
}

# Démarrage
log "===== Début du script d'installation Proxmox ====="

log "Adresse IP de la machine :"
hostname --ip-address 2>&1 | tee -a "$LOGFILE"

log "Mise à jour du système..."
apt update && apt full-upgrade -y >> "$LOGFILE" 2>&1
log "Mise à jour terminée."

log "Installation des dépendances..."
apt install -y curl software-properties-common apt-transport-https ca-certificates gnupg2 >> "$LOGFILE" 2>&1
log "Dépendances installées."

log "Ajout du dépôt Proxmox..."
echo "deb [arch=amd64] http://download.proxmox.com/debian/pve bookworm pve-no-subscription" \
    > /etc/apt/sources.list.d/pve-install-repo.list
log "Dépôt ajouté."

log "Mise à jour après ajout du dépôt..."
apt update && apt full-upgrade -y >> "$LOGFILE" 2>&1
log "Mise à jour terminée."

log "Installation de Proxmox VE..."
apt install -y proxmox-default-kernel proxmox-ve postfix open-iscsi chrony >> "$LOGFILE" 2>&1
log "Proxmox VE installé."

log "Mise à jour du GRUB..."
update-grub >> "$LOGFILE" 2>&1
log "GRUB mis à jour."

log "===== Fin du script d'installation Proxmox ====="