#!/bin/bash

# 1. Définition du répertoire cible
TARGET_DIR="/opt/iventoy/iso"

# 2. Vérification et sécurisation du dossier
if [ ! -d "$TARGET_DIR" ]; then
    echo "[INFO] Le répertoire $TARGET_DIR n'existe pas. Création en cours..."
    mkdir -p "$TARGET_DIR" || { echo "[ERREUR] Impossible de créer le dossier. Fin du script."; exit 1; }
fi

cd "$TARGET_DIR" || { echo "[ERREUR] Impossible d'accéder à $TARGET_DIR. Fin du script."; exit 1; }

# 3. Déclaration des ISO classées par catégories (tableaux associatifs)
# Note : Nous utilisons des variables classiques indexées pour une meilleure compatibilité Bash.

# --- BUREAUTIQUE / USAGE GÉNÉRAL ---
ISO_BUREAUTIQUE=(
    "https://releases.ubuntu.com/resolute/ubuntu-26.04-desktop-amd64.iso"
    "https://releases.ubuntu.com/noble/ubuntu-24.04.4-desktop-amd64.iso"
    "https://cdimage.ubuntu.com/ubuntucinnamon/releases/resolute/release/ubuntucinnamon-26.04-desktop-amd64.iso"
    "https://cdimage.ubuntu.com/ubuntucinnamon/releases/24.04.4/release/ubuntucinnamon-24.04.3-desktop-amd64.iso"
    "https://cdimage.ubuntu.com/ubuntu-mate/releases/noble/release/ubuntu-mate-24.04.4-desktop-amd64.iso"
    "https://cdimage.ubuntu.com/kubuntu/releases/26.04/release/kubuntu-26.04-desktop-amd64.iso"
    "https://cdimages.ubuntu.com/lubuntu/releases/26.04/release/lubuntu-26.04-desktop-amd64.iso"
    "https://pub.linuxmint.io/stable/22.3/linuxmint-22.3-cinnamon-64bit.iso"
    "https://pub.linuxmint.io/stable/22.3/linuxmint-22.3-xfce-64bit.iso"
    "https://pub.linuxmint.io/stable/22.3/linuxmint-22.3-mate-64bit.iso"
    "https://muug.ca/mirror/linuxmint/iso/debian/lmde-7-cinnamon-64bit.iso"
    "https://download.fedoraproject.org/pub/fedora/linux/releases/44/Workstation/x86_64/iso/Fedora-Workstation-Live-44-1.7.x86_64.iso"
    "https://download.fedoraproject.org/pub/fedora/linux/releases/44/KDE/x86_64/iso/Fedora-KDE-Desktop-Live-44-1.7.x86_64.iso"
    "https://repo.almalinux.org/almalinux/10/live/x86_64/AlmaLinux-10.2-x86_64-Live-GNOME.iso"
    "https://repo.almalinux.org/almalinux/10/live/x86_64/AlmaLinux-10.2-x86_64-Live-KDE.iso"
    "https://mirrors.univ-reims.fr/IMAGES/zorinos/18/Zorin-OS-18.1-Core-64-bit.iso"
    "https://iso.pop-os.org/24.04/amd64/generic/25/pop-os_24.04_amd64_generic_25.iso"
    "https://opensuse.mirror.garr.it/mirrors/opensuse/tumbleweed/iso/openSUSE-Tumbleweed-DVD-x86_64-Snapshot20260714-Media.iso"
    "https://download.manjaro.org/kde/26.0.4/manjaro-kde-26.0.4-260327-linux618.iso"
    "https://download.manjaro.org/xfce/26.0.4/manjaro-xfce-26.0.4-260327-linux618.iso"
    "https://download.manjaro.org/gnome/26.0.4/manjaro-gnome-26.0.4-260327-linux618.iso"
    "https://releases.nixos.org/nixos/26.05/nixos-26.05.4937.8eeec934ae0d/nixos-graphical-26.05.4937.8eeec934ae0d-x86_64-linux.iso"
    "https://mirror.lagoon.nc/linuxlite/linuxlite/isos/8.0/linux-lite-8.0-64bit.iso"
    "https://fastly.mirror.pkgbuild.com/iso/2026.07.01/archlinux-x86_64.iso"
)

# --- MULTIMÉDIA & ÉDUCATION ---
ISO_EDUCATIONS=(
    "https://cdimages.ubuntu.com/edubuntu/releases/26.04/release/edubuntu-26.04-desktop-amd64.iso"
    "https://cdimage.ubuntu.com/edubuntu/releases/noble/release/edubuntu-24.04.4-desktop-amd64.iso"
    "https://mirrors.univ-reims.fr/IMAGES/zorinos/18/Zorin-OS-18.1-Education-64-bit.iso"
    "https://archive.org/download/endless-os-3x-64bit-pc/eos-eos3.9-amd64-amd64.210706-203204.base.iso"
)

