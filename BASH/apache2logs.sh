#!/bin/bash

# ======================================
#  CONFIGURATION DES LOGS
# ======================================
LOGFILE="/var/log/install_apache.log"
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
echo "[INFO] Installation des paquets htop, nala et apache2..."
sudo apt install -y htop nala apache2

# ======================================
#  ACTIVATION DU SERVICE APACHE2
# ======================================
echo "[INFO] Activation du service Apache2..."
sudo systemctl enable apache2

# ======================================
#  DÉMARRAGE DU SERVICE
# ======================================
echo "[INFO] Démarrage du service Apache2..."
sudo systemctl start apache2

echo "===== Fin du script : $(date) ====="
echo "[INFO] Installation terminée. Logs disponibles dans : $LOGFILE"