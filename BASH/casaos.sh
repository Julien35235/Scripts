#!/bin/bash
# Mets à jour le système 
apt update && apt upgrade -y
# Installation du serveur cloud 
curl -fsSL https://get.casaos.io | sudo bash