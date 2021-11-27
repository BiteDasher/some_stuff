#!/bin/bash
touchpad_enabled="/usr/share/icons/Adwaita/48x48/legacy/input-touchpad.png"
touchpad_disabled="/usr/share/icons/Adwaita/48x48/status/touchpad-disabled-symbolic.symbolic.png"
device="$1"
ignore="$3"
status="$(xinput list-props "$device" | grep -o 'Device Enabled.*' | grep -o '.$')"
case "$status" in
	"1")
	[ "$ignore" == 1 ] || xinput set-prop "$device" "Device Enabled" 0
	[ "$2" == notify ] && notify-send -i "$touchpad_disabled" "Touchpad disabled"
	;;
	"0")
	[ "$ignore" == 1 ] || xinput set-prop "$device" "Device Enabled" 1
	[ "$2" == notify ] && notify-send -i "$touchpad_enabled" "Touchpad enabled"
	;;
esac
:
