#!/bin/bash

LOG_FILE="/var/log/ocs_inventory_install.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "=== Début de l'installation d'OCS Inventory - $(date) ==="

# Mise à jour du système et installation des dépendances
echo "[INFO] Mise à jour du système et installation des dépendances..."
if sudo apt update && sudo apt full-upgrade -y && sudo apt autoclean && sudo apt clean; then
    echo "[SUCCESS] Mise à jour du système terminée."
else
    echo "[ERROR] Échec de la mise à jour du système." >&2
    exit 1
fi

if sudo apt install -y mariadb-server apache2 libapache2-mod-perl2 make gcc \
    php php-mysql php-gd php-xml php-mbstring php-curl libxml-simple-perl \
    libdbi-perl libdbd-mysql-perl libapache-dbi-perl libnet-ip-perl php-pclzip \
    libarchive-zip-perl libmojolicious-perl libswitch-perl libplack-perl nala htop; then
    echo "[SUCCESS] Installation des dépendances terminée."
else
    echo "[ERROR] Échec de l'installation des dépendances." >&2
    exit 1
fi

# Sécurisation de MariaDB
echo "[INFO] Sécurisation de MariaDB..."
if sudo mysql_secure_installation; then
    echo "[SUCCESS] MariaDB sécurisée."
else
    echo "[WARNING] Échec de la sécurisation automatique de MariaDB. Vérifie manuellement."
fi

# Création de la base de données et de l'utilisateur OCS
echo "[INFO] Création de la base de données et de l'utilisateur OCS..."
if sudo mysql -e "
CREATE DATABASE ocsdatabase;
CREATE USER 'ocs-user'@'localhost' IDENTIFIED BY 'ocs-mdp';
GRANT ALL PRIVILEGES ON ocsdatabase.* TO 'ocs-user'@'localhost';
FLUSH PRIVILEGES;"; then
    echo "[SUCCESS] Base de données et utilisateur OCS créés."
else
    echo "[ERROR] Échec de la création de la base de données ou de l'utilisateur." >&2
    exit 1
fi

# Téléchargement et installation d'OCS Inventory
echo "[INFO] Téléchargement d'OCS Inventory..."
OCS_URL="https://github.com/PassAndSecure/OCS_inventory/releases/download/OCSNG_UNIX_SERVER-2.12.1/OCSNG_UNIX_SERVER-2.12.1.tar.gz"
if wget "$OCS_URL"; then
    echo "[SUCCESS] Téléchargement terminé."
else
    echo "[ERROR] Échec du téléchargement d'OCS Inventory." >&2
    exit 1
fi

echo "[INFO] Extraction et installation..."
if tar -xvzf OCSNG_UNIX_SERVER-2.12.1.tar.gz && cd OCSNG_UNIX_SERVER-2.12.1 && sudo ./setup.sh; then
    echo "[SUCCESS] Installation d'OCS Inventory terminée."
else
    echo "[ERROR] Échec de l'installation d'OCS Inventory." >&2
    exit 1
fi

# Configuration Apache et permissions
echo "[INFO] Configuration Apache et permissions..."
if sudo systemctl restart apache2 && \
   sudo a2enconf ocsinventory-reports && \
   sudo systemctl reload apache2 && \
   sudo chown -R www-data:www-data /usr/share/ocsinventory-reports && \
   sudo chmod -R 755 /usr/share/ocsinventory-reports && \
   sudo chown -R www-data:www-data /var/lib/ocsinventory-reports && \
   sudo chmod -R 755 /var/lib/ocsinventory-reports && \
   sudo systemctl restart apache2; then
    echo "[SUCCESS] Configuration Apache et permissions appliquées."
else
    echo "[ERROR] Échec de la configuration Apache ou des permissions." >&2
    exit 1
fi

echo "=== Installation terminée avec succès - $(date) ==="
echo "Accédez à l'interface web d'OCS Inventory via votre navigateur."
echo "Log complet disponible dans : $LOG_FILE"