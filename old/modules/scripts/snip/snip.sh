#!/usr/bin/env bash

# For some reason gnome-screenshot doesn't want to copy to clipboard if it doesn't have a destination file and when it does it's unreliable

# So instead we save the file, copy it to clipboard ourselves and remove the file
gnome-screenshot --area -f /tmp/tmp.png &&
	cat /tmp/tmp.png | wl-copy --type image/png
rm /tmp/tmp.png
