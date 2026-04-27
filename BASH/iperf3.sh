#!/bin/bash
# Mise à jour du système 
sudo apt update && sudo apt full-upgrade -y
# Installation de iperf3
sudo apt install iperf3 -y
# Lacement de iperf3
iperf3 -s
