#!/bin/bash

# Définir les couleurs avec des variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # Aucune couleur

while true; do
    echo -e "${YELLOW}Menu:"
    echo -e "${GREEN}1) Actualisation des packets des mise à jour"
    echo -e "${GREEN}2) Mise à jour du systeme"
    echo -e "${GREEN}3) version du noyau du système"
    echo -e "${GREEN}4) version du système"
    echo -e "5) liste des disques dur"
    echo -e "6) espaces des disques dur"
    echo -e "7) configuration IP"
    echo -e "8) la date du dernier redémarrage"
    echo -e "9) le gestionnaire des taches"
    echo -e "10) Affiche moi le chemin de votre répertoire"
    echo -e "11) Status du service Apache2"
    echo -e "12) Redémarrage du service Apache"
    echo -e "13) status service MariaDB"
    echo -e "14) Redémarrage du service MariaDB"
    echo -e "15) Redémarrage du système"
    echo -e "16) Poweroff du système"
    echo -e "17) Quitter"
    echo -e "${YELLOW}Choisissez une option : ${NC}"
    read choix

    case $choix in
        1)
            echo -e "${GREEN}Actualisation des packets des mise à jour:${NC}"
            apt update
            ;;

        2)
            echo -e "${GREEN} Mise à jour du systeme:${NC}"
            nala upgrade
           ;;
         3)
            echo -e "${GREEN}version du noyau du système:${NC}"
             uname -r
            ;;

        4)
          echo -e "${GREEN}version du système:${NC}"
          lsb_release -a

            echo -e "${GREEN}Version du noyau du système:${NC}"
               uname -a
            ;;
        5)
            echo -e "${GREEN}liste des disques durs:${NC}"
            lsblk
            ;;
      6) 
         echo -e "${GREEN}espaces des disques durs:${NC}"
         df -h
         ;;
            7)
            echo -e "${GREEN}Voir configuration IP:${NC}"
            ip a
            ;;

        8)
            echo -e "${GREEN}Date du dernier redémarrage :${NC}"
            who -b
            ;;
        9)
         echo -e "${GREEN} gestionnaire des taches:${NC}"
        htop
        ;;
        10)
            echo -e "${GREEN}Affiche moi le chemin de votre répertoire:${NC}"
            pwd
            ;;
       11)
       echo -e "${GREEN} Status du service Apache2:${NC}"
       systemctl status apache2
       ;;
       12)
         echo -e "${GREEN} Redemarrage du service Apache2{NC}"
         systemctl restart apache2
        ;;
       13)
           echo -e "${GREEN} Status du service MariaDB:${NC}"
           systemctl status mariadb.service
            ;;
        14)

         echo -e "${GREEN} Redemarrage du service MariaDB{NC}"
         systemctl restart mariadb.service
         ;;

       15)
            echo -e "${GREEN} Redemarrage du système"
            sudo reboot
            ;;

     16)
         echo -e "${GREEN} Poweroff de la machine"
         sudo poweroff
        ;;
   17)
   echo -e "${YELLOW}Exit${NC}"
         break
        ;;
       *)
            echo -e "${RED}Option invalide, veuillez réessayer !${NC}"
            ;;
    esac
done