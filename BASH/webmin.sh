#!/bin/bash
sudo apt update && sudo apt full-upgrade -y
sudo install nala htop curl ufw -y
cd /opt
curl -o setup-repos.sh https://raw.githubusercontent.com/webmin/webmin/master/setup-repos.sh
sudo sh setup-repos.sh
sudo apt update 
apt install webmin --install-recommends -y
service webmin start
service webmin restart
sudo ufw allow 22
sudo ufw allow 10000
sudo ufw enable