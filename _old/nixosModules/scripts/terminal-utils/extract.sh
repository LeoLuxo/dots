#!/usr/bin/env bash

# https://www.reddit.com/r/linux/comments/1g8cyrd/comment/lt0nwsp/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button

if [ -f $1 ]; then
	case $1 in
	*.tar.bz2) tar xvjf $1 ;;
	*.tar.gz) tar xvzf $1 ;;
	*.tar.xz) tar xf $1 ;;
	*.bz2) bunzip2 $1 ;;
	*.rar) rar x $1 ;;
	*.gz) gunzip $1 ;;
	*.tar) tar xvf $1 ;;
	*.tbz2) tar xvjf $1 ;;
	*.tgz) tar xvzf $1 ;;
	*.zip) unzip $1 ;;
	*.Z) uncompress $1 ;;
	*.7z) 7z x $1 ;;
	*) echo "don't know how to extract '$1'..." ;;
	esac
else
	echo "'$1' is not a valid file!"
fi
