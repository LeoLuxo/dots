#!/usr/bin/env bash

# Using pkexec to elevate the script using the GUI-sudo-thing
[[ "$EUID" == 0 ]] || exec pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY "$0" "$@"

# Get the ID of the boot manager for windows
ID=$(sudo efibootmgr | grep -i windows | cut -c 5-8)
# Set it for the next boot
sudo efibootmgr -n $ID

# reboot
