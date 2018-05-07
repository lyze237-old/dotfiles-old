#!/bin/bash

function progressBar {
	character=$1
	amount=$2
	filler=$3
	maxAmount=$4

	string=""

	i=1
	while [ "$i" -le "$maxAmount" ]; do
		if [ "$i" -le "$amount" ]; then
			string=$string$character
		else
			string=$string$filler
		fi
		i=$(($i + 1))
	done

	echo $string
}

function getActiveSink {
    pacmd list-sinks |awk '/* index:/{print $3}'
}

function getVolume {
	SINK=$(getActiveSink)
    pacmd list-sinks |grep -A 15 'index: '${active_sink}'' |grep 'volume:' |egrep -v 'base volume:' |awk -F : '{print $3}' |grep -o -P '.{0,3}%'|sed s/.$// |tr -d ' ' | head -n $SINK | tail -1
}

function isMute {
	SINK=$(getActiveSink)
	pactl list sinks | grep '^[[:space:]]Mute:' | head -n $(( $SINK + 1)) | grep -P 'yes' > /dev/null
}

function sendNotification {
	echo Sending Volume
	volume=$(getVolume)
	echo Got Volume $volume

	if isMute ; then
		bar=$(echo Mute)
	else
		bar=$(progressBar █ $(($volume / 5)) ─ 20) #100/5 = 20
	fi
	echo Sending notification $bar
	dunstify -t 8 -r 2593 -u normal "" "$bar"
}

case $1 in
	up)
		echo Increasing Volume
		pactl set-sink-volume @DEFAULT_SINK@ +5%
		sendNotification
		;;

	down)
		echo Decreasing Volume
		pactl set-sink-volume @DEFAULT_SINK@ -5%
		sendNotification
		;;

	mute)
		echo Toggling Mute
		pactl set-sink-mute @DEFAULT_SINK@ toggle
		sendNotification
		;;
	esac
