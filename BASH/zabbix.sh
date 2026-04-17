#!/bin/bash

LOGFILE="/var/log/zabbix_install.log"

exec > >(tee -a $LOGFILE) 2>&1

echo "=== Début de l'installation de Zabbix ==="
date

# Variables
DB_PASS="zabbix_password"
ZABBIX_VERSION="7.0"

echo "[1/8] Mise à jour du système..."
apt update && apt upgrade -y

echo "[2/8] Installation des dépendances..."
apt install wget gnupg2 lsb-release -y

echo "[3/8] Ajout du dépôt Zabbix..."
wget https://repo.zabbix.com/zabbix/${ZABBIX_VERSION}/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest+ubuntu$(lsb_release -rs)_all.deb
dpkg -i zabbix-release_latest+ubuntu$(lsb_release -rs)_all.deb
apt update

echo "[4/8] Installation des paquets Zabbix..."
apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent mariadb-server -y

echo "[5/8] Configuration de la base de données..."
systemctl start mariadb
systemctl enable mariadb

mysql -uroot <<EOF
CREATE DATABASE zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE USER 'zabbix'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "[6/8] Import du schéma initial..."
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql -uzabbix -p${DB_PASS} zabbix

echo "[7/8] Configuration du serveur Zabbix..."
sed -i "s/# DBPassword=/DBPassword=${DB_PASS}/" /etc/zabbix/zabbix_server.conf

echo "[8/8] Démarrage des services..."
systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2

echo "=== Installation terminée ==="
echo "Accède à l'interface web via : http://<IP_SERVER>/zabbix"
date