#!/bin/bash
sudo apt update && sudo apt full-upgrade -y
sudo apt installl htop nala wget -y
cd /opt
wget https://github.com/IsmaelMartinez/teams-for-linux/releases/download/v2.7.12/teams-for-linux_2.7.12_amd64.deb
sudo apt install ./teams-for-linux_2.7.12_amd64.deb