# --- SERVEURS & SYSTÈMES ---
ISO_SERVEUR=(
    "https://releases.ubuntu.com/resolute/ubuntu-26.04-live-server-amd64.iso"
    "https://releases.ubuntu.com/noble/ubuntu-24.04.4-live-server-amd64.iso"
    "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-13.5.0-amd64-netinst.iso"
    "https://distfiles.gentoo.org/releases/amd64/autobuilds/20260712T170110Z/install-amd64-minimal-20260712T170110Z.iso"
    "https://distfiles.gentoo.org/releases/amd64/autobuilds/20260712T170110Z/livegui-amd64-20260712T170110Z.iso"
    "https://enterprise.proxmox.com/iso/proxmox-ve_9.2-1.iso"
    "https://enterprise.proxmox.com/iso/proxmox-backup-server_4.2-1.iso"
    "https://enterprise.proxmox.com/iso/proxmox-mail-gateway_9.1-1.iso"
    "https://enterprise.proxmox.com/iso/proxmox-datacenter-manager_1.1-1.iso"
    "https://download.fedoraproject.org/pub/fedora/linux/releases/44/Server/x86_64/iso/Fedora-Server-dvd-x86_64-44-1.7.iso"
    "https://repo.almalinux.org/almalinux/10/isos/x86_64/AlmaLinux-10.2-x86_64-dvd.iso"
    "https://repo.almalinux.org/almalinux/10/isos/x86_64/AlmaLinux-10.2-x86_64-boot.iso"
    "https://download.rockylinux.org/pub/rocky/10/isos/x86_64/Rocky-10.2-x86_64-dvd1.iso"
    "https://download.rockylinux.org/pub/rocky/10/isos/x86_64/Rocky-10.2-x86_64-minimal.iso"
    "https://mirror.stream.centos.org/10-stream/BaseOS/x86_64/iso/CentOS-Stream-10-20260707.1-x86_64-dvd1.iso"
    "https://opensuse.mirror.garr.it/mirrors/opensuse/tumbleweed/iso/openSUSE-Tumbleweed-NET-x86_64-Snapshot20260714-Media.iso"
    "https://pkg.adfinis-on-exoscale.ch/opensuse/distribution/leap/16.0/offline/Leap-16.0-offline-installer-x86_64.install.iso"
    "https://pkg.adfinis-on-exoscale.ch/opensuse/distribution/leap/16.0/offline/Leap-16.0-online-installer-x86_64.install.iso"
    "https://channels.nixos.org/nixos-26.05/latest-nixos-minimal-x86_64-linux.iso"
    "https://download.freebsd.org/releases/ISO-IMAGES/15.1/FreeBSD-15.1-RELEASE-amd64-dvd1.iso"
)

# --- MULTIMÉDIA STREAMING / CLOUD PERSO ---
ISO_STREAMING=(
    "https://umbrel-release-assets.a45c7e2f6ae2c47088a72e84553d4403.r2.cloudflarestorage.com/1.7.4/umbrelos-amd64-usb-installer.iso"
    "https://deac-ams.dl.sourceforge.net/project/openmediavault/iso/8.3.1/openmediavault_8.3.1-amd64.iso"
    "https://dietpi.com/downloads/images/DietPi_VM-x86_64-Trixie_Installer.iso"
)

# --- CREATION / MONTAGE VIDÉO ---
ISO_MONTAGE=(
    "https://cdimage.ubuntu.com/ubuntustudio/releases/resolute/release/ubuntustudio-26.04-desktop-amd64.iso"
    "https://cdimage.ubuntu.com/ubuntustudio/releases/noble/release/ubuntustudio-24.04.3-dvd-amd64.iso"
)

# --- GAMING ---
ISO_GAMING=(
    "https://cdn77.cachyos.org/ISO/desktop/260628/cachyos-desktop-linux-260628.iso"
    "https://dn721805.ca.archive.org/0/items/steam-os/SteamOS.iso"
    "https://nobara-images.nobaraproject.org/Nobara-43-Official-NV-2026-04-24.iso"
    "https://nobara-images.nobaraproject.org/Nobara-43-GNOME-NV-2026-04-25.iso"
    "https://nobara-images.nobaraproject.org/Nobara-43-KDE-NV-2026-04-25.iso"
    "https://nobara-images.nobaraproject.org/Nobara-43-Steam-HTPC-NV-2026-04-25.iso"
)

# --- SÉCURITÉ / PENTEST ---
ISO_SECURITE=(
    "https://kali.download/base-images/kali-2026.2/kali-linux-2026.2-installer-netinst-amd64.iso"
    "https://deb.parrot.sh/parrot/iso/7.3/Parrot-security-7.3_amd64.iso"
)


