#!/bin/bash

# Mise à jour du système et installation des dépendances
sudo apt update && sudo apt full-upgrade -y
sudo apt autoclean && sudo apt clean
sudo apt install -y mariadb-server apache2 libapache2-mod-perl2 make gcc \
    php php-mysql php-gd php-xml php-mbstring php-curl libxml-simple-perl \
    libdbi-perl libdbd-mysql-perl libapache-dbi-perl libnet-ip-perl php-pclzip \
    libarchive-zip-perl libmojolicious-perl libswitch-perl libplack-perl nala htop

# Sécurisation de MariaDB et création de la base de données OCS
sudo mysql_secure_installation

# Exécution des commandes SQL pour créer la base et l'utilisateur OCS
sudo mysql -e "
CREATE DATABASE ocsdatabase;
CREATE USER 'ocs-user'@'localhost' IDENTIFIED BY 'ocs-mdp';
GRANT ALL PRIVILEGES ON ocsdatabase.* TO 'ocs-user'@'localhost';
FLUSH PRIVILEGES;
"

# Téléchargement et installation d'OCS Inventory
wget https://github.com/PassAndSecure/OCS_inventory/releases/download/OCSNG_UNIX_SERVER-2.12.1/OCSNG_UNIX_SERVER-2.12.1.tar.gz
tar -xvzf OCSNG_UNIX_SERVER-2.12.1.tar.gz
cd OCSNG_UNIX_SERVER-2.12.1
sudo ./setup.sh

# Configuration Apache et permissions
sudo systemctl restart apache2
sudo a2enconf ocsinventory-reports
sudo systemctl reload apache2
sudo chown -R www-data:www-data /usr/share/ocsinventory-reports
sudo chmod -R 755 /usr/share/ocsinventory-reports
sudo chown -R www-data:www-data /var/lib/ocsinventory-reports
sudo chmod -R 755 /var/lib/ocsinventory-reports
sudo systemctl restart apache2

echo "Installation terminée. Accédez à l'interface web d'OCS Inventory via votre navigateur."