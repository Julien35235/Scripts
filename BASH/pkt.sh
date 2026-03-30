#!/bin/bash
# Mise à jour du système  
sudo apt update && sudo apt full-upgrade -y
# Installation des packets pour pkt
apt install -y libglib2.0-0 libgl1-mesa-glx libxcb-xinerama0 htop nala -y
cd /opt
#Télechargements du software de PKT.
#wget https://prod-tf-ui.s3.amazonaws.com/s/ff9e491c-49be-4734-803e-a79e6e83dab1/resources/9accb7fd-7560-45c6-b6de-9ab7e9cf07b8/v1/en-US/CiscoPacketTracer_900_Ubuntu_64bit.deb
wget https://archive.org/download/packettracer900/CiscoPacketTracer_900_Ubuntu_64bit.deb
#Installation du software PKT
apt install ./CiscoPacketTracer_900_Ubuntu_64bit.deb -y

