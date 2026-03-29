#l/bin/bash
#Update repo
sudo apt update
#Upgrade systeme 
sudo apt full-upgrade -y
#installation php - apache
sudo apt-get install -y apache2 php libapache2-mod-php php-mysal php-gd php-xml php-mbstring php-curl php-zip php-intl
#Installation mariadb
sudo apt-get install -y mariadb-server mariadb-client
#Securisation Base de données sudo mysql_secure_installation
#Creation database et user
sudo mysql -u root-p-e "CREATE DATABASE glpi; GRANT ALL PRMLEGES ON glpi.* TO 'glpiuser'@'localhost' IDENTIFIED BY 'GLPI;"
#Installation GLPI
sudo wget https://github.com/glpi-project/glpi/releases/download/10.0.15/glpi-10.0.15.tgz
tar -zxvf glpi-10.0.15.tgz
sudo mv glpi /var/www/html/
sudo chown -R www-data:www-data /var/www/html/g|pi/
sudo chmod-755 /var/www/html/glpi/
#Redémarrage Serveur Web
sudo systemct! restart apache2