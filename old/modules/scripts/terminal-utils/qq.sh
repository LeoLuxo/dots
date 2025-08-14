if [[ -e "/tmp/Q_LAST_DIR_$(id -u)" ]]; then
	echo "cd '$(cat /tmp/Q_LAST_DIR_$(id -u))'"
else
	echo 'echo -e "\033[0;31mNo directory to cd to."'
fi
