#!/bin/bash
sudo apt update && sudo apt full-upgrade -y
sudo apt installl htop nala apache2 -y
sudo systemctl enable apache2
sudo systemctl start apache2