#!/bin/bash
#Mise à jour du système 
sudo dnf upgrade --refresh
#J'importe la clé GPG de Anydesk
sudo rpm --import https://keys.anydesk.com/repos/RPM-GPG-KEY
# Je rajoute le dépot de AnyDesk
sudo tee /etc/yum.repos.d/anydesk.repo <<EOF
[anydesk]
name=AnyDesk Fedora Linux
baseurl=http://rpm.anydesk.com/fedora/x86_64/
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://keys.anydesk.com/repos/RPM-GPG-KEY
EOF
#Installation d'Anydesk
sudo dnf install anydesk -y
