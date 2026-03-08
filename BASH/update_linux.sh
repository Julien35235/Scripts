#!/bin/bash
# Contenu du script "script.sh"
echo ">>------------------------------------------------$(date)---------------------------------------------<<" >> /var>
echo ">>------------------errors------------------------------$(date)---------------errors----------------------------->
export DEBIAN_FRONTEND=noninteractive
apt-get update && apt full-upgrade -y >> /var/log/update_upgrade.log 2>> /var/log/update_upgrade.

https://www.it-connect.fr/automatiser-le-processus-de-mise-a-jour-apt-sur-debian/