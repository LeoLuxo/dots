#!/usr/bin/env bash

# Get the ID of the boot manager for windows
ID=$(sudo efibootmgr | grep -i windows | cut -c 5-8)
# Set it for the next boot
sudo efibootmgr -n $ID

reboot
