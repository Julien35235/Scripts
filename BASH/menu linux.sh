#!/bin/bash

# Définir les couleurs avec des variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # Aucune couleur

while true; do
    echo -e "${YELLOW}Menu :"
    echo -e "${GREEN}1) Actualisation des packets des mise à jour"
    echo -e "${GREEN}2) Mise à jour du systeme"
    echo -e "${GREEN}3) version du noyau du système"
    echo -e "${GREEN}4) version du système"
    echo -e "5) espace disque"
    echo -e "6) configuration IP"
    echo -e "7) la date du dernier redémarrage"
    echo -e "8) le gestionnaire des taches"
    echo -e "9) ping internet"
    echo -e "10) Affiche moi le chemin de votre répertoire"
    echo -e "11) Quitter"
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
            echo -e "${GREEN} Voir la version du noyau du système:${NC}"
             uname -r
            ;;

        4)
          echo -e "${GREEN} Voir la version du système:${NC}"
          lsb_release -a

            echo -e "${GREEN}Voir la version du noyau du système:${NC}"
               uname -a
            ;;
        5)
            echo -e "${GREEN}Voir espace disque:${NC}"
            lsblk
            ;;

            6)
            echo -e "${GREEN}Voir configuration IP:${NC}"
            ip a
            ;;

        7)
            echo -e "${GREEN}Date du dernier redémarrage :${NC}"
            who -b
            ;;
        8)
         echo -e "${GREEN}Voir le gestionnaire des taches:${NC}"
        htop
        ;;
        9)
         echo -e "${GREEN}ping internet:${NC}"
         ping google.fr           
            ;;
       10)
        echo -e "${GREEN}Affiche moi le chemin de votre répertoire:${NC}"
        pwd
       ;;
       11) 
        echo -e "${YELLOW}Exit${NC}"
        break

            echo -e "${RED}Option invalide, veuillez réessayer !${NC}"
            ;;
    esac
done