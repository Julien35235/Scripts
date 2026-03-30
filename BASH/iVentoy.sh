#!/bin/bash
sudo apt update && sudo apt full-upgrade -y
sudo apt install wget nala htop -y 
cd /opt
wget https://github.com/ventoy/PXE/releases/download/v1.0.21/iventoy-1.0.21-linux-free.tar.gz
tar xzvf iventoy-1.0.19-linux-free.tar.gz
rm iventoy-1.0.19-linux-free.tar.gz
mv iventoy-1.0.19 iventoy
cd iventoy
sudo bash iventoy.sh start

