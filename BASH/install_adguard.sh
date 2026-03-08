#!/bin/bash
#Installation de curl
apt install curl htop nala -y
#Installation du serveur de DNS
curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v
service AdGuardHome start