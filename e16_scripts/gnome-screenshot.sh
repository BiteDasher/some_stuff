#!/bin/sh
file="$(mktemp -d).png"
op="$1"
save="$2"
[ "$save" == file ] && arg="" || arg=("-f" "$file")
case "$1" in
	window)
	gnome-screenshot -w "${arg[@]}"
	;;
	area)
	gnome-screenshot -a "${arg[@]}"
	;;
	screen)
	gnome-screenshot "${arg[@]}"
	;;
esac
if [ "$save" == file ]; then :; else
xclip -t image/png -selection clipboard -i "$file"
rm -f "$file"
fi
