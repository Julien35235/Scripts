#!/bin/bash
# ======================================
#  CONFIGURATION DES LOGS
# ======================================
LOGFILE="/var/log/install_clonezilla.log"
exec > >(tee -a "$LOGFILE") 2>&1
echo "===== Début du script : $(date) ====="

# ======================================
#  MISE À JOUR DU SYSTÈME
# ======================================
echo "[INFO] Mise à jour du système..."
sudo apt update && sudo apt full-upgrade -y

# ======================================
#  INSTALLATION DES PAQUETS
# ======================================
echo "[INFO] Installation des paquets htop, nala et clonezilla..."
sudo apt install htop nala clonezilla -y

# ======================================
# Lancements de Clonezilla
# ======================================
echo "[INFO] Activation du service de Clonezilla..."
sudo clonezilla

echo "===== Fin du script : $(date) ====="
echo "[INFO] Installation terminée. Logs disponibles dans : $LOGFILE"
