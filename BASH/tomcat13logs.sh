#!/bin/bash

# =============================
#  CONFIGURATION DES LOGS
# =============================
LOGFILE="/var/log/install_tomcat11.log"
exec > >(tee -a "$LOGFILE") 2>&1
echo "===== Début du script : $(date) ====="

# =============================
#  MISE À JOUR DU SYSTÈME
# =============================
echo "[INFO] Mise à jour des dépôts…"
sudo apt update && sudo apt full-upgrade -y

# =============================
#  INSTALLATION DES OUTILS
# =============================
echo "[INFO] Installation des outils requis…"
sudo apt install wget nala htop -y

# =============================
#  INSTALLATION DE TOMCAT 11
# =============================
echo "[INFO] Téléchargement de Tomcat 11…"
cd /tmp || exit 1
sudo wget https://dlcdn.apache.org/tomcat/tomcat-11/v11.0.11/bin/apache-tomcat-11.0.11.tar.gz

echo "[INFO] Extraction…"
sudo tar zxvf apache-tomcat-11.0.11.tar.gz

echo "[INFO] Déplacement dans /usr/libexec/tomcat11…"
sudo mv apache-tomcat-11.0.11 /usr/libexec/tomcat11

# =============================
#  UTILISATEUR TOMCAT
# =============================
echo "[INFO] Création de l'utilisateur tomcat…"
sudo useradd -M -d /usr/libexec/tomcat11 tomcat || true

echo "[INFO] Attribution des permissions…"
sudo chown -R tomcat:tomcat /usr/libexec/tomcat11

# =============================
#  SERVICE SYSTEMD TOMCAT 11
# =============================
echo "[INFO] Création du service systemd…"

sudo bash -c 'cat > /usr/lib/systemd/system/tomcat11.service <<EOF
[Unit]
Description=Apache Tomcat 11
After=network.target

[Service]
Type=forking
ExecStart=/usr/libexec/tomcat11/bin/startup.sh
ExecStop=/usr/libexec/tomcat11/bin/shutdown.sh
User=tomcat
Group=tomcat

[Install]
WantedBy=multi-user.target
EOF'

# =============================
#  ACTIVATION DU SERVICE
# =============================
echo "[INFO] Activation et démarrage de Tomcat 11…"
sudo systemctl daemon-reload
sudo systemctl enable --now tomcat11

echo "===== Fin du script : $(date) ====="
