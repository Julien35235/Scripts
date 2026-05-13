#!/bin/bash
#Mise à jour du système 
sudo apt update && sudo apt full-upgrade -y
#Installation des packets 
sudo apt install nala htop wget curl -y
cd /opt
#Recuperation du serveur d'IA de OLLAMA
wget https://ollama.com/download/ollama-linux-amd64.tar.zst
#Extraction de l'archive
tar -C /usr -xvf ollama-linux-*.tar.zst
#Creation d'un utilisateur
useradd -r -s /bin/false -U -m -d /var/lib/ollama ollama
usermod -a -G ollama tssr
#Creation du service systemd de OLLAMA
sudo sed -n '
w /etc/systemd/system/ollama.service
' <<'EOF'
[Unit]
Description=Ollama Service
After=network-online.target

[Service]
ExecStart=/usr/bin/ollama serve
User=ollama
Group=ollama
Restart=always
RestartSec=3
Environment="PATH=$PATH"

[Install]
WantedBy=default.target
EOF
#Rechargement du systemd
systemctl daemon-reload
#Activation du demmarage automatique du service Ollama
systemctl enable --now ollama