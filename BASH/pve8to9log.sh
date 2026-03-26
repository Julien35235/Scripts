#!/bin/bash

LOGFILE="/var/log/upgrade_pve.log"

# Création du fichier de log + droits
sudo touch "$LOGFILE"
sudo chmod 644 "$LOGFILE"

{
    echo "===== Début du script : $(date) ====="

    echo "[*] Mise à jour initiale"
    sudo apt update && sudo apt full-upgrade -y

    echo "[*] Redémarrage"
    sudo reboot

    echo "[*] Lancement de pve8to9"
    pve8to9

    echo "[*] Passage de bookworm à trixie dans sources.list"
    sed -i 's/bookworm/trixie/g' /etc/apt/sources.list

    echo "[*] Mise à jour après changement de release"
    sudo apt update
    sudo apt full-upgrade -y

    echo "===== Fin du script : $(date) ====="
} &>> "$LOGFILE"