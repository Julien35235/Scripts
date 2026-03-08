#!/bin/bash
# Installation des depances
sudo apt install software-properties-common screen wget apt-transport-https gnupg nala htop -y
cd /tmp
wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.deb
sudo apt install ./jdk-21_linux-x64_bin.deb -y
# Creation du dossier minecraft
sudo mkdir /opt/minecraft
# Rendre dans le repository de minecraft
sudo cd /opt/minecraft
#Téléchargement du serveur 
sudo wget https://piston-data.mojang.com/v1/objects/4707d00eb834b446575d89a61a11b5d548d8c001/server.jar
sudo java -Xms1024M -Xmx1024M -jar minecraft_server_1.15.2.jar nogui
sudo sed -i 's/eula=false/eula=true/' /opt/minecraft/eula.txt
sudo sed -e '1i java -Xmx4G -Xms4G -jar server.jar nogui' /dev/null > /opt/minecraft/start_minecraft.sh
sudo ./start_minecraft.sh