#!/bin/bash

# Step 1: Disable connectivity checking in NetworkManager
echo -e "[connectivity]\nuri=" | sudo tee -a /etc/NetworkManager/NetworkManager.conf > /dev/null
sudo systemctl restart NetworkManager

# Step 2: Disable listening ports in NetworkManager
#sudo sed -i '/^plugins=/ s/$/,keyfile/' /etc/NetworkManager/NetworkManager.conf
#sudo systemctl restart NetworkManager

# Step 3: Disable DNS functionality in NetworkManager
#sudo sed -i '/^plugins=/ s/$/,dns/' /etc/NetworkManager/NetworkManager.conf
#sudo systemctl restart NetworkManager

# Step 4: Disable DHCP functionality in NetworkManager
#sudo sed -i '/^plugins=/ s/$/,dhcp/' /etc/NetworkManager/NetworkManager.conf
#sudo systemctl restart NetworkManager
