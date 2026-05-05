#!/bin/bash
#Mise à jour du système 
sudo dnf update
sudo dnf upgrade -y
#Installation de tree
dnf install tree -y
#Ajouter le dépot de Grafana
sudo tee /etc/yum.repos.d/grafana.repo <<EOF
[grafana]
name=grafana
baseurl=https://rpm.grafana.com
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://rpm.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
EOF
#Installation du serveur de Grafana
dnf install grafana
#Activation du démarrage automatique de Grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
