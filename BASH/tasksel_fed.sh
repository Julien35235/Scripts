#!/bin/bash
#Mise à jour du système
sudo dnf update && sudo dnf full-upgrade -y
#Installation des packets pour mon enviromment de bureau et de la prise en main à distance avec xrdp
sudo dnf install tasksel xrdp -y
sudo systemctl enable xrdp
sudo systemctl start xrdp

