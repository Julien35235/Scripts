#!/bin/bash

# =============================================================
# Script d'installation serveur Apache + MariaDB + WordPress
# Avec système de logs complet
# =============================================================

LOGFILE="/var/log/install_wordpress.log"

# Redirection de tous les logs
exec > >(tee -a "$LOGFILE") 2>&1

echo "===== Début de l'installation : $(date) ====="

echo "[1/10] Mise à jour du système"
sudo apt update && sudo apt upgrade -y

echo "[2/10] Installation des paquets nécessaires"
sudo apt install apache2 nala htop php8.2 php8.2-cli php8.2-common php8.2-imap php8.2-redis \
php8.2-snmp php8.2-xml php8.2-mysqli php8.2-zip php8.2-mbstring php8.2-curl \
libapache2-mod-php mariadb-server zip -y

echo "[3/10] Activation des services Apache et MariaDB"
sudo systemctl enable apache2 && sudo systemctl start apache2
sudo systemctl enable mariadb && sudo systemctl start mariadb

echo "[4/10] Création base de données + utilisateur"
mysql -u root -p <<EOF
CREATE DATABASE wordpress_db;
CREATE USER 'wordpress_adm'@'localhost' IDENTIFIED BY 'p@ssw0rd';
GRANT ALL PRIVILEGES ON wordpress_db.* TO 'wordpress_adm'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "[5/10] Téléchargement de WordPress"
cd /var/www/html
wget https://wordpress.org/latest.zip
unzip latest.zip
rm latest.zip

echo "[6/10] Paramétrage des permissions WordPress"
chown -R www-data:www-data wordpress/
cd wordpress/
find . -type d -exec chmod 755 {} \;
find . -type f -exec chmod 644 {} \;
mv wp-config-sample.php wp-config.php

echo "[7/10] Création du VirtualHost Apache"
cd /etc/apache2/sites-available/

cat <<EOF > wordpress.conf
<VirtualHost *:80>
    ServerName yourdomain.com
    DocumentRoot /var/www/html/wordpress

    <Directory /var/www/html/wordpress>
        AllowOverride All
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

echo "[8/10] Activation du site + module rewrite"
sudo a2enmod rewrite
sudo a2ensite wordpress.conf

echo "[9/10] Vérification configuration Apache"
apachectl -t

echo "[10/10] Reload Apache"
systemctl reload apache2

echo "===== Installation terminée : $(date) ====="
echo "Logs disponibles ici : $LOGFILE"