# 4. Fonction générique de téléchargement
telecharger_urls() {
    local -a urls_to_download=("${@}")
    if [ ${#urls_to_download[@]} -eq 0 ]; then
        echo "Aucun fichier à télécharger."
        return
    fi
    
    echo -e "\n=================================================="
    echo "Début du téléchargement (${#urls_to_download[@]} fichiers) dans $TARGET_DIR..."
    echo -e "==================================================\n"
    
    for url in "${urls_to_download[@]}"; do
        # Ignore les éléments vides éventuels
        [ -z "$url" ] && continue
        
        filename=$(basename "$url")
        echo "--------------------------------------------------"
        echo "Vérification / Téléchargement de : $filename"
        echo "--------------------------------------------------"
        # -c : Reprend le téléchargement si interrompu
        # --no-verbose : Évite d'inonder le terminal tout en affichant l'essentiel
        wget -c --no-verbose "$url"
    done
    echo -e "\n[SUCCÈS] Opération terminée pour cette sélection.\n"
}

# 5. Fonction pour sélectionner individuellement au sein d'une catégorie
menu_choix_individuel() {
    local categorie_nom="$1"
    shift
    local -a liste_urls=("${@}")
    
    while true; do
        clear
        echo "============================================="
        echo "  SÉLECTION INDIVIDUELLE : $categorie_nom"
        echo "============================================="
        for i in "${!liste_urls[@]}"; do
            echo "$((i+1)) ) $(basename "${liste_urls[$i]}")"
        done
        echo "T ) Télécharger TOUTE cette catégorie"
        echo "R ) Retour au menu principal"
        echo "============================================="
        read -rp "Votre choix : " sub_choix
        
        if [[ "$sub_choix" =~ ^[0-9]+$ ]] && [ "$sub_choix" -le "${#liste_urls[@]}" ] && [ "$sub_choix" -gt 0 ]; then
            local index=$((sub_choix-1))
            telecharger_urls "${liste_urls[$index]}"
            read -rp "Appuyez sur Entrée pour continuer..."
        elif [[ "$sub_choix" =~ ^[tT]$ ]]; then
            telecharger_urls "${liste_urls[@]}"
            read -rp "Appuyez sur Entrée pour continuer..."
            break
        elif [[ "$sub_choix" =~ ^[rR]$ ]]; then
            break
        else
            echo "Choix invalide."
            sleep 1
        fi
    done
}

# 6. Menu Principal interactif
menu_principal() {
    while true; do
        clear
        echo "=========================================================="
        echo "        GESTIONNAIRE DE TÉLÉCHARGEMENT ISO (iVentoy)"
        echo "=========================================================="
        echo " 1 )  BUREAUTIQUE / USAGE GÉNÉRAL"
        echo " 2 )  MULTIMÉDIA & ÉDUCATION"
        echo " 3 )  MULTIMÉDIA STREAMING / CLOUD PERSO (OMV, Umbrel...)"
        echo " 4 )   SERVEURS & VIRTUALISATION (Proxmox, BSD, etc.)"
        echo " 5 )   MONTAGE VIDÉO & PRODUCTION (Ubuntu Studio...)"
        echo " 6 )  GAMING (Nobara, CachyOS...)"
        echo " 7 )   SÉCURITÉ / PENTEST (Kali, Parrot...)"
        echo "----------------------------------------------------------"
        echo " A )  Télécharger ABSOLUMENT TOUTES les ISO (Gros volume !)"
        echo " Q )  Quitter le script"
        echo "=========================================================="
        read -rp "Choisissez une catégorie ou une option [1-7 / A / Q] : " choix
        
        case "$choix" in
            1) menu_choix_individuel "Bureautique" "${ISO_BUREAUTIQUE[@]}" ;;
            2) menu_choix_individuel "Multimédia" "${ISO_MULTIMEDIA[@]}" ;;
            3) menu_choix_individuel "Streaming & Cloud" "${ISO_STREAMING[@]}" ;;
            4) menu_choix_individuel "Serveurs" "${ISO_SERVEUR[@]}" ;;
            5) menu_choix_individuel "Montage Vidéo" "${ISO_MONTAGE[@]}" ;;
            6) menu_choix_individuel "Gaming" "${ISO_GAMING[@]}" ;;
            7) menu_choix_individuel "Sécurité" "${ISO_SECURITE[@]}" ;;
            [aA])
                echo "Êtes-vous sûr de vouloir télécharger TOUTES les catégories ? (Plusieurs dizaines de Go)"
                read -rp "Continuer ? (o/N) : " confirm
                if [[ "$confirm" =~ ^[oO]$ ]]; then
                    telecharger_urls "${ISO_BUREAUTIQUE[@]}" "${ISO_MULTIMEDIA[@]}" "${ISO_STREAMING[@]}" "${ISO_SERVEUR[@]}" "${ISO_MONTAGE[@]}" "${ISO_GAMING[@]}" "${ISO_SECURITE[@]}"
                    read -rp "Appuyez sur Entrée pour continuer..."
                fi
                ;;
            [qQ])
                echo "Au revoir !"
                exit 0
                ;;
            *)
                echo "Option invalide, veuillez réessayer."
                sleep 1.5
                ;;
        esac
    done
}

# Lancement du menu principal
menu_principal
