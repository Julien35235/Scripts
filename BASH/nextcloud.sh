#!/bin/bash

LOGFILE="/var/log/nextcloud_install.log"
exec > >(tee -a "$LOGFILE") 2>&1

echo "===== Début de l'installation Nextcloud $(date) ====="

# Mise à jour du système
echo "[1/8] Mise à jour du système..."
sudo apt update && sudo apt upgrade -y

# Installation Apache
echo "[2/8] Installation d'Apache..."
sudo apt install -y apache2

# Installation MariaDB
echo "[3/8] Installation de MariaDB..."
sudo apt install -y mariadb-server

# Sécurisation de MariaDB
echo "[4/8] Sécurisation MariaDB..."
sudo mysql_secure_installation <<EOF
y
n
y
y
y
EOF

# Installation PHP et extensions requises
echo "[5/8] Installation de PHP et extensions..."
sudo apt install -y \
    php libapache2-mod-php php-mysql php-gd php-json php-curl php-mbstring \
    php-intl php-imagick php-xml php-zip php-bcmath php-gmp

# Création de la base de données Nextcloud
echo "[6/8] Création base de données..."
DB_PASS=$(openssl rand -hex 12)

sudo mysql -uroot <<EOF
CREATE DATABASE nextcloud;
CREATE USER 'nextcloud'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "Mot de passe DB Nextcloud : $DB_PASS"

# Téléchargement de Nextcloud
echo "[7/8] Téléchargement de Nextcloud..."
cd /var/www
sudo wget https://download.nextcloud.com/server/releases/latest.zip
sudo apt install -y unzip
sudo unzip latest.zip
sudo chown -R www-data:www-data /var/www/nextcloud

# Configuration Apache
echo "[8/8] Configuration Apache..."
sudo bash -c 'cat <<EOF > /etc/apache2/sites-available/nextcloud.conf
<VirtualHost *:80>
    ServerName localhost
    DocumentRoot /var/www/nextcloud
    <Directory /var/www/nextcloud/>
        Options +FollowSymlinks
        AllowOverride All
        <IfModule mod_dav.c>
            Dav off
        </IfModule>
        SetEnv HOME /var/www/nextcloud
        SetEnv HTTP_HOME /var/www/nextcloud
    </Directory>
    ErrorLog \${APACHE_LOG_DIR}/nextcloud_error.log
    CustomLog \${APACHE_LOG_DIR}/nextcloud_access.log combined
</VirtualHost>
EOF'

sudo a2ensite nextcloud.conf
sudo a2enmod rewrite headers env dir mime
sudo systemctl reload apache2

echo "===== Installation terminée ! Accédez à http://<IP-du-serveur>/ ====="
echo "Mot de passe DB Nextcloud : $DB_PASS"