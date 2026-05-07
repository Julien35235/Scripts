#!/bin/bash

# Répertoire à sauvegarder (tous les homes)
SOURCE="/home"

# Répertoire où stocker les sauvegardes
DEST="/var/backups"

# Date du jour
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

# Nom de l’archive
ARCHIVE="backup_home_$DATE.tar.gz"

# Création du dossier de sauvegarde si nécessaire
mkdir -p "$DEST"

# Création de la sauvegarde
tar -czf "$DEST/$ARCHIVE" "$SOURCE"

echo "Sauvegarde terminée : $DEST/$ARCHIVE"
