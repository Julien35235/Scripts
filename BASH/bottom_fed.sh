#!/bin/bash
#Mise à jour du système 
sudo dnf update && sudo dnf update -y
#Installation des packets 
sudo dnf install wget nala curl htop -y
cd /opt
#Recuperation de Bottom avec wget 
wget https://github.com/ClementTsang/bottom/releases/download/0.12.3/bottom_0.12.3-1_amd64.deb
#Installation du packet 
sudo dnf install ./bottom_0.12.3-1_amd64.deb -y

