#!/bin/bash

#Update repo
sudo apt update

#Upgrade du système
sudo apt full-upgrade -y

#Installation du firewall
sudo apt install ufw -y

#Regles de securité du firewall
sudo ufw allow ssh
sudo ufw allow http


#Installation du serveur web et de PHP mariadb
sudo apt install -y apache2 mariadb-server mariadb-client

# les dépendances PHP de base
sudo apt install php-{mysql,mbstring,curl,gd,xml,intl,ldap,apcu,xmlrpc,zip,bz2,bcmath} -y

#Securisation de la base de données
sudo mysql_secure_installation
#Creation de la base de données et user
mysql -u root -p -e "CREATE DATABASE glpi_db;CREATE USER 'glpi_adm'@'localhost' IDENTIFIED by 'p@ssw0rd';GRANT ALL PRIVILEGES ON glpi_db.* TO 'glpi_adm'@'localhost';FLUSH PRIVILEGES";

# Se deplacer dans le dossier HTML
cd /var/www/html

#Télecharger le serveur GLPI en utilisant la commande wget
sudo wget https://github.com/glpi-project/glpi/releases/download/11.0.6/glpi-11.0.6.tgz
tar -xvzf glpi-11.0.6.tgz

# Les permissions du serveur GLPI
sudo chown -R www-data:www-data /var/www/html/glpi
sudo chown -R 755 /var/www/html/glpi

# Activation du demarrage automatique du serveur WEB Apache
sudo systemctl enable apache2
sudo systemctl restart apache2

#Dans le dossier d’apache2, créez un fichier nommé par exemple « glpi.conf »
#nano /etc/apache2/sites-available/glpi.conf
a2enmod rewrite
a2dissite 000-default.conf
a2ensite glpi.conf
systemctl restart apache2


