#!/bin/sh
# Installation OPNsense 26.x depuis FreeBSD

set -e

echo "=== Bootstrap OPNsense 26 ==="

# Mise à jour de base
env ASSUME_ALWAYS_YES=yes pkg bootstrap
pkg update -f
pkg upgrade -y

# Outils nécessaires
pkg install -y ca_root_nss curl git

# Téléchargement du bootstrap officiel
fetch https://raw.githubusercontent.com/opnsense/update/master/src/bootstrap/opnsense-bootstrap.sh

# Permissions
chmod +x opnsense-bootstrap.sh

# Lancement du bootstrap
# -y : non interactif
# -r : version majeure
./opnsense-bootstrap.sh -y -r 26.1

echo "=== Installation terminée ==="
echo "Redémarrez pour finaliser."
