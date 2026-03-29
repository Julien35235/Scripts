#!/bin/bash
sudo apt update && sudo apt full-upgrade -y
sudo apt installl htop nala wget -y
wget https://github.com/glpi-project/glpi-agent/releases/download/1.15/glpi-agent-1.15-linux-installer.pl
sudo perl glpi-agent-linux-installer.pl
glpi-agent –force 

