#!/bin/bash
#Mise à jour du système
sudo apt update && sudo apt full-upgrade -y
#Installation des packets pour mon enviromment de bureau et de la prise en main à distance avec xrdp
sudo apt install tasksel xrdp -y
sudo systemctl enable xrdp
sudo systemctl start xrdp

