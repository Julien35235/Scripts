#!/bin/bash
lsb_release -a
sudo apt update && sudo apt full-upgrade -y
sudo apt install ufw nala htop ubuntu-release-upgrader-core -y
sudo ufw allow 1022/tcp
sudo ufw reload
sudo do-release-upgrade 
sudo do-release-upgrade -d
sudo reboot
