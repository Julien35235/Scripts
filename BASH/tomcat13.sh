#!/bin/bash
apt update && sudo apt full-upgrade -y
sudo apt install wget nala htop -y 
cd /tmp
sudo wget https://dlcdn.apache.org/tomcat/tomcat-11/v11.0.11/bin/apache-tomcat-11.0.11.tar.gz
sudo tar zxvf apache-tomcat-11.0.11.tar.gz 
mv apache-tomcat-11.0.11 /usr/libexec/tomcat11 
useradd -M -d /usr/libexec/tomcat11 tomcat 
chown -R tomcat:tomcat /usr/libexec/tomcat11 
sudo sed -e '1c\[Unit]
Description=Apache Tomcat 11
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/libexec/tomcat11/bin/startup.sh
ExecStop=/usr/libexec/tomcat11/bin/shutdown.sh
RemainAfterExit=yes
User=tomcat
Group=tomcat

[Install]
WantedBy=multi-user.target' \
-n /dev/null > /usr/lib/systemd/system/tomcat11.service
sudo systemctl enable --now tomcat11 