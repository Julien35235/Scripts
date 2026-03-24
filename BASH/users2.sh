#!/bin/bash

# 1. Création des groupes
sudo groupadd direction
sudo groupadd developpement
sudo groupadd marketing
sudo groupadd stagiaire

# 2. Création des utilisateurs simples
sudo adduser luc.durand --force-bad-name
sudo adduser lea.rousseau --force-bad-name
sudo adduser paul.dubois --force-bad-name
sudo adduser julie.moreau --force-bad-name
sudo adduser alex.petit --force-bad-name
sudo adduser zoe.lambert --force-bad-name

# 3. Création des utilisateurs avec groupe principal
sudo useradd -m -g direction -s /bin/bash pierre.dupont
sudo useradd -m -g direction -s /bin/bash marie.lefebvre
sudo useradd -m -g developpement -s /bin/bash sophie.martin
sudo useradd -m -g developpement -s /bin/bash luc.durand
sudo useradd -m -g developpement -s /bin/bash lea.rousseau
sudo useradd -m -g marketing -s /bin/bash paul.dubois
sudo useradd -m -g marketing -s /bin/bash julie.moreau
sudo useradd -m -g marketing -s /bin/bash alex.petit
sudo useradd -m -g stagiaire -s /bin/bash zoe.lambert

# 4. Ajout des droits sudo
sudo usermod -aG sudo pierre.dupont
sudo usermod -aG sudo marie.lefebvre

# 5. Verifications des groupes créer
grep -E "direction|developpement|marketing|stagiaire" /etc/group
