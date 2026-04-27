#!/usr/bin/env sh

LOG_DIR="/var/log/update-scripts"
LOG_FILE="$LOG_DIR/freebsd-update-$(date +%F_%H-%M-%S).log"

mkdir -p "$LOG_DIR"

echo "===== Début mise à jour FreeBSD : $(date) =====" | tee -a "$LOG_FILE"

# Vérification root
if [ "$(id -u)" -ne 0 ]; then
  echo "ERREUR: Ce script doit être exécuté en tant que root." | tee -a "$LOG_FILE"
  exit 1
fi

# Mise à jour système de base
echo "-- freebsd-update fetch --" | tee -a "$LOG_FILE"
freebsd-update fetch >>"$LOG_FILE" 2>&1

echo "-- freebsd-update install --" | tee -a "$LOG_FILE"
freebsd-update install >>"$LOG_FILE" 2>&1

# Mise à jour des paquets
echo "-- pkg update --" | tee -a "$LOG_FILE"
pkg update >>"$LOG_FILE" 2>&1

echo "-- pkg upgrade --" | tee -a "$LOG_FILE"
if pkg upgrade -y >>"$LOG_FILE" 2>&1; then
  echo "Mise à jour FreeBSD terminée avec succès." | tee -a "$LOG_FILE"
else
  echo " ERREUR lors de la mise à jour des paquets FreeBSD." | tee -a "$LOG_FILE"
  exit 2
fi

echo "===== Fin mise à jour FreeBSD : $(date) =====" | tee -a "$LOG_FILE"
