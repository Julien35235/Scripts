#!/bin/bash
sudo apt update && apt full-upgrade -y
sudo apt install cockpit -y
sudo systemctl enable cockpit.socket
sudo systemctl start cockpit.socket

