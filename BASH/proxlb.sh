# Add repository signing key
sudo wget -O /etc/apt/keyrings/proxtools-archive-keyring.gpg \
  https://packages.credativ.com/public/proxtools/archive-keyring.gpg

# Add repository
echo "deb [signed-by=/etc/apt/keyrings/proxtools-archive-keyring.gpg] \
https://packages.credativ.com/public/proxtools stable main" \
| sudo tee /etc/apt/sources.list.d/proxlb.list

# Update & install
sudo apt-get update
sudo apt-get -y install proxlb

# Copy example config
sudo cp /etc/proxlb/proxlb_example.yaml /etc/proxlb/proxlb.yaml

# Adjust the config to your needs
sudo vi /etc/proxlb/proxlb.yaml

# Start service
sudo systemctl start proxlb