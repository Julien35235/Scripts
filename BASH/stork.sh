#!/bin/bash
echo " Mise à jour du système..."
sudo apt update  && sudo apt full-upgrade -y
echo "Installation de Stork Server sur Debian"
sudo apt install curl wget -y
curl -1sLf 'https://dl.cloudsmith.io/public/isc/stork/cfg/setup/bash.deb.sh' | sudo bash
sudo apt update
sudo apt install isc-stork-server
echo "Installation et préparation de PostgreSQL"
sudo apt install postgresql postgresql-contrib -y
sudo systemctl start postgresql
sudo systemctl enable PostgreSQL
sudo -u postgres stork-tool db-create --db-name db_stork --db-user user_stork
echo "Demarrage automatique du serveur DHCP KEA"
sudo systemctl enable isc-stork-server
sudo systemctl start isc-stork-server
