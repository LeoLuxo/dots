if [[ -e "$(cat /tmp/Q_LAST_DIR_$(id -u))" ]]; then
	echo "cd '$(cat /tmp/Q_LAST_DIR_$(id -u))'"
else
	echo 'echo "No directory to cd to."'
fi
