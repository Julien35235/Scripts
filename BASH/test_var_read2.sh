#!/usr/bin/env bash

# Récupération du nom depuis le premier argument
nom="$1"

# Si aucun argument n'est fourni, demander à l'utilisateur
if [[ -z "$nom" ]]; then
    read -p "Veuillez saisir votre nom : " nom
fi

# Si rien n'est saisi, utiliser "invité"
if [[ -z "$nom" ]]; then
    nom="invité"
fi

# Refuser les noms Administrateur / Administrator
if [[ "$nom" == "Administrateur" || "$nom" == "Administrator" ]]; then
    echo -e "\e[31mErreur : le nom '$nom' n'est pas autorisé.\e[0m"
    exit 4
fi

# Afficher le message de bienvenue avec le nom de la machine
echo "Bienvenue $nom sur la machine $(hostname)"

# Fin du script
echo "fin du script"
``
