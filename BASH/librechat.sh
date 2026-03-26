#!/bin/bash

set -e

echo "=== Mise à jour du système ==="
sudo apt update && sudo apt upgrade -y

echo "=== Installation des dépendances nécessaires ==="
sudo apt install -y ca-certificates curl gnupg git

echo "=== Installation de Docker ==="
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo $VERSION_CODENAME) stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "=== Activation de Docker ==="
sudo systemctl enable docker
sudo systemctl start docker

echo "=== Récupération du dépôt LibreChat ==="
if [ ! -d "LibreChat" ]; then
    git clone https://github.com/danny-avila/LibreChat.git
fi

cd LibreChat

echo "=== Préparation de la configuration ==="

if [ ! -f ".env" ]; then
    cp .env.example .env
    sed -i 's/OPENAI_API_KEY=/OPENAI_API_KEY=VOTRE_CLE_ICI/g' .env
fi

echo "=== Construction des images Docker ==="
sudo docker compose build

echo "=== Lancement de LibreChat ==="
sudo docker compose up -d

echo "=== Installation terminée ! ==="
echo "LibreChat est disponible sur : http://localhost:3080"