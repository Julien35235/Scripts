#!/bin/bash
#Il faut tout d'abord installer le greffon de DNF et mettre à jour votre version de Fedora Linux actuelle. 
dnf install dnf-plugin-system-upgrade
dnf upgrade --refresh
dnf clean all
#Ensuite vous pouvez télécharger les paquets puis redémarrer la machine pour appliquer la mise à niveau s'il n'y a pas d'erreurs.
dnf system-upgrade download --releasever=44
dnf system-upgrade reboot
dnf system-upgrade download --releasever=44 --allowerasing