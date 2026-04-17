#!/usr/bin/env bash

# On arrête le script si une erreur arrive
set -euo pipefail

# Fichier où on va écrire les logs
LOG_FILE="$HOME/vaultwarden_install.log"

# On envoie tout ce qui s'affiche :
# → dans le terminal
# → ET dans le fichier de log
exec > >(tee -a "$LOG_FILE") 2>&1

# Fonction pour écrire un message avec la date
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

# Si erreur → on affiche la ligne qui pose problème
error_exit() {
  log "❌ Erreur à la ligne $1"
  exit 1
}

# On surveille les erreurs
trap 'error_exit $LINENO' ERR

log "=== Début installation Vaultwarden ==="

# On met à jour le système
log "Mise à jour du système"
sudo apt update && sudo apt full-upgrade -y

# On installe les outils nécessaires
log "Installation des dépendances"
sudo apt install -y ca-certificates curl gnupg lsb-release

# On prépare l'installation de Docker
log "Préparation de Docker"
sudo install -m 0755 -d /etc/apt/keyrings

# On ajoute la clé de sécurité Docker (si elle n'existe pas)
if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
  log "Ajout de la clé Docker"
  curl -fsSL https://download.docker.com/linux/debian/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
fi

# On donne les bons droits au fichier
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# On ajoute le dépôt Docker dans Debian
log "Ajout du dépôt Docker"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# On recharge la liste des paquets
sudo apt update

# On installe Docker et Docker Compose
log "Installation de Docker"
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# On démarre Docker
log "Démarrage de Docker"
sudo systemctl enable docker
sudo systemctl start docker

# On crée le dossier du projet
log "Création du dossier Vaultwarden"
mkdir -p "$HOME/vaultwarden"
cd "$HOME/vaultwarden"

# On crée le fichier de configuration Docker
log "Création du docker-compose.yml"
cat > docker-compose.yml <<EOF
version: "3"

services:
  vaultwarden:
    image: vaultwarden/server:latest
    container_name: vaultwarden
    restart: unless-stopped

    # Le service sera accessible sur le port 8080
    ports:
      - "8080:80"

    # Les données sont sauvegardées ici
    volumes:
      - ./data:/data

    # Configuration simple
    environment:
      WEBSOCKET_ENABLED: "true"
      SIGNUPS_ALLOWED: "false"
EOF

# On lance Vaultwarden
log "Démarrage de Vaultwarden"
sudo docker compose up -d

# On vérifie que le conteneur tourne
log "Vérification des conteneurs"
sudo docker ps

# On affiche les derniers logs
log "Derniers logs de Vaultwarden"
sudo docker logs --tail 10 vaultwarden || true

log "=== Installation terminée ==="
log "Accès : http://localhost:8080"
log "Fichier log : $LOG_FILE"