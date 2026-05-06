#!/bin/bash

set -e

### VARIABLES ###
INTERFACE="eth0"
SUBNET="10.135.175.0"
NETMASK="255.255.255.0"
POOL_START="10.135.175.10"
POOL_END="10.135.175.100"
ROUTER="10.135.175.1"
DNS1="10.135.175.2"
DNS2="8.8.4.4"
KEA_CONF="/etc/kea/kea-dhcp4.conf"

echo "=== Mise à jour du système ==="
sudo apt update && sudo apt full-upgrade -y

echo "=== Installation de Kea DHCP ==="
apt install -y kea-dhcp4-server

echo "=== Sauvegarde de la configuration originale ==="
cp $KEA_CONF ${KEA_CONF}.bak

echo "=== Configuration de Kea DHCP ==="
cat > $KEA_CONF <<EOF
{
  "Dhcp4": {
    "interfaces-config": {
      "interfaces": [ "$INTERFACE" ]
    },

    "lease-database": {
      "type": "memfile",
      "persist": true,
      "name": "/var/lib/kea/kea-leases4.csv"
    },

    "valid-lifetime": 86400,
    "renew-timer": 3600,
    "rebind-timer": 7200,

    "subnet4": [
      {
        "subnet": "$SUBNET/24",
        "pools": [
          {
            "pool": "$POOL_START - $POOL_END"
          }
        ],
        "option-data": [
          {
            "name": "routers",
            "data": "$ROUTER"
          },
          {
            "name": "domain-name-servers",
            "data": "$DNS1, $DNS2"
          }
        ]
      }
    ],

    "loggers": [
      {
        "name": "kea-dhcp4",
        "output_options": [
          {
            "output": "/var/log/kea-dhcp4.log"
          }
        ],
        "severity": "INFO"
      }
    ]
  }
}
EOF

echo "=== Vérification de la configuration ==="
kea-dhcp4 -t $KEA_CONF

echo "=== Activation et démarrage du service ==="
systemctl enable kea-dhcp4-server
systemctl restart kea-dhcp4-server

echo "=== Statut du service ==="
systemctl status kea-dhcp4-server --no-pager

echo "Serveur DHCP Kea installé et configuré avec succès"