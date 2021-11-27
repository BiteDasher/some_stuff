#!/bin/bash
icon="/usr/share/icons/Adwaita/48x48/status/display-brightness-symbolic.symbolic.png"

device="/sys/class/backlight/$1"
op="$2"
curb="$(<$device/brightness)"
maxb="$(<$device/max_brightness)"
for percent in 1 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100; do
	eval '__'$percent'="$(( maxb * '$percent' / 100 ))"'
done
for percent in 1 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 80 95 100; do
	eval '
	if [[ $curb == $__'$percent' ]]; then cur=$__'$percent'; break; fi
	if [[ $curb == $__'$((percent-5))' ]]; then cur=$__'$((percent-5))'; break; fi
	if (( $curb < $__5 && $curb > $__1 )); then cur=$__1; break; fi
	if (( $curb < $__5 && $curb < $__1 )); then cur=$__1; break; fi
	if (( $curb < $__100 && $curb > $__95 )); then cur=$__95; break; fi
	(( percent == 1 )) && continue
	if (( $curb < $__'$((percent+5))' && $curb > $__'$percent')); then
		cur=$__'$percent'
		break
	else
		continue
	fi
	'
done

case "$op" in
	'+')
case $cur in
		$__1)  _current=$__5  ;; $__5)  _current=$__10  ;; $__10) _current=$__15 ;; $__15) _current=$__20 ;;
		$__20) _current=$__25 ;; $__25) _current=$__30 ;; $__30) _current=$__35 ;; $__35) _current=$__40 ;;
		$__40) _current=$__45 ;; $__45) _current=$__50 ;; $__50) _current=$__55 ;; $__55) _current=$__60 ;;
		$__60) _current=$__65 ;; $__65) _current=$__70 ;; $__70) _current=$__75 ;; $__75) _current=$__80 ;;
		$__80) _current=$__85 ;; $__85) _current=$__90 ;; $__90) _current=$__95 ;; $__95) _current=$__100 ;;
		$__100) _current=$__100 ;;
esac
	;;
	'-')
case $cur in
		$__1)  _current=$__1  ;; $__5)  _current=$__1  ;; $__10) _current=$__5 ;; $__15) _current=$__10 ;;
		$__20) _current=$__15 ;; $__25) _current=$__20 ;; $__30) _current=$__25 ;; $__35) _current=$__30 ;;
		$__40) _current=$__35 ;; $__45) _current=$__40 ;; $__50) _current=$__45 ;; $__55) _current=$__50 ;;
		$__60) _current=$__55 ;; $__65) _current=$__60 ;; $__70) _current=$__65 ;; $__75) _current=$__70 ;;
		$__80) _current=$__75 ;; $__85) _current=$__80 ;; $__90) _current=$__85 ;; $__95) _current=$__90 ;;
		$__100) _current=$__95 ;;
esac
	;;
esac
echo "$_current" > $device/brightness
[ "$3" == notify ] && notify-send -i "$icon" -- ${op}5%
:
