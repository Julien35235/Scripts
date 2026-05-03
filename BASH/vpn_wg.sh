#!/bin/bash
#Installation du serveur wireguard vpn
apt-get install sudo git iptables -y && \ 
sudo apt-get update && \
sudo apt install wireguard-tools net-tools && \
git clone https://github.com/WGDashboard/WGDashboard.git && \
cd ./WGDashboard/src && \
chmod +x ./wgd.sh && \
./wgd.sh install && \
sudo echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf && \
sudo sysctl -p /etc/sysctl.conf
cd /root/WGDashboard/src
./wgd.sh  start