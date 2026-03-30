#!/bin/bash
sudo apt update && sudo apt full-upgrade -y
sudo apt install docker-compose docker.io python3-pip htop nala git -y
cd /opt
mkdir docker 
cd docker 
sudo git clone https://github.com/aloks98/isoman.git
cd isoman
docker compose up -d