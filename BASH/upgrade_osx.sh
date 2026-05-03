#!/usr/bin/env bash
# install_macos_updates.sh
# Ce script installe automatiquement les mises‑à‑jour macOS
# Author : Julien Despagne
# Date   : 2026‑05‑03

# ----------------------------------
# 1.  Demande de privilèges
# ----------------------------------
# Si l'utilisateur n'est pas root, on lance sudo
if [[ $EUID -ne 0 ]]; then
    echo "Ce script doit être exécuté avec les droits d’administrateur."
    echo "On vous demande le mot de passe sudo…"
    sudo -v
    # On vérifie que sudo a bien fonctionné
    if [[ $? -ne 0 ]]; then
        echo "Échec de l'authentification sudo. Abandon."
        exit 1
    fi
fi

# ----------------------------------
# 2.  Pré‑lancement
# ----------------------------------
echo "=== Démarrage du processus d’installation des mises‑à‑jour macOS ==="
echo

# 2.1 Met à jour la liste des mises‑à‑jour disponibles
echo "Recherche des mises‑à‑jour…"
sudo softwareupdate -l | tee /tmp/softwareupdate_list.txt

# 2.2 Vérifie si des mises‑à‑jour sont disponibles
if grep -q "No new software available." /tmp/softwareupdate_list.txt; then
    echo "Aucune mise‑à‑jour disponible."
    exit 0
fi

# ----------------------------------
# 3.  Installation des mises‑à‑jour
# ----------------------------------
echo
echo "Installation de toutes les mises‑à‑jour disponibles…"
echo "-------------------------------------------"
sudo softwareupdate -i -a --verbose

# ----------------------------------
# 4.  Résumé
# ----------------------------------
echo
echo "=== Résumé de l’installation ==="
echo "Vous avez terminé. Si vous voyez des erreurs, elles seront affichées ci‑dessous."
echo "Il peut être nécessaire de redémarrer votre Mac pour appliquer certains changements."
echo

# Optionnel : on peut afficher les mises‑à‑jour installées
echo "Liste des mises‑à‑jour installées :"
sudo softwareupdate -l | grep -E "^\s*Downloaded\|^\s*Installed"

echo
echo "=== FIN ==="