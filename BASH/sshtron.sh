#Mise à jour du système 
sudo apt update && sudo apt full-upgrade -y
#Installations des dépendances 
sudo apt install git go htop nala ssh -y
#Clonnage du projet
git clone https://github.com/zachlatta/sshtron.git
cd sshtron
#Générez une paire de clés RSA
ssh-keygen -t rsa -f id_rs
#Installez les dépendances et compilez le programme 
sudo go get && go build
#Lancement du jeu
./sshtron

