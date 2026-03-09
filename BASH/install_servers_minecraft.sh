#!/bin/bash

# Arrêt du script si une commande échoue
set -e

# Emplacement du fichier log
LOGFILE="/var/log/minecraft_install.log"

# Création du fichier log
sudo touch "$LOGFILE"
sudo chmod 644 "$LOGFILE"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOGFILE"
}

log "=== Début de l'installation du serveur Minecraft ==="

log "Mise à jour du système..."
sudo apt update 2>&1 | tee -a "$LOGFILE"
sudo apt upgrade -y 2>&1 | tee -a "$LOGFILE"

log "Installation des dépendances..."
sudo apt install -y software-properties-common screen wget apt-transport-https gnupg nala htop 2>&1 | tee -a "$LOGFILE"

log "Téléchargement et installation de Java 21..."
cd /tmp
wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.deb 2>&1 | tee -a "$LOGFILE"
sudo apt install ./jdk-21_linux-x64_bin.deb -y 2>&1 | tee -a "$LOGFILE"

log "Création du dossier Minecraft..."
sudo mkdir -p /opt/minecraft
cd /opt/minecraft

log "Téléchargement du serveur Minecraft..."
sudo wget https://piston-data.mojang.com/v1/objects/4707d00eb834b446575d89a61a11b5d548d8c001/server.jar 2>&1 | tee -a "$LOGFILE"

log "Génération du fichier eula.txt..."
sudo java -Xms512M -Xmx512M -jar server.jar nogui || true
sudo sed -i 's/eula=false/eula=true/' /opt/minecraft/eula.txt

log "Création du script de démarrage..."
echo "java -Xmx4G -Xms4G -jar server.jar nogui" | sudo tee /opt/minecraft/start_minecraft.sh > /dev/null
sudo chmod +x /opt/minecraft/start_minecraft.sh

log "Lancement du serveur Minecraft..."
sudo /opt/minecraft/start_minecraft.sh 2>&1 | tee -a "$LOGFILE"

log "=== Installation complète ! Serveur Minecraft opérationnel ==="
