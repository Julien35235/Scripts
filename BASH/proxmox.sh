#!/bin/bash
hostname --ip-address
apt update && apt full-upgrade
sudo apt install curl software-properties-common apt-transport-https ca-certificates gnupg2 
echo "deb [arch=amd64] http://download.proxmox.com/debian/pve bookworm pve-no-subscription" >
/etc/apt/sources.list.d/pve-install-repo.list
apt update && apt full-upgrade
apt install proxmox-default-kernel proxmox-ve postfix open-iscsi chrony-y
update-grub