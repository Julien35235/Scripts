#!/bin/bash
# Apache Guacamole 1.6.0 Installer for Debian 12/13
# Based on ComputingForGeeks (March 2026)

if [[ $EUID -ne 0 ]]; then
  echo " Ce script doit être exécuté avec sudo ou en root."
  exit 1
fi

echo "Mise à jour du système…"
apt update && apt upgrade -y

echo " Installation des dépendances de compilation…"
apt install -y build-essential make gcc libcairo2-dev libjpeg62-turbo-dev libpng-dev \
libtool-bin uuid-dev libossp-uuid-dev libvncserver-dev libssh2-1-dev libssl-dev \
libtelnet-dev libpango1.0-dev libwebsockets-dev libavcodec-dev libavformat-dev \
libavutil-dev libswscale-dev libvorbis-dev libwebp-dev libpulse-dev wget curl

# RDP note: Debian 12 OK, Debian 13 incompatible FreeRDP3 (source: CFG)
apt install -y freerdp2-dev || true

echo "Installation Tomcat + MariaDB"
apt install -y tomcat10 mariadb-server

echo "Téléchargement de Guacamole 1.6.0"
cd /tmp
wget https://downloads.apache.org/guacamole/1.6.0/source/guacamole-server-1.6.0.tar.gz
wget https://downloads.apache.org/guacamole/1.6.0/binary/guacamole-1.6.0.war
wget https://downloads.apache.org/guacamole/1.6.0/binary/guacamole-auth-jdbc-1.6.0.tar.gz

echo " Extraction sources Guacamole…"
tar -xzf guacamole-server-1.6.0.tar.gz
tar -xzf guacamole-auth-jdbc-1.6.0.tar.gz

echo "Compilation & installation de guacd…"
cd guacamole-server-1.6.0
./configure --with-init-dir=/etc/init.d
make -j$(nproc)
make install
ldconfig

systemctl enable guacd
systemctl start guacd

echo " Déploiement du client Web dans Tomcat…"
cp /tmp/guacamole-1.6.0.war /var/lib/tomcat10/webapps/guacamole.war
systemctl restart tomcat10

echo " Configuration du répertoire Guacamole…"
mkdir -p /etc/guacamole
mkdir -p /var/lib/guacamole/{extensions,lib}

echo " Installation extension JDBC (MariaDB)…"
cp /tmp/guacamole-auth-jdbc-1.6.0/mysql/*.jar /var/lib/guacamole/extensions/
apt install -y default-mysql-client

echo "Création base de données Guacamole…"
mysql -u root <<EOF
CREATE DATABASE guacamole_db;
CREATE USER 'guacuser'@'localhost' IDENTIFIED BY 'guacpwd';
GRANT SELECT,INSERT,UPDATE,DELETE ON guacamole_db.* TO 'guacuser'@'localhost';
FLUSH PRIVILEGES;
EOF

echo " Import des tables SQL Guacamole…"
cat /tmp/guacamole-auth-jdbc-1.6.0/mysql/schema/*.sql | mysql -u root guacamole_db

echo " Création guacamole.properties…"

cat <<EOF > /etc/guacamole/guacamole.properties
guacd-hostname: localhost
guacd-port: 4822

mysql-hostname: localhost
mysql-port: 3306
mysql-database: guacamole_db
mysql-username: guacuser
mysql-password: guacpwd
EOF

echo " Lien symbolique vers Tomcat"
ln -s /etc/guacamole /var/lib/tomcat10/.guacamole

systemctl restart tomcat10
systemctl restart guacd

echo " Installation terminée !"
echo " Accès Guacamole : http://<IP-SERVEUR>:8080/guacamole"
echo " Connectez-vous avec le compte admin créé dans la base SQL."