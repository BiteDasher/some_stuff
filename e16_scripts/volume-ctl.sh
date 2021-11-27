#!/bin/bash
micro_unmuted="/usr/share/icons/Adwaita/32x32/legacy/microphone-sensitivity-high.png"
micro_muted="/usr/share/icons/Adwaita/32x32/legacy/microphone-sensitivity-muted.png"
micro_plus="/usr/share/icons/Adwaita/32x32/legacy/microphone-sensitivity-medium.png"
micro_minus="/usr/share/icons/Adwaita/32x32/legacy/microphone-sensitivity-low.png"
audio_plus="/usr/share/icons/Adwaita/32x32/legacy/audio-volume-medium.png"
audio_minus="/usr/share/icons/Adwaita/32x32/legacy/audio-volume-low.png"
audio_unmuted="/usr/share/icons/Adwaita/32x32/legacy/audio-volume-high.png"
audio_muted="/usr/share/icons/Adwaita/32x32/legacy/audio-volume-muted.png"
find_audio_muted() {
	_status="$(amixer -D pulse get Master|grep -o '\[[[:alpha:]]*\]$')"
	case "$_status" in *on*) echo 'Unmuted' ;; *off*) echo 'Muted' ;; esac
}
find_micro_muted() {
	_status="$(amixer -D pulse get Capture|grep -o '\[[[:alpha:]]*\]$')"
	case "$_status" in *on*) echo 'Unmuted' ;; *off*) echo 'Muted' ;; esac
}
find_audio_volume() {
	_status="$(amixer -D pulse get Master|grep -o '\[[[:digit:]]*%\]')"
	echo "${_status//[\[\]]/}"
}
find_micro_volume() {
	_status="$(amixer -D pulse get Capture|grep -o '\[[[:digit:]]*%\]')"
	echo "${_status//[\[\]]/}"
}

op="$1"
opt="$2"
volume="$3"
case "$op" in
	volume)
	pactl -- set-sink-volume @DEFAULT_SINK@ ${opt}${volume}%
	if [ "$4" == notify ]; then
		case "$opt" in '+') icon="$audio_plus" ;; '-') icon="$audio_minus" ;; esac
		notify-send -i "$icon" $(find_audio_volume)
	fi
	;;
	alsa:volume)
	amixer -D pulse sset Master ${volume}%${opt}
	if [ "$4" == notify ]; then
		case "$opt" in '+') icon="$audio_plus" ;; '-') icon="$audio_minus" ;; esac
		notify-send -i "$icon" $(find_audio_volume)
	fi
	;;
	mute)
	pactl -- set-sink-mute @DEFAULT_SINK@ toggle
	if [ "$2" == notify ]; then
		output="$(find_audio_muted)"
		case "$output" in 'Muted') icon="$audio_muted" ;; 'Unmuted') icon="$audio_unmuted" ;; esac
		notify-send -i "$icon" "$output"
	fi
	;;
	alsa:mute)
	amixer -D pulse sset Master toggle
	if [ "$2" == notify ]; then
		output="$(find_audio_muted)"
		case "$output" in 'Muted') icon="$audio_muted" ;; 'Unmuted') icon="$audio_unmuted" ;; esac
		notify-send -i "$icon" "$output"
	fi
	;;
	micro)
	pactl -- set-source-mute @DEFAULT_SOURCE@ toggle
	if [ "$2" == notify ]; then
		output="$(find_micro_muted)"
		case "$output" in 'Muted') icon="$micro_muted" ;; 'Unmuted') icon="$micro_unmuted" ;; esac
		notify-send -i "$icon" "$output"
	fi
	;;
	alsa:micro)
	amixer -D pulse sset Capture toggle
	if [ "$2" == notify ]; then
		output="$(find_micro_muted)"
		case "$output" in 'Muted') icon="$micro_muted" ;; 'Unmuted') icon="$micro_unmuted" ;; esac
		notify-send -i "$icon" "$output"
	fi
	;;
	micro-volume)
	pactl -- set-source-volume @DEFAULT_SOURCE@ ${opt}${volume}%
	if [ "$4" == notify ]; then
		case "$opt" in '+') icon="$micro_plus" ;; '-') icon="$micro_minus" ;; esac
		notify-send -i "$icon" $(find_micro_volume)
	fi
	;;
	alsa:micro-volume)
	amixer -D pulse sset Capture ${volume}%${opt}
	if [ "$4" == notify ]; then
		case "$opt" in '+') icon="$micro_plus" ;; '-') icon="$micro_minus" ;; esac
		notify-send -i "$icon" $(find_micro_volume)
	fi
	;;
esac
