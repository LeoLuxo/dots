#!/usr/bin/env bash

gnome-screenshot --area --clipboard -f /tmp/tmp.png && cat /tmp/tmp.png | wl-copy
