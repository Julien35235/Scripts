#!/bin/bash
# Mets à jour le système 
apt update && apt upgrade -y
#Installation du serveur YunoHost
curl https://install.yunohost.org | bash