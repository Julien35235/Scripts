#!/bin/bash
# Mets à jour le système 
sudo apt update && sudo apt upgrade -y
#Installation du serveur YunoHost
curl https://install.yunohost.org | bash