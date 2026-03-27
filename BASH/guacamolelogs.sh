#!/bin/bash

# ============================================================
#     Script d’installation Apache Guacamole (Debian 12/13)
#     Avec journalisation complète dans /var/log/guacamole_install.log
# ============================================================

LOGFILE="/var/log/guacamole_install.log"
exec > >(tee -a "$LOGFILE") 2>&1

echo "===== Début du script : $(date) ====="

if [[ $EUID -ne 0 ]]; then
  echo "❌ Ce script doit être exécuté en root."
  exit 1
fi

echo "✅ Mise à jour du système..."
apt update && apt upgrade -y

echo "✅ Installation des dépendances Guacamole..."
apt install -y build-essential make gcc libcairo2-dev libjpeg62-turbo-dev libpng-dev \
libtool-bin uuid-dev libossp-uuid-dev libvncserver-dev libssh2-1-dev libssl-dev \
libtelnet-dev libpango1.0-dev libwebsockets-dev libavcodec-dev libavformat-dev \
libavutil-dev libswscale-dev libvorbis-dev libwebp-dev libpulse-dev wget curl

echo "✅ Installation freerdp2-dev (support RDP)..."
apt install -y freerdp2-dev || true

echo "✅ Installation Tomcat & MariaDB..."
apt install -y tomcat10 mariadb-server

echo "✅ Téléchargement Guacamole 1.6.0..."
cd /tmp
wget https://downloads.apache.org/guacamole/1.6.0/source/guacamole-server-1.6.0.tar.gz
wget https://downloads.apache.org/guacamole/1.6.0/binary/guacamole-1.6.0.war
wget https://downloads.apache.org/guacamole/1.6.0/binary/guacamole-auth-jdbc-1.6.0.tar.gz

echo "✅ Extraction des fichiers..."
tar -xzf guacamole-server-1.6.0.tar.gz
tar -xzf guacamole-auth-jdbc-1.6.0.tar.gz

echo "✅ Compilation et installation guacd..."
cd guacamole-server-1.6.0
./configure --with-init-dir=/etc/init.d
make -j$(nproc)
make install
ldconfig

systemctl enable guacd
systemctl start guacd

echo "✅ Déploiement du client Guacamole dans Tomcat..."
cp /tmp/guacamole-1.6.0.war /var/lib/tomcat10/webapps/guacamole.war
systemctl restart tomcat10

echo "✅ Configuration des répertoires Guacamole..."
mkdir -p /etc/guacamole
mkdir -p /var/lib/guacamole/{extensions,lib}

echo "✅ Installation extensions JDBC..."
cp /tmp/guacamole-auth-jdbc-1.6.0/mysql/*.jar /var/lib/guacamole/extensions/
apt install -y default-mysql-client

echo "✅ Création base de données Guacamole..."
mysql -u root <<EOF
CREATE DATABASE guacamole_db;
CREATE USER 'guacuser'@'localhost' IDENTIFIED BY 'guacpwd';
GRANT SELECT,INSERT,UPDATE,DELETE ON guacamole_db.* TO 'guacuser'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "✅ Importation du schéma SQL..."
cat /tmp/guacamole-auth-jdbc-1.6.0/mysql/schema/*.sql | mysql -u root guacamole_db

echo "✅ Création du fichier guacamole.properties..."
cat <<EOF > /etc/guacamole/guacamole.properties
guacd-hostname: localhost
guacd-port: 4822

mysql-hostname: localhost
mysql-port: 3306
mysql-database: guacamole_db
mysql-username: guacuser
mysql-password: guacpwd
EOF

echo "✅ Lien symbolique Tomcat..."
ln -sf /etc/guacamole /var/lib/tomcat10/.guacamole

echo "✅ Redémarrage des services..."
systemctl restart tomcat10
systemctl restart guacd

echo "===== Fin du script : $(date) ====="
echo "🎉 Installation terminée !"
echo "🌐 Accès : http://<IP-SERVEUR>:8080/guacamole"
echo "📄 Logs disponibles ici : $LOGFILE"