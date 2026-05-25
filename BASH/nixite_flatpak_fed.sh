#!/usr/bin/env bash
set -e

BLACK="\e[0;30m"
BLUE="\e[1;34m"
CYAN="\e[36m"
RESET="\e[0m"
UNDERLINE="\e[4m"
NO_UNDERLINE="\e[24m"

echo -e "${BLACK}"
cat <<'EOF'
               .__         .__   __
         ____  |__|___  ___|__|_/  |_   ____
        /    \ |  |\  \/  /|  |\   __\_/ __ \
        |  |  \|  | >    < |  | |  |  \  ___/
        |__|  /|__|/__/\_ \|__| |__|   \___  >
            \/           \/                \/
EOF

echo -e "${BLUE}    Sit back while we install your linux software"
echo -e "${RESET}Report bugs to ${CYAN}${UNDERLINE}https://github.com/aspizu/nixite/issues${NO_UNDERLINE}${RESET}"
echo

if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    if [[ "$ID" != "fedora" ]]; then
        echo "This script was designed to run on fedora, but the current system is running $ID, select $ID in Nixite and download again."
        exit 1
    fi
else
    echo "File not found: /etc/os-release, are you running Linux?"
    exit 1
fi

install_system() {
    sudo dnf install -y --allowerasing "$@"
}

install_flatpak() {
    flatpak install flathub -y "$@"
}

install_system firefox
install_system fedora-workstation-repositories
sudo dnf -y config-manager setopt google-chrome.enabled=1
install_system google-chrome-stable
install_system thunderbird
sudo dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
install_system discord
install_system https://zoom.us/client/latest/zoom_x86_64.rpm
install_system telegram-desktop
install_flatpak com.slack.Slack
install_flatpak com.spotify.Client
install_system strawberry
install_system vlc
