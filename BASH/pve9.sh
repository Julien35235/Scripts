#!/bin/bash
cat > /etc/apt/sources.list.d/pve-install-repo.sources << EOL
Types: deb
URIs: http://download.proxmox.com/debian/pve
Suites: trixie
Components: pve-no-subscription
Signed-By: /usr/share/keyrings/proxmox-archive-keyring.gpg
EOL
sudo apt update && apt full-upgrade
sudo apt install proxmox-default-kernel proxmox-ve postfix open-iscsi chrony
update-grub
sudo reboot