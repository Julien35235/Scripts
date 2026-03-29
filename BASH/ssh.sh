#!/bin/bash
sudo apt update && apt full-upgrade -y
sudo apt install openssh-server ssh -y
sudo systemctl enable ssh 
sudo systemctl start ssh
 