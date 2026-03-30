#!/bin/bash
sudo apt update && sudo apt full-upgrade -y
sudo apt install wget nala htop glances -y 
glances --fetch