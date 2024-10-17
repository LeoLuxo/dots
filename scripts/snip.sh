gnome-screenshot --area --clipboard -f /tmp/tmp.png &&
	cat /tmp/tmp.png | wl-copy --type image/png
rm /tmp/tmp.png
