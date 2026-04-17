#!/bin/bash

# Récupération de l'argument
nom="$1"

# Si aucun argument fourni
if [ -z "$nom" ]; then
    read -p "Entrez votre nom : " nom
fi

# Si toujours vide → valeur par défaut
if [ -z "$nom" ]; then
    nom="invité"
fi

# Vérification des noms interdits
if [ "$nom" = "Administrateur" ] || [ "$nom" = "Administrator" ]; then
    echo -e "\e[31mErreur : nom interdit\e[0m"
    exit 4
fi

# Nom de la machine
machine=$(hostname)

# Message de bienvenue
echo "Bienvenue $nom sur la machine $machine"

# Fin du script
echo "fin du script"