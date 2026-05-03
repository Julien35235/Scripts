#!/bin/bash

set -e

echo " Mise à jour des paquets..."
apt update && apt upgrade -y

echo "Installation de Chrony (serveur NTP)..."
apt install -y chrony

echo "Configuration de Chrony..."

CONFIG_FILE="/etc/chrony/chrony.conf"

# Sauvegarde
cp $CONFIG_FILE ${CONFIG_FILE}.bak

# Configuration minimale
cat > $CONFIG_FILE <<EOF
# Serveurs NTP publics
pool 0.debian.pool.ntp.org iburst
pool 1.debian.pool.ntp.org iburst
pool 2.debian.pool.ntp.org iburst
pool 3.debian.pool.ntp.org iburst

# Autoriser réseau local (à adapter)
allow 192.168.0.0/16

# Synchronisation rapide
makestep 1.0 3

# Fichier de dérive
driftfile /var/lib/chrony/chrony.drift

# Logs
logdir /var/log/chrony
EOF

echo "Redémarrage du service..."
systemctl restart chrony
systemctl enable chrony

echo " Vérification du service..."
systemctl status chrony --no-pager

echo " Sources NTP :"
chronyc sources

echo "Installation et configuration terminées."