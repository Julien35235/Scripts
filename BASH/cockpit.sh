#!/bin/bash
apt update && apt full-upgrade -y
apt install cockpit -y
systemctl enable cockpit.socket
