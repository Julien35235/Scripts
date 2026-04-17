#!/bin/bash

# === CONFIGURATION DES LOGS ===
LOGFILE="/var/log/install_tomcat.log"
exec > >(tee -a "$LOGFILE") 2>&1

echo "===== Début du script : $(date) ====="

# === MISE À JOUR DU SYSTÈME ===
echo "[INFO] Mise à jour du système…"
sudo apt update && sudo apt full-upgrade -y

# === INSTALLATION DES PACKAGES ===
echo "[INFO] Installation des dépendances et de Tomcat 10…"
sudo apt install default-jdk htop nala tomcat10 tomcat10-admin tomcat10-docs tomcat10-examples -y

# === ACTIVATION DU SERVICE ===
echo "[INFO] Activation et démarrage du service Tomcat…"
sudo systemctl enable tomcat10
sudo systemctl start tomcat10

echo "===== Fin du script : $(date) ====="
