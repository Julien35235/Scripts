#Mise à jour du système 
sudo apt update && sudo apt full-upgrade -y
#Installations des dépendances 
sudo apt installgit nala ssh wget curl gettext man-db procps psmisc nano tree ncal x11-apps -y
#Creation du répertoire de gameshell
mkdir gameshell
cd gameshell
#Recuperation du jeu de GamesShell 
wget https://github.com/phyver/GameShell/releases/download/v0.6.0/gameshell.sh
#Rendre exécutables 
sudo chmod +x gameshell.sh
#Lancement du jeu 
./gameshell.sh
