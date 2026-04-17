#!/bin/bash

# ----------------------------------------------------------
# Installation complète RaspiSMS sur Debian / Raspberry Pi OS
# Avec : Apache2, MariaDB, Gammu, logs + logrotate
# Basé sur le tutoriel IT-Connect
# ----------------------------------------------------------

if [ "$EUID" -ne 0 ]; then
  echo "Merci d'exécuter ce script en root ou sudo."
  exit 1
fi

echo " Mise à jour du système..."
sudo apt update  && sudo apt full-upgrade -y

echo "Installation des dépendances..."
sudo apt install ca-certificates apt-transport-https software-properties-common \
wget curl lsb-release gnupg2 git apache2 mariadb-server gammu gammu-smsd python3-gammu -y

echo "Installation de PHP..."
sudo apt install php php-cli php-mysql php-json php-curl php-mbstring php-xml  -y

echo " Ajout du dépôt officiel RaspiSMS..."
echo "deb https://apt.raspisms.fr/ buster contrib" > /etc/apt/sources.list.d/raspisms.list
curl https://apt.raspisms.fr/conf/pub.gpg.key | apt-key add -

sudo apt update 

echo " Installation de RaspiSMS..."
sudo apt install  raspisms -y

echo " Configuration Apache2..."
cat >/etc/apache2/sites-available/raspisms.conf <<EOF
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /usr/share/raspisms/public
    <Directory /usr/share/raspisms/public>
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog /var/log/apache2/raspisms_error.log
    CustomLog /var/log/apache2/raspisms_access.log combined
</VirtualHost>
EOF

a2enmod rewrite
a2ensite raspisms
systemctl reload apache2

echo " Mise en place du service systemd RaspiSMS..."
cat >/etc/systemd/system/raspisms.service <<EOF
[Unit]
Description=RaspiSMS Daemon
After=network.target

[Service]
ExecStart=/usr/bin/php /usr/share/raspisms/bin/console raspisms:run
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now raspisms

echo "Mise en place de la rotation des logs RaspiSMS..."
cat >/etc/logrotate.d/raspisms <<EOF
/var/log/apache2/raspisms_*.log {
    weekly
    rotate 12
    compress
    missingok
    notifempty
    create 640 root adm
    sharedscripts
    postrotate
        /usr/sbin/service apache2 reload > /dev/null
    endscript
}

/usr/share/raspisms/var/logs/*.log {
    weekly
    rotate 8
    compress
    missingok
    notifempty
    create 640 www-data www-data
}
EOF

echo " Installation terminée."

echo " Identifiants RaspiSMS :"
cat /usr/share/raspisms/.credentials

echo " Accès Web : http://ADRESSE_IP/raspisms"
