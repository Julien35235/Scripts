#!/bin/bash
release=/etc/os-release
if grep -q "Arch" "$release"; then
    echo "This host is based on Arch Linux"
    sudo pacman -Syu
elif grep -q "kali" "$release" || grep -q "debian" "$release"; then
    echo "This host is based on Kali/Ubuntu (Debian-based)"
    sudo apt update && sudo apt upgrade -y
    sudo apt-get update && sudo apt-get upgrade -y
    sudo apt dist-upgrade -y
    sudo reboot
else
    echo "Unsupported Linux distribution."
fi