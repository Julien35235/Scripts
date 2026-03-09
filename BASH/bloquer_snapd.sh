#!/usr/bin/env bash
# Purpose: Supprimer Snap, le bloquer via APT, et installer les paquets complémentaires
# Logging: stdout + stderr dans /var/log/remove-snaps.log et sur la console
# Tested on: Ubuntu 22.04/24.04 (GNOME)

set -euo pipefail

### --- Paramètres ---
LOG_FILE="/var/log/remove-snaps.log"
PREF_FILE="/etc/apt/preferences.d/nosnap"
# Ajoute ici d'autres paquets à installer si besoin (séparés par des espaces)
EXTRA_PACKAGES=("gnome-software-plugin-apt")

### --- Fonctions utilitaires ---
timestamp() { date "+%Y-%m-%d %H:%M:%S"; }

log_header() {
  echo "============================================================"
  echo "[$(timestamp)] $1"
  echo "============================================================"
}

require_root() {
  if [[ $EUID -ne 0 ]]; then
    echo "Ce script doit être lancé en root (sudo)." >&2
    exit 1
  fi
}

ensure_logfile() {
  # Crée le fichier de log et ajuste les droits
  touch "$LOG_FILE"
  chmod 640 "$LOG_FILE"
}

begin_logging() {
  # Redirige stdout/stderr vers tee pour log + console
  exec > >(tee -a "$LOG_FILE") 2>&1
  log_header "DÉBUT DU SCRIPT — $(basename "$0")"
}

finish_logging() {
  local code=$?
  if [[ $code -eq 0 ]]; then
    log_header "FIN DU SCRIPT — Statut: SUCCÈS"
  else
    log_header "FIN DU SCRIPT — Statut: ÉCHEC (code $code)"
  fi
  exit $code
}

trap finish_logging EXIT

run_or_warn() {
  # Exécute une commande ; si elle échoue, log un avertissement et continue
  # Usage: run_or_warn "message si erreur" cmd arg1 arg2 ...
  local errmsg="$1"; shift
  if ! "$@"; then
    echo "[WARN] $errmsg — commande: $*"
    return 1
  fi
}

apt_update_safe() {
  DEBIAN_FRONTEND=noninteractive apt-get update -y
}

apt_install_safe() {
  # Usage: apt_install_safe pkg1 pkg2 ...
  DEBIAN_FRONTEND=noninteractive apt-get install -y "$@"
}

apt_autoremove_safe() {
  DEBIAN_FRONTEND=noninteractive apt-get autoremove -y "$@"
}

### --- Début du script ---
require_root
ensure_logfile
begin_logging

echo "[INFO] Log file: $LOG_FILE"
echo "[INFO] Préférences APT (no snap): $PREF_FILE"

# 1) Mise à jour des dépôts
log_header "Mise à jour des dépôts APT"
apt_update_safe

# 2) Lister les snaps installés
log_header "Snaps installés (avant suppression)"
run_or_warn "Échec de la commande 'snap list' (snapd peut déjà être absent)" snap list

# 3) Suppression des snaps (dans un ordre prudent)
# On tente d'abord de retirer les snaps applicatifs, puis les bases, puis snapd
log_header "Suppression des snaps applicatifs"
# Regroupe par familles pour éviter les erreurs de dépendances
run_or_warn "Impossible de supprimer certains snaps (firefox, firmware-updater, snap-store)" \
  snap remove --purge firefox firmware-updater snap-store

run_or_warn "Impossible de supprimer certains snaps (gtk-common-themes, gnome-42-2204, snapd-desktop-integration)" \
  snap remove --purge gtk-common-themes gnome-42-2204 snapd-desktop-integration

log_header "Suppression des snaps de base (core/bare)"
run_or_warn "Impossible de supprimer core22 ou bare" \
  snap remove --purge core22 bare

log_header "Arrêt du service snapd (si présent)"
run_or_warn "Impossible d'arrêter snapd" systemctl stop snapd.socket snapd.service

log_header "Désinstallation du paquet snapd (APT)"
# On supprime d’abord le paquet, puis on lance autoremove
run_or_warn "Impossible de supprimer le paquet snapd via APT" apt-get remove -y snapd
apt_autoremove_safe

# 4) Blocage du paquet snapd via APT pinning
log_header "Blocage de snapd via APT (Pin-Priority -1)"
# On crée proprement le fichier de préférences
# NB: sed -i sur un fichier possiblement vide peut être fragile ; on l'écrit fraîchement.
cat > "$PREF_FILE" <<'EOF'
Package: snapd
Pin: release *
Pin-Priority: -1
EOF

chmod 644 "$PREF_FILE"
echo "[INFO] Fichier de préférences écrit :"
cat "$PREF_FILE"

# 5) Installation des logiciels complémentaires
log_header "Installation des paquets complémentaires"
# Filtrer les entrées vides au cas où
PKGS=()
for p in "${EXTRA_PACKAGES[@]}"; do
  [[ -n "$p" ]] && PKGS+=("$p")
done
if [[ ${#PKGS[@]} -gt 0 ]]; then
  apt_update_safe
  apt_install_safe "${PKGS[@]}"
else
  echo "[INFO] Aucun paquet complémentaire défini."
fi

# 6) Vérifications post‑opération
log_header "Vérifications post‑opération"
if command -v snap >/dev/null 2>&1; then
  echo "[WARN] La commande 'snap' est encore présente."
else
  echo "[OK] 'snap' n'est plus disponible sur le système."
fi

if apt-cache policy snapd | grep -q "Pin-Priority: -1"; then
  echo "[OK] Le pinning APT pour 'snapd' est correctement configuré."
else
  echo "[WARN] Le pinning APT pour 'snapd' ne semble pas actif."
fi

echo "[INFO] Paquets installés : ${PKGS[*]:-(aucun)}"
``
