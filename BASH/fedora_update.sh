#!/usr/bin/env bash

LOG_DIR="/var/log/update-scripts"
LOG_FILE="$LOG_DIR/fedora-update-$(date +%F_%H-%M-%S).log"

mkdir -p "$LOG_DIR"

echo "===== Début mise à jour Fedora : $(date) =====" | tee -a "$LOG_FILE"

# Vérification root
if [[ $EUID -ne 0 ]]; then
  echo "ERREUR: Ce script doit être exécuté en tant que root." | tee -a "$LOG_FILE"
  exit 1
fi

# Nettoyage des métadonnées
echo "-- Nettoyage cache dnf --" | tee -a "$LOG_FILE"
dnf clean all >>"$LOG_FILE" 2>&1

# Mise à jour complète
echo "-- Lancement dnf upgrade --" | tee -a "$LOG_FILE"
if dnf upgrade -y >>"$LOG_FILE" 2>&1; then
  echo "Mise à jour Fedora terminée avec succès." | tee -a "$LOG_FILE"
else
  echo " ERREUR lors de la mise à jour Fedora." | tee -a "$LOG_FILE"
  exit 2
fi

echo "===== Fin mise à jour Fedora : $(date) =====" | tee -a "$LOG_FILE"
``