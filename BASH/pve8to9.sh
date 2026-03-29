#!/bin/bash
sudo apt update && sudo apt full-upgrade
sudo reboot
pve8to9
sed -i 's/bookworm/trixie/g' /etc/apt/sources.list 
sudo apt update 
sudo apt full-upgrade
sudo reboot
