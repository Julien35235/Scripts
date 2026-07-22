# Update system
sudo apt update && sudo apt full-upgrade -y

#Installing the Required Packages
sudo apt install htop nala btm curl wget -y 

# Retrieving the .deb file for proxlb 
sudo wget https://github.com/gyptazy/ProxLB/releases/download/v1.1.11/proxlb_1.1.11_all.deb

#Installing ProxLB
sudo nala install ./proxlb_1.1.11_all.deb -y

# Start service
sudo systemctl start proxlb
