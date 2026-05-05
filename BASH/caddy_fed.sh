#!/bin/bash
#Mise à jour du système 
sudo dnf update 
sudo dnf upgrade -y
#Installation du RP de Caddy
dnf install caddy -y
#Activation du service de demarrage automatique de Caddy
sudo systemctl enable --now caddy
#Creation du répetoire pour le Caddy
mkdir -p /var/www/example.com/html
mkdir /var/log/caddy
chown caddy:caddy /var/www/example.com/html -R
chown caddy:caddy /var/log/caddy