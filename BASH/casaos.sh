#!/bin/bash
# Mets à jour le système 
sudo apt update && sudo apt upgrade -y
# Installation du serveur cloud 
curl -fsSL https://get.casaos.io | sudo bash