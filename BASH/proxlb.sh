# Update system
sudo apt update && sudo apt full-upgrade -y

#Installing the Required Packages
sudo apt install htop nala btm curl wget -y 

# Add repository signing key
sudo wget -O /etc/apt/keyrings/proxtools-archive-keyring.gpg \
  https://packages.credativ.com/public/proxtools/archive-keyring.gpg

# Add repository
echo "deb [signed-by=/etc/apt/keyrings/proxtools-archive-keyring.gpg] \
https://packages.credativ.com/public/proxtools stable main" \
| sudo tee /etc/apt/sources.list.d/proxlb.list

# Update & install
sudo apt update
sudo apt install proxlb -y

# Copy example config
sudo cp /etc/proxlb/proxlb_example.yaml /etc/proxlb/proxlb.yaml

# Start service
sudo systemctl start proxlb
