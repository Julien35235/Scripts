#!/bin/bash
#Update to systems 
sudo apt update && sudo apt full-upgrade -y
#Install curl 
Sudo apt install curl wget htop btop nala -y
#Install AdguardVPN
curl -fsSL https://raw.githubusercontent.com/AdguardTeam/AdGuardVPNCLI/master/scripts/release/install.sh | sh -s -- -v
# Login to your account
adguardvpn-cli login
#Connect to the VPN 
adguardvpn-cli connect
