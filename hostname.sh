#!/bin/bash

# Function to print error messages
print_error() {
    echo -e "\033[0;31mERROR: $1\033[0m"
}

# Function to print information messages
print_info() {
    echo -e "\033[0;33mINFO: $1\033[0m"
}

# Set the new hostname
new_hostname="SberBox"

# Change the hostname
print_info "Changing hostname to '$new_hostname'..."
sudo hostnamectl set-hostname $new_hostname || { print_error "Failed to set hostname."; exit 1; }

# Update /etc/hosts to reflect the new hostname
print_info "Updating /etc/hosts file..."
sudo sed -i "s/127.0.1.1.*/127.0.1.1\t$new_hostname/g" /etc/hosts || { print_error "Failed to update /etc/hosts."; exit 1; }

# Update /etc/hostname
print_info "Updating /etc/hostname file..."
echo $new_hostname | sudo tee /etc/hostname > /dev/null || { print_error "Failed to update /etc/hostname."; exit 1; }

# Disable hostname broadcasting in NetworkManager
print_info "Disabling hostname broadcasting in NetworkManager..."
echo -e "[main]\nhostname=$new_hostname" | sudo tee -a /etc/NetworkManager/NetworkManager.conf > /dev/null || { print_error "Failed to update NetworkManager configuration."; exit 1; }

# Restart NetworkManager
print_info "Restarting NetworkManager..."
sudo systemctl restart NetworkManager || { print_error "Failed to restart NetworkManager."; exit 1; }

echo "Hostname changed to $new_hostname, /etc/hosts and /etc/hostname updated, and hostname broadcasting disabled."
