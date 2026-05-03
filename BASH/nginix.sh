#!/bin/bash

# Vérification de l'utilisateur
if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être exécuté en tant que root" 
   exit 1
fi

# Mise à jour des paquets
echo "Mise à jour des paquets..."
apt update && apt full-upgrade -y

# Installation des dépendances nécessaires
echo "Installation des dépendances..."
apt install -y sudo curl apt-transport-https ca-certificates lsb-release gnupg2 \
    curl wget lsb-release git docker.io docker-compose htop nala 

# Activation et démarrage de Docker
echo "Activation et démarrage de Docker..."
systemctl enable docker
systemctl start docker

# Ajout de l'utilisateur Docker au groupe docker
echo "Ajout de l'utilisateur au groupe docker..."
usermod -aG docker $USER

# Installation de Falc (si non installé)
if ! command -v falc &> /dev/null; then
    echo "Falc non trouvé, installation..."
    curl -fsSL https://get.falc.io | bash
else
    echo "Falc déjà installé"
fi

# Téléchargement et configuration de Nginx Proxy Manager
echo "Téléchargement et configuration de Nginx Proxy Manager..."
git clone https://github.com/jc21/nginx-proxy-manager.git /opt/nginx-proxy-manager
cd /opt/nginx-proxy-manager

# Configuration de Docker Compose
echo "Création du fichier docker-compose.yml..."
cat > docker-compose.yml << EOF
version: '3'
services:
  app:
    image: jc21/nginx-proxy-manager:latest
    container_name: npm
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
      - "81:81"
    environment:
      DB_SQLITE_FILE: /data/database.sqlite
      NPM_PORT: 81
    volumes:
      - /opt/nginx-proxy-manager/data:/data
      - /opt/nginx-proxy-manager/letsencrypt:/etc/letsencrypt
    networks:
      - npm_network
networks:
  npm_network:
    driver: bridge
EOF

# Démarrage des services Docker
echo "Démarrage des conteneurs..."
docker-compose up -d

# Vérification de l'état
echo "Vérification des conteneurs Docker..."
docker ps

echo "Nginx Proxy Manager installé avec succès ! Vous pouvez maintenant y accéder via le port 81 de votre serveur."
echo "URL d'accès : http://<votre-ip>:81"
echo "Identifiants par défaut :"
echo "  - Utilisateur : admin@example.com"
echo "  - Mot de passe : changeme"