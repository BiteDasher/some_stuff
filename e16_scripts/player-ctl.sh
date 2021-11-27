#!/bin/bash
play="/usr/share/icons/Adwaita/48x48/actions/media-playback-start-symbolic.symbolic.png"
pause="/usr/share/icons/Adwaita/48x48/actions/media-playback-pause-symbolic.symbolic.png"
stop="/usr/share/icons/Adwaita/48x48/actions/media-playback-stop-symbolic.symbolic.png"
next="/usr/share/icons/Adwaita/48x48/legacy/go-next.png"
previous="/usr/share/icons/Adwaita/48x48/legacy/go-previous.png"

find_status() {
	_status="$(playerctl status)"
	echo "$_status"
}

op="$1"
case "$op" in
	"play-pause")
	playerctl play-pause
	status="$(find_status)"
	case "$status" in
		Playing) icon="$play" ;;
		Paused) icon="$pause" ;;
		*) status="No track in queue" ;;
	esac
	[ "$2" == notify ] && notify-send -i "$icon" "$status"
	;;
	"stop")
	playerctl stop
	[ "$2" == notify ] && notify-send -i "$stop" "Stopped"
	;;
	"next")
	playerctl next
	[ "$2" == notify ] && notify-send -i "$next" "Next track..."
	;;
	"previous")
	playerctl previous
	[ "$2" == notify ] && notify-send -i "$previous" "Previous track..."
	;;
esac
:
