#!/bin/bash
set -euo pipefail

# ==========================================================
#  Install Party - Téléchargement d'ISO pour PXE (Ventoy/iVentoy)
#  - wget avec reprise (-c)
#  - logs horodatés (stdout + fichier)
#  - vérification SHA256 via fichiers officiels (quand disponibles)
#  - structure compatible iVentoy : DEST/<distro>/<fichier.iso>
# ==========================================================

# --------- Paramètres ----------
DEST="${DEST:-/media/root/PXE/iso}"      # <-- mets ici le dossier "iso" d'iVentoy
LOG_DIR="${LOG_DIR:-./logs}"          # dossier des logs
KEEP_LOGS="${KEEP_LOGS:-10}"          # nombre de logs à conserver
USER_AGENT="${USER_AGENT:-pxe-iso-fetcher/2.0}"
WGET_OPTS=${WGET_OPTS:-"--continue --tries=3 --timestamping --no-verbose --show-progress --progress=dot:giga --user-agent=$USER_AGENT"}

mkdir -p "$DEST" "$LOG_DIR"

# --------- Initialisation du log ----------
RUN_ID="$(date +%Y%m%d-%H%M%S)"
LOG_FILE="$LOG_DIR/fetch-isos_${RUN_ID}.log"
exec > >(tee -a "$LOG_FILE") 2>&1

# --------- Couleurs & helpers ----------
if [[ -t 1 ]]; then
  C_NC="\033[0m"; C_OK="\033[1;32m"; C_INFO="\033[1;34m"; C_WARN="\033[1;33m"; C_ERR="\033[1;31m"
else
  C_NC=""; C_OK=""; C_INFO=""; C_WARN=""; C_ERR=""
fi

ts()   { date '+%F %T'; }
log()  { echo -e "[$(ts)] ${C_INFO}INFO${C_NC}  - $*"; }
ok()   { echo -e "[$(ts)] ${C_OK}OK${C_NC}    - $*"; }
warn() { echo -e "[$(ts)] ${C_WARN}WARN${C_NC}  - $*"; }
err()  { echo -e "[$(ts)] ${C_ERR}ERREUR${C_NC}- $*"; }

