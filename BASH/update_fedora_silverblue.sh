#!/bin/bash
#Mise à jour du système 
sudo rpm-ostree update 
sudo rpm-ostree upgrade -y
#Redemarrage du système
sudo reboot
