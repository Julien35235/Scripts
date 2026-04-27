#!/bin/bash
# Fichier de log avec date/heure
LOGFILE="$HOME/update_$(date +%Y-%m-%d_%H-%M-%S). log"
echo "=== Début de la mise à jour : $(date) ===" | tee -a "$LOGFILE"
# Mise à jour DietPi
echo "_-- dietpi-update ---" | tee -a "$LOGFILE" sudo dietpi-update 2>&1 | tee -a "$LOGFILE"
# Mise à jour des dépôts
echo "_-- sudo apt update ---"| tee -a "$LOGFILE" sudo apt update 2>&1 | tee -a "$LOGFILE"
# Upgrade complet
echo "_-- sudo apt full-upgrade -y ---" | tee -a "$LOGFILE"
sudo apt full-upgrade -y 2>&1 | tee -a "$LOGFILE"
# Nettoyage optionnel
echo "_-- sudo apt autoremove -y ---" | tee -a "$LOGFILE"
sudo apt autoremove -y 2>&1 | tee -a "$LOGFILE" echo "=== Fin de la mise à jour : $(date) ===" | tee -a "$LOGFILE"
echo "Logs enregistrés dans : $LOGFILE"

