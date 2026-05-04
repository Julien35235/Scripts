# Contenu du script "script.sh"
#!/bin/bash
echo ">>------------------------------------------------$(date)---------------------------------------------<<" >> /var/log/update_upgrade.log
echo ">>------------------errors------------------------------$(date)---------------errors------------------------------<<" >> /var/log/update_upgrade.err
export DEBIAN_FRONTEND=noninteractive
sudo dnf update && sudo dnf upgrade -y >> /var/log/update_upgrade.log 2>> /var/log/update_upgrade.err

https://www.it-connect.fr/automatiser-le-processus-de-mise-a-jour-apt-sur-debian/