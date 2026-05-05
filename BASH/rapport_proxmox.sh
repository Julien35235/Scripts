#!/bin/bash

# Configuration
MAIL_TO="tonmail@tssr.local"
HOSTNAME=$(hostname)
DATE=$(date "+%d/%m/%Y %H:%M:%S")
UPTIME=$(uptime -p)
LOAD=$(uptime | awk -F'load average:' '{print $2}')

# Contenu du rapport
REPORT="
Rapport horaire Proxmox
-----------------------
Serveur : $HOSTNAME
Date    : $DATE

Uptime  : $UPTIME
Charge  : $LOAD
"

# Envoi par mail
echo "$REPORT" | mail -s "Rapport horaire Proxmox - $HOSTNAME" "$MAIL_TO"