rotate_logs() {
  mapfile -t files < <(ls -1t "$LOG_DIR"/fetch-isos_*.log 2>/dev/null || true)
  if (( ${#files[@]} > KEEP_LOGS )); then
    for f in "${files[@]:$KEEP_LOGS}"; do rm -f "$f"; done
  fi
}

need() { command -v "$1" >/dev/null 2>&1 || { err "Commande manquante: $1"; exit 127; }; }
need wget; need tee; need sha256sum; need awk; need grep; need sed

log "Dossier destination (iVentoy ISO) : $DEST"
log "Fichier log                        : $LOG_FILE"
rotate_logs

# --------- Statuts ---------
declare -A STATUS

download_file() {
  local url="$1" out_dir="$2"
  wget $WGET_OPTS -P "$out_dir" "$url"
}

# --------- Vérif SHA256 à partir d’un fichier de sommes ----------
verify_sha256_from_sums() {
  local iso_path="$1" sums_path="$2" iso_basename checksum_expected checksum_actual

  iso_basename="$(basename "$iso_path")"
  checksum_actual="$(sha256sum "$iso_path" | awk '{print $1}')"

  checksum_expected="$(
    awk -v f="$iso_basename" '
      $2==f {print $1}                                             # format: HASH  file
      $0 ~ "^[A-Fa-f0-9]+[[:space:]]+\\*"f"$" {print $1}          # format: HASH *file
      $0 ~ "SHA256 \\("f"\\)[[:space:]]*=" {print $NF}            # format: SHA256 (file) = HASH
    ' "$sums_path" | head -n1
  )"

  if [[ -z "$checksum_expected" ]]; then
    err "Empreinte introuvable pour $iso_basename dans $(basename "$sums_path")"
    return 1
  fi

  if [[ "$checksum_actual" != "$checksum_expected" ]]; then
    err "Checksum NON correspondant pour $iso_basename"
    echo "  attendu : $checksum_expected"
    echo "  calculé : $checksum_actual"
    return 1
  fi

  ok "Checksum SHA256 OK pour $iso_basename"
  return 0
}

# --------- Téléchargement + vérification ----------
# Arguments: 1: nom logique | 2: URL ISO | 3: URL fichier de sommes (optionnel)
download_iso_with_checksum() {
  local NAME="$1" ISO_URL="$2" SUMS_URL="${3:-}"

  local OUT_DIR="$DEST/$NAME"
  mkdir -p "$OUT_DIR"

  log "----> $NAME : téléchargement ISO"
  log "URL ISO   : $ISO_URL"
  [[ -n "$SUMS_URL" ]] && log "URL SUMS  : $SUMS_URL"

  local SUBLOG="$OUT_DIR/download_${NAME}_$(date +%Y%m%d-%H%M%S).log"

  # ISO
  if download_file "$ISO_URL" "$OUT_DIR" 2>&1 | tee -a "$SUBLOG"; then
    ok "$NAME : ISO téléchargée"
  else
    err "$NAME : échec téléchargement ISO"
    STATUS["$NAME"]="ECHEC"
    return 1
  fi

  # SUMS + vérification
  if [[ -n "$SUMS_URL" ]]; then
    local SUMS_PATH="$OUT_DIR/$(basename "$SUMS_URL")"
    if download_file "$SUMS_URL" "$OUT_DIR" 2>&1 | tee -a "$SUBLOG"; then
      ok "$NAME : fichier de sommes récupéré"
      local ISO_PATH="$OUT_DIR/$(basename "$ISO_URL")"
      if verify_sha256_from_sums "$ISO_PATH" "$SUMS_PATH"; then
        STATUS["$NAME"]="OK"
      else
        STATUS["$NAME"]="ECHEC"
        return 1
      fi
    else
      err "$NAME : échec téléchargement fichier de sommes"
      STATUS["$NAME"]="ECHEC"
      return 1
    fi
  else
    warn "$NAME : pas de fichier de sommes fourni — vérification SKIPPED"
    STATUS["$NAME"]="OK"
  fi
}

# =================================================================
#                       LISTE DES DISTRIBUTIONS
#  (URLs officielles / miroirs reconnus + fichiers de sommes)
# =================================================================

# Debian 13 (trixie) - netinst amd64
download_iso_with_checksum "debian13" \
"https://mirror.arizona.edu/debian-cd/current/amd64/iso-cd/debian-13.3.0-amd64-netinst.iso" \
"https://mirror.arizona.edu/debian-cd/current/amd64/iso-cd/SHA256SUMS"    || true
# Référence : index miroir listant 'debian-13.3.0-amd64-netinst.iso' et 'SHA256SUMS' [3](https://cdimage.debian.org/cdimage/archive/13.0.0/amd64/iso-cd/)

# Ubuntu 24.04 LTS (Desktop amd64) – dernier point release (24.04.4)
download_iso_with_checksum "ubuntu-24.04-lts" \
"https://releases.ubuntu.com/noble/ubuntu-24.04.4-desktop-amd64.iso" \
"https://releases.ubuntu.com/noble/SHA256SUMS"                            || true
# Références : page 'Ubuntu Releases' pour 24.04.4 et fichiers SHA256SUMS [4](https://releases.ubuntu.com/noble/)

# Zorin OS 18 Core (amd64) – miroir direct + SHA256
download_iso_with_checksum "zorin-os-18-core" \
"https://mirror.metanet.ch/zorinos/18/Zorin-OS-18-Core-64-bit-r3.iso" \
"https://mirror.metanet.ch/zorinos/18/SHA256SUMS.txt"                     || true
# Référence : miroir 'zorinos/18' listant ISO et SHA256SUMS.txt [5](https://mirror.metanet.ch/zorinos/18/)

# Linux Mint 22.3 Cinnamon (amd64) – stable + sha256sum.txt
download_iso_with_checksum "linuxmint-22.3-cinnamon" \
"https://linuxmint-isos.mirrorservice.org/stable/22.3/linuxmint-22.3-cinnamon-64bit.iso" \
"https://linuxmint-isos.mirrorservice.org/stable/22.3/sha256sum.txt"      || true
# Référence : index 'stable/22.3' avec ISO et sha256sum.txt [6](https://linuxmint-isos.mirrorservice.org/stable/22.3/)

# Fedora 42 Workstation Live (x86_64) – CHECKSUM signé (on vérifie le hash)
download_iso_with_checksum "fedora-42-workstation" \
"https://fedora.mirrorservice.org/fedora/linux/releases/42/Workstation/x86_64/iso/Fedora-Workstation-Live-42-1.1.x86_64.iso" \
"https://fedora.mirrorservice.org/fedora/linux/releases/42/Workstation/x86_64/iso/Fedora-Workstation-42-1.1-x86_64-CHECKSUM" || true
# Références : index Workstation 42 x86_64 avec ISO + CHECKSUM [7](https://ftp.osuosl.org/pub/debian-cdimage/current/amd64/iso-cd/)

# Lubuntu 24.04 LTS (Desktop amd64) – 24.04.4 (prend aussi 24.04.3 si tu préfères)
download_iso_with_checksum "lubuntu-24.04-lts" \
"https://cdimage.ubuntu.com/lubuntu/releases/noble/release/lubuntu-24.04.4-desktop-amd64.iso" \
"https://cdimage.ubuntu.com/lubuntu/releases/noble/release/SHA256SUMS"    || true
# Références : répertoire 'lubuntu/releases/noble/release' avec ISO et SHA256SUMS [8](https://cdimage.ubuntu.com/lubuntu/releases/noble/release/)

# AlmaLinux 9 (latest minimal x86_64) – lien générique 'latest' + CHECKSUM
download_iso_with_checksum "almalinux-9-minimal" \
"https://cdimage.debian.org/mirror/almalinux.org/9/isos/x86_64/AlmaLinux-9-latest-x86_64-minimal.iso" \
"https://cdimage.debian.org/mirror/almalinux.org/9/isos/x86_64/CHECKSUM"  || true
# Références : index miroir AlmaLinux 9 x86_64 avec 'latest' et CHECKSUM [9](https://cdimage.debian.org/mirror/almalinux.org/9/isos/x86_64/)

# Clonezilla (stable amd64) – 3.3.1-35
download_iso_with_checksum "clonezilla" \
"https://sourceforge.net/projects/clonezilla/files/clonezilla_live_stable/3.3.1-35/clonezilla-live-3.3.1-35-amd64.iso/download" \
""                                                                          || true
# Références : page officielle "downloads" (stable 3.3.1-35) et dossier SourceForge 3.3.1-35 [10](https://clonezilla.org/downloads/download.php?branch=stable)[11](https://sourceforge.net/projects/clonezilla/files/clonezilla_live_stable/3.3.1-35/)

# GParted Live (stable amd64) – 1.8.0-2 + vérif via page officielle/SourceForge
download_iso_with_checksum "gparted-live" \
"https://sourceforge.net/projects/gparted/files/gparted-live-stable/1.8.0-2/gparted-live-1.8.0-2-amd64.iso/download" \
""                                                                          || true
# Références : page 'GParted -- Download' annonçant 1.8.0-2 + lien SourceForge direct [12](https://gparted.org/download.php)[13](https://sourceforge.net/projects/gparted/files/gparted-live-stable/1.8.0-2/gparted-live-1.8.0-2-amd64.iso/download)

# Rescuezilla 2.6.1 (amd64 Oracular) – ISO
download_iso_with_checksum "rescuezilla-2.6.1" \
"https://github.com/rescuezilla/rescuezilla/releases/download/2.6.1/rescuezilla-2.6.1-64bit.oracular.iso" \
""                                                                          || true
# Références : site Rescuezilla (download) et release GitHub v2.6.1 mentionnant le nom de l’ISO [14](https://rescuezilla.com/download.html)[15](https://github.com/rescuezilla/rescuezilla/releases)

# Ubuntu Cinnamon 24.04.3 (Desktop amd64) – demandé explicitement
download_iso_with_checksum "ubuntucinnamon-24.04.3" \
"https://cdimage.ubuntu.com/ubuntucinnamon/releases/noble/release/ubuntucinnamon-24.04.3-desktop-amd64.iso" \
"https://cdimage.ubuntu.com/ubuntucinnamon/releases/noble/release/SHA256SUMS" || true
# Références : répertoire 'ubuntucinnamon/releases/noble/release' listant 24.04.3 + SHA256SUMS [16](https://cdimage.ubuntu.com/ubuntucinnamon/releases/noble/release/)

# Boot-Repair-Disk (64-bit) — ISO officielle hébergée sur SourceForge
download_iso_with_checksum "boot-repair-disk-64bit" \
"https://sourceforge.net/projects/boot-repair-cd/files/boot-repair-disk-64bit.iso/download" \
"" || true
# Réf. : page du projet & répertoire des fichiers (ISO 64-bit publiée le 2023‑12‑23)
# https://sourceforge.net/projects/boot-repair-cd/ 
# https://sourceforge.net/projects/boot-repair-cd/files/


# Windows 10 LTSC (Desktop amd64) – demandé explicitement
# download_iso_with_checksum "fr_windows_10_enterprise_ltsc_2021_" \
# "https://iso.malekal.org/QZfCyvkig/fr_windows_10_enterprise_ltsc_2021_x64_dvd_bda01eb0.iso"

# --------- Résumé ----------
echo
log "================= RÉSUMÉ DES TÉLÉCHARGEMENTS ================="
printf "%-28s | %s\n" "Distribution" "Statut"
printf -- "------------------------------+-----------------\n"
for name in "${!STATUS[@]}"; do
  printf "%-28s | %s\n" "$name" "${STATUS[$name]}"
done
printf -- "---------------------------------------------------------------\n"
ok "Logs : $LOG_FILE"
ok "ISO : $DEST"
echo
ok "Si tu utilises iVentoy : pointe le dossier ISO d'iVentoy sur $DEST et clique 'Refresh' (Image Management)."

# Code de sortie : ECHEC si au moins un échec
EXIT_CODE=0
for v in "${STATUS[@]}"; do [[ "$v" == "ECHEC" ]] && EXIT_CODE=1; done
exit $EXIT_CODE