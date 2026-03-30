#!/bin/bash
sudo apt update && sudo apt full-upgrade -y
sudo install nala htop curl -y
cd /opt
curl -o setup-repos.sh https://raw.githubusercontent.com/webmin/webmin/master/setup-repos.sh
sudo bash setup-repos.sh
sudo apt update
sudo nala install webmin --install-recommends -y
sudo systemctl enable webmin
sudo systemctl start webmin