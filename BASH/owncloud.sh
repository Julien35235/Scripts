#!/bin/bash

############################################
# Script d'installation OwnCloud - Debian
# Auteur : TSSR
# Logs : /var/log/owncloud_install.log
############################################

LOG_FILE="/var/log/owncloud_install.log"

# Rediriger stdout + stderr vers le log
exec > >(tee -a "$LOG_FILE") 2>&1

echo "==============================="
echo " Début installation OwnCloud"
echo " Date : $(date)"
echo "==============================="

# Vérification root
if [[ "$EUID" -ne 0 ]]; then
  echo "[ERREUR] Ce script doit être exécuté en root."
  exit 1
fi

# Variables
DB_NAME="owncloud"
DB_USER="ownclouduser"
DB_PASS="MotDePasseFort"
SERVER_NAME="localhost"

echo "[INFO] Mise à jour du système"
apt update && apt upgrade -y

echo "[INFO] Installation Apache, PHP et dépendances"
apt install -y apache2 mariadb-server wget unzip \
php php-mysql php-gd php-json php-curl php-mbstring \
php-intl php-imagick php-xml php-zip php-bz2 php-apcu

echo "[INFO] Activation modules Apache"
a2enmod rewrite headers env dir mime
systemctl restart apache2

echo "[INFO] Sécurisation MariaDB"
mysql <<EOF
CREATE DATABASE $DB_NAME CHARACTER SET utf8mb4;
CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "[INFO] Téléchargement OwnCloud"
cd /tmp
wget https://download.owncloud.com/server/stable/owncloud-complete-20260218.zip
unzip owncloud-complete-20260218.zip
mv owncloud /var/www/

echo "[INFO] Droits fichiers OwnCloud"
chown -R www-data:www-data /var/www/owncloud
chmod -R 750 /var/www/owncloud

echo "[INFO] Configuration Apache OwnCloud"
cat > /etc/apache2/sites-available/owncloud.conf <<EOF
<VirtualHost *:80>
  ServerName $SERVER_NAME
  DocumentRoot /var/www/owncloud

  <Directory /var/www/owncloud>
    Options +FollowSymlinks
    AllowOverride All
    Require all granted
  </Directory>

  ErrorLog \${APACHE_LOG_DIR}/owncloud_error.log
  CustomLog \${APACHE_LOG_DIR}/owncloud_access.log combined
</VirtualHost>
EOF

a2ensite owncloud.conf
a2dissite 000-default.conf
systemctl reload apache2

echo "==============================="
echo "[SUCCÈS] Installation terminée"
echo "Accès : http://$SERVER_NAME"
echo "Logs : $LOG_FILE"
echo "==============================="