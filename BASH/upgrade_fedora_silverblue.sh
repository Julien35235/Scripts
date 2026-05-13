#!/bin/bash
#Mise jour du système de la fedora 43 à la 44
ostree remote refs fedora
sudo ostree admin pin 0
sudo ostree admin pin --unpin 2
rpm-ostree rebase fedora:fedora/44/x86_64/silverblue
#Redemarrage du système
systemctl reboot