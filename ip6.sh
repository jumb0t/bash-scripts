#!/bin/bash

# Disable IPv6 in kernel parameters
echo "Disabling IPv6 in kernel parameters..."
echo "net.ipv6.conf.all.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf

# Apply the changes immediately
sudo sysctl -p

# Disable IPv6 in NetworkManager
echo "Disabling IPv6 in NetworkManager..."
sudo sed -i '/\[main\]/a ipv6.disable_ipv6 = 1' /etc/NetworkManager/NetworkManager.conf

# Restart NetworkManager
sudo systemctl restart NetworkManager

echo "IPv6 disabled in NetworkManager."



#!/bin/bash

# Scan all active network interfaces and disable IPv6 on each of them
echo "Scanning active network interfaces and disabling IPv6..."

# Get list of active interfaces
active_interfaces=$(ip -o link show | awk -F': ' '{print $2}')

# Iterate through each interface
for interface in $active_interfaces; do
    # Check if the interface has IPv6 enabled
    ipv6_enabled=$(sysctl -n net.ipv6.conf.$interface.disable_ipv6)
    if [ "$ipv6_enabled" != "1" ]; then
        # Disable IPv6 on the interface
        echo "Disabling IPv6 on interface $interface..."
        sudo sysctl -w net.ipv6.conf.$interface.disable_ipv6=1
    else
        echo "IPv6 already disabled on interface $interface."
    fi
done

echo "IPv6 disabled on all active interfaces."
