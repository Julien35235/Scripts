#!/bin/bash

# ==============================================================================
# CONFIGURATION DES LOGS & RÉPERTOIRES
# ==============================================================================
TARGET_DIR="/opt/iventoy/iso"
LOG_FILE="/var/log/download_iso.log" # Modifie ce chemin si tu n'as pas les droits root

# Fonction pour formater les messages avec la date et l'heure
log_message() {
    local type="$1"
    local message="$2"
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$type] $message" | tee -a "$LOG_FILE"
}

# ==============================================================================
# 1. INITIALISATION ET VÉRIFICATIONS
# ==============================================================================
echo "==================================================" | tee -a "$LOG_FILE"
log_message "INFO" "Démarrage du script de téléchargement ISO."
echo "==================================================" | tee -a "$LOG_FILE"

# Vérification et sécurisation du dossier cible
if [ ! -d "$TARGET_DIR" ]; then
    log_message "ATTENTION" "Le répertoire $TARGET_DIR n'existe pas. Création en cours..."
    mkdir -p "$TARGET_DIR" || { log_message "ERREUR" "Impossible de créer le dossier. Fin du script."; exit 1; }
fi

cd "$TARGET_DIR" || { log_message "ERREUR" "Impossible d'accéder à $TARGET_DIR. Fin du script."; exit 1; }

# ==============================================================================
# 2. LISTE DES URL DES ISO
# ==============================================================================
URLS=(
    "https://releases.ubuntu.com/resolute/ubuntu-26.04-desktop-amd64.iso"
    "https://releases.ubuntu.com/noble/ubuntu-24.04.4-desktop-amd64.iso"
    "https://releases.ubuntu.com/resolute/ubuntu-26.04-live-server-amd64.iso"
    "https://releases.ubuntu.com/noble/ubuntu-24.04.4-live-server-amd64.iso"
    "https://cdimages.ubuntu.com/edubuntu/releases/26.04/release/edubuntu-26.04-desktop-amd64.iso"
    "https://cdimage.ubuntu.com/edubuntu/releases/noble/release/edubuntu-24.04.4-desktop-amd64.iso"
    "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-13.5.0-amd64-netinst.iso"
    "https://dietpi.com/downloads/images/DietPi_VM-x86_64-Trixie_Installer.iso"
    "https://download.fedoraproject.org/pub/fedora/linux/releases/44/Workstation/x86_64/iso/Fedora-Workstation-Live-44-1.7.x86_64.iso"
    "https://download.fedoraproject.org/pub/fedora/linux/releases/44/Server/x86_64/iso/Fedora-Server-dvd-x86_64-44-1.7.iso"
    "https://repo.almalinux.org/almalinux/10/live/x86_64/AlmaLinux-10.2-x86_64-Live-GNOME.iso"
    "https://repo.almalinux.org/almalinux/10/live/x86_64/AlmaLinux-10.2-x86_64-Live-KDE.iso"
    "https://repo.almalinux.org/almalinux/10/isos/x86_64/AlmaLinux-10.2-x86_64-dvd.iso"
    "https://repo.almalinux.org/almalinux/10/isos/x86_64/AlmaLinux-10.2-x86_64-boot.iso"
    "https://mirrors.univ-reims.fr/IMAGES/zorinos/18/Zorin-OS-18.1-Core-64-bit.iso"
    "https://mirrors.univ-reims.fr/IMAGES/zorinos/18/Zorin-OS-18.1-Education-64-bit.iso"
    "https://download.rockylinux.org/pub/rocky/10/isos/x86_64/Rocky-10.2-x86_64-dvd1.iso"
    "https://download.rockylinux.org/pub/rocky/10/isos/x86_64/Rocky-10.2-x86_64-minimal.iso"
    "https://iso.pop-os.org/24.04/amd64/generic/25/pop-os_24.04_amd64_generic_25.iso"
    "https://kali.download/base-images/kali-2026.2/kali-linux-2026.2-installer-netinst-amd64.iso"
    "https://deb.parrot.sh/parrot/iso/7.3/Parrot-security-7.3_amd64.iso"
    "https://pub.linuxmint.io/stable/22.3/linuxmint-22.3-cinnamon-64bit.iso"
    "https://pub.linuxmint.io/stable/22.3/linuxmint-22.3-xfce-64bit.iso"
    "https://pub.linuxmint.io/stable/22.3/linuxmint-22.3-mate-64bit.iso"
    "https://mirror.stream.centos.org/10-stream/BaseOS/x86_64/iso/CentOS-Stream-10-20260707.1-x86_64-dvd1.iso"
    "https://cdimage.ubuntu.com/ubuntucinnamon/releases/resolute/release/ubuntucinnamon-26.04-desktop-amd64.iso"
    "https://cdimage.ubuntu.com/ubuntucinnamon/releases/24.04.4/release/ubuntucinnamon-24.04.3-desktop-amd64.iso"
    "https://cdimage.ubuntu.com/kubuntu/releases/26.04/release/kubuntu-26.04-desktop-amd64.iso"
    "https://download.fedoraproject.org/pub/fedora/linux/releases/44/KDE/x86_64/iso/Fedora-KDE-Desktop-Live-44-1.7.x86_64.iso"
    "https://fastly.mirror.pkgbuild.com/iso/2026.07.01/archlinux-x86_64.iso"
    "https://enterprise.proxmox.com/iso/proxmox-ve_9.2-1.iso"
    "https://enterprise.proxmox.com/iso/proxmox-backup-server_4.2-1.iso"
    "https://enterprise.proxmox.com/iso/proxmox-mail-gateway_9.1-1.iso"
    "https://enterprise.proxmox.com/iso/proxmox-datacenter-manager_1.1-1.iso"
    "https://archive.org/download/endless-os-3x-64bit-pc/eos-eos3.9-amd64-amd64.210706-203204.base.iso"
    "https://cdn77.cachyos.org/ISO/desktop/260628/cachyos-desktop-linux-260628.iso"
    "https://nobara-images.nobaraproject.org/Nobara-43-Official-NV-2026-04-24.iso"
    "https://nobara-images.nobaraproject.org/Nobara-43-GNOME-NV-2026-04-25.iso"
    "https://nobara-images.nobaraproject.org/Nobara-43-KDE-NV-2026-04-25.iso"
    "https://nobara-images.nobaraproject.org/Nobara-43-Steam-HTPC-NV-2026-04-25.iso"
)

# ==============================================================================
# 3. BOUCLE DE TÉLÉCHARGEMENT
# ==============================================================================
log_message "INFO" "Début du téléchargement des ISO dans $TARGET_DIR..."

for url in "${URLS[@]}"; do
    filename=$(basename "$url")
    echo "--------------------------------------------------" | tee -a "$LOG_FILE"
    log_message "INFO" "Vérification / Téléchargement de : $filename"
    
    # -c : Reprend le téléchargement si interrompu
    # --no-verbose : Évite de spammer, affiche l'essentiel
    # On redirige la sortie de wget (stderr) vers tee pour l'historiser dans le log
    wget -c --no-verbose "$url" 2>&1 | tee -a "$LOG_FILE"
    
    # Vérification du code de sortie de wget
    if [ ${PIPESTATUS[0]} -eq 0 ]; then
        log_message "SUCCÈS" "$filename traité avec succès."
    else
        log_message "ÉCHEC" "Erreur lors du téléchargement de $filename."
    fi
done

echo "--------------------------------------------------" | tee -a "$LOG_FILE"
log_message "INFO" "Tous les téléchargements sont terminés !"
echo "==================================================" | tee -a "$LOG_FILE"