#!/bin/bash

# ======================================
# Vérification root
# ======================================
if [[ $EUID -ne 0 ]]; then
  echo "[ERREUR] Exécute moi avec sudo !"
  exit 1
fi

echo "===== Installation Ollama + OpenWebUI (Sans Docker) ====="

# ======================================
# MISE À JOUR
# ======================================
apt update && apt upgrade -y

# ======================================
# INSTALLATION OLLAMA
# ======================================
echo "[INFO] Installation d'Ollama..."
curl -fsSL https://ollama.com/install.sh | sh
systemctl enable --now ollama

# ======================================
# INSTALLATION DEPENDANCES OPENWEBUI
# ======================================
echo "[INFO] Installation dépendances système..."
apt install -y git curl wget unzip build-essential python3.10 python3.10-venv python3-pip nodejs npm

# Vérif Node version
NODE_V=$(node -v | cut -d'.' -f1 | tr -d 'v')
if [[ $NODE_V -lt 18 ]]; then
  echo "[INFO] Mise à jour Node.js vers v18..."
  curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
  apt install -y nodejs
fi

# ======================================
# CLONE REPO OPENWEBUI
# ======================================
echo "[INFO] Clonage OpenWebUI..."
git clone https://github.com/open-webui/open-webui.git /opt/open-webui
cd /opt/open-webui

# ======================================
# FRONTEND OPENWEBUI
# ======================================
echo "[INFO] Installation dépendances frontend..."
npm i
npm run build

# ======================================
# BACKEND PYTHON
# ======================================
cd backend
echo "[INFO] Environnement Python..."
python3.10 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

# ======================================
# PATCHES COMPATIBILITÉ PYTHON 3.10
# ======================================
echo "[INFO] Application des correctifs Python 3.10..."

# 1. Ajout StrEnum manquant
sed -i 's/from enum import StrEnum/from enum import Enum\nclass StrEnum(str, Enum): pass/' open_webui/retrieval/vector/type.py

# 2. Correction getLevelNamesMapping() absent
sed -i 's/getLevelNamesMapping()/{"DEBUG","INFO","WARNING","ERROR","CRITICAL"}/' open_webui/env.py || true
sed -i 's/getLevelNamesMapping()/{"DEBUG","INFO","WARNING","ERROR","CRITICAL"}/' utils/logger.py || true

# ======================================
# CRÉATION SERVICE SYSTEMD
# ======================================
echo "[INFO] Création du service systemd OpenWebUI..."

cat <<EOF > /etc/systemd/system/openwebui.service
[Unit]
Description=OpenWebUI (No Docker)
After=network.target

[Service]
Type=simple
WorkingDirectory=/opt/open-webui/backend
Environment="PATH=/opt/open-webui/backend/venv/bin"
ExecStart=/opt/open-webui/backend/venv/bin/python3 -m uvicorn open_webui.main:app --host 0.0.0.0 --port 3000
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable openwebui
systemctl start openwebui

echo "===== INSTALLATION TERMINEE ====="
echo "✅ OpenWebUI accessible : http://localhost:3000"
echo "✅ Ollama API : http://localhost:11434"
echo "✅ Service : systemctl status openwebui"