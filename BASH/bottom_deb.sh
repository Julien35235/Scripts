#!/bin/bash
#Mise à jour du système 
sudo apt update && sudo apt full-upgrade -y
#Installation des packets 
sudo apt install wget nala curl htop -y
cd /opt
#Recuperation de Bottom avec wget 
wget https://github.com/ClementTsang/bottom/releases/download/0.12.3/bottom_0.12.3-1_amd64.deb
#Installation du packet 
sudo apt install ./bottom_0.12.3-1_amd64.deb -y

