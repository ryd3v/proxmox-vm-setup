#!/bin/bash

# Check if the script is run with root privileges
if [ "$(id -u)" -ne 0 ]; then
    echo 'This script must be run with root privileges' >&2
    exit 1
fi

# Update and upgrade the system
apt update && apt upgrade -y

# add user
# adduser r
# usermod -aG r
# apt install sudo

# Check if a reboot is required
if [ -f /var/run/reboot-required ]; then
    echo "A reboot is required in order to proceed with the install." >&2
    echo "Please reboot and re-run this script to finish the install." >&2
    exit 1
fi

apt install qemu-guest-agent -y
systemctl enable qemu-guest-agent

# xrdp
apt install xrdp -y
echo "xfce4-session" | tee .xsession
systemctl restart xrdp
systemctl enable xrdp

# Check if ufw is active
if ufw status | grep -q 'Status: active'
then
    # If ufw is active, run your commands
    ufw allow from any to any port 3389
    ufw enable
else
    echo "ufw is not active"
fi