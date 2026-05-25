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
    if [[ "$ID" != "debian" ]]; then
        echo "This script was designed to run on debian, but the current system is running $ID, select $ID in Nixite and download again."
        exit 1
    fi
else
    echo "File not found: /etc/os-release, are you running Linux?"
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive
sudo apt update

install_system() {
    sudo apt install -y "$@"
}

install_flatpak() {
    if ! command -v flatpak &> /dev/null; then
        install_system flatpak
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    fi
    flatpak install flathub -y "$@"
}

install_system firefox-esr
install_system curl
curl -L https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /tmp/google-chrome.deb && sudo apt install -y /tmp/google-chrome.deb && rm /tmp/google-chrome.deb
install_system thunderbird
curl -L "https://discord.com/api/download?platform=linux&format=deb" -o /tmp/discord.deb && sudo apt install -y /tmp/discord.deb && rm /tmp/discord.deb
curl -L https://zoom.us/client/latest/zoom_amd64.deb -o /tmp/zoom.deb && sudo apt install -y /tmp/zoom.deb && rm /tmp/zoom.deb
install_flatpak org.telegram.desktop
install_flatpak com.slack.Slack
if [[ ! -f "/etc/apt/sources.list.d/spotify.list" ]]; then
curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update
fi
install_system spotify-client
install_system strawberry
install_system vlc
