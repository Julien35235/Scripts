#!/bin/bash

# ======================================
# Vérification des droits root
# ======================================
if [[ $EUID -ne 0 ]]; then
  echo "[ERREUR] Ce script doit être lancé avec sudo."
  exit 1
fi

echo "===== Début de l'installation : $(date) ====="

# ======================================
# Mise à jour du système
# ======================================
echo "[INFO] Mise à jour du système..."
apt update && apt upgrade -y

# ======================================
# Installation Docker (requis pour OpenWebUI)
# ======================================
echo "[INFO] Installation de Docker..."
apt install -y ca-certificates curl gnupg lsb-release

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" \
  | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable --now docker

# ======================================
# Installation d’Ollama
# ======================================
echo "[INFO] Installation d'Ollama..."
curl -fsSL https://ollama.com/install.sh | sh    # [1](https://buanacoding.com/2025/08/install-ollama-openwebui-ubuntu-24-04.html)

echo "[INFO] Activation d'Ollama..."
systemctl enable --now ollama
systemctl status ollama --no-pager

# ======================================
# Installation OpenWebUI (Docker)
# ======================================
echo "[INFO] Installation de OpenWebUI via Docker..."

docker run -d \
  --name open-webui \
  -p 3000:8080 \
  --add-host=host.docker.internal:host-gateway \
  -v open-webui:/app/backend/data \
  --restart unless-stopped \
  ghcr.io/open-webui/open-webui:latest   # [2](https://zahiralam.com/blog/how-to-install-open-webui-with-ollama-on-ubuntu-24-04-for-offline-ai-mastery/)

echo "===== Installation terminée : $(date) ====="
echo "[INFO] Accès OpenWebUI : http://localhost:3000"
echo "[INFO] Vérifiez que le service Ollama tourne : systemctl status ollama"
``