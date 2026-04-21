#!/bin/bash

# Fichier de log avec date
LOGFILE="$HOME/brew_update_$(date +%Y-%m-%d_%H-%M-%S).log"

# PATH pour cron (OBLIGATOIRE)
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

echo "===== Début de la mise à jour Homebrew : $(date) =====" | tee -a "$LOGFILE"

# Vérifier que brew est installé
if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew n'est pas installé." | tee -a "$LOGFILE"
    exit 1
fi

# Mise à jour des formules
echo ">>> brew update" | tee -a "$LOGFILE"
brew update 2>&1 | tee -a "$LOGFILE"

# Mise à jour des paquets installés
echo ">>> brew upgrade" | tee -a "$LOGFILE"
brew upgrade 2>&1 | tee -a "$LOGFILE"

# Nettoyage optionnel
echo ">>> brew cleanup" | tee -a "$LOGFILE"
brew cleanup 2>&1 | tee -a "$LOGFILE"

echo "===== Fin de la mise à jour : $(date) =====" | tee -a "$LOGFILE"

echo "Logs disponibles dans : $LOGFILE"