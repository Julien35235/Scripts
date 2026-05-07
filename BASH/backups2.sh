# Répertoire à sauvegarder (tous les homes)
SOURCE="/home"

# Répertoire où stocker les sauvegardes
DEST="/var/backups"

# Fichier de log
LOGFILE="/var/log/backup_home.log"

# Date du jour
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

# Nom de l’archive
ARCHIVE="backup_home_$DATE.tar.gz"

# Fonction pour écrire dans les logs + afficher à l'écran
log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" | tee -a "$LOGFILE"
}

# Début du script
log "Début de la sauvegarde du répertoire $SOURCE"

# Création du dossier de sauvegarde si nécessaire
mkdir -p "$DEST"
log "Dossier de destination vérifié : $DEST"

# Création de la sauvegarde
if tar -czf "$DEST/$ARCHIVE" "$SOURCE" 2>>"$LOGFILE"; then
    log "Sauvegarde réussie : $DEST/$ARCHIVE"
else
    log "ERREUR : La sauvegarde a échoué"
    exit 1
fi

log "Fin de la sauvegarde"
