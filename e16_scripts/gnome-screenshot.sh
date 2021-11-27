#!/bin/sh
file="$(mktemp -d).png"
op="$1"
case "$1" in
	window)
	gnome-screenshot -w -f "$file"
	;;
	area)
	gnome-screenshot -a -f "$file"
	;;
	screen)
	gnome-screenshot -f "$file"
	;;
esac
xclip -t image/png -selection clipboard -i "$file"
rm -f "$file"
