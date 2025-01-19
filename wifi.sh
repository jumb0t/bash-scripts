#!/bin/bash

# Function to generate random MAC address
generate_random_mac() {
    openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//'
}

# Function to print colored text
print_color() {
    color=$1
    message=$2
    case $color in
        red)
            echo -e "\033[0;31m$message\033[0m"
            ;;
        green)
            echo -e "\033[0;32m$message\033[0m"
            ;;
        yellow)
            echo -e "\033[0;33m$message\033[0m"
            ;;
        *)
            echo $message
            ;;
    esac
}

# Function to log messages
log_message() {
    message=$1
    log_file="wifi_connect.log"
    echo "$(date +"%Y-%m-%d %T") - $message" >> "$log_file"
}

# Set custom parameters

SSID="wifi"
PASSWORD="11111111"




INTERFACE="wlan1"  # Correct interface name
MTU="1500"  # MTU value

# Check if interface exists
if [[ ! -e "/sys/class/net/$INTERFACE" ]]; then
    print_color red "Interface $INTERFACE not found!"
    exit 1
fi

# Disconnect from any existing WiFi network
nmcli device disconnect $INTERFACE &>/dev/null || true

# Shutdown interface
if sudo ip link set dev $INTERFACE down &>/dev/null; then
    print_color green "Interface $INTERFACE successfully shut down"
else
    print_color yellow "Failed to shut down interface $INTERFACE"
fi

# Generate random MAC address
RANDOM_MAC=$(generate_random_mac)

# Change MAC address
if sudo ip link set dev $INTERFACE address $RANDOM_MAC &>/dev/null; then
    print_color green "MAC address changed to $RANDOM_MAC"
else
    print_color red "Failed to change MAC address"
fi

# Set MTU
if sudo ip link set dev $INTERFACE mtu $MTU &>/dev/null; then
    print_color green "MTU changed to $MTU"
else
    print_color red "Failed to change MTU"
fi

# Bring interface up
if sudo ip link set dev $INTERFACE up &>/dev/null; then
    print_color green "Interface $INTERFACE successfully brought up"
else
    print_color red "Failed to bring up interface $INTERFACE"
fi

# Disable IPv6
sudo sysctl -w net.ipv6.conf.$INTERFACE.disable_ipv6=1 &>/dev/null || true  # Ignore error if file not found

# Connect to WiFi network with WPA/WPA2 security
nmcli_output=$(sudo nmcli device wifi connect $SSID password $PASSWORD ifname $INTERFACE 2>&1)

# Check if connection is successful
if [ $? -eq 0 ]; then
    print_color green "Connected to $SSID with MAC address $RANDOM_MAC"
    log_message "Connected to $SSID with MAC address $RANDOM_MAC"
else
    print_color red "Failed to connect to $SSID"
    print_color yellow "Debug Info:"
    nmcli device status
    nmcli device show $INTERFACE
    print_color red "Error: $nmcli_output"
    log_message "Failed to connect to $SSID. Error: $nmcli_output"
fi
