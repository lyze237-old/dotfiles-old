#!/bin/bash

echo Got url $1

case "$1" in
	*htt*://www.twitch.tv/r/e/*)
		url=`echo $1 | awk -F '/' '{print $9}' | awk -F '?' '{print $1}'`
		url=`echo https://www.twitch.tv/$url`
		notify-send -i "/home/lyze/.config/xfce4/custom/icons/twitch.png" Streamlink $url

		echo "streaming $1 via streamlink (converted to $url)"
		streamlink $url
	;;
	*htt*://*.twitch.tv*)
		notify-send -i "/home/lyze/.config/xfce4/custom/icons/twitch.png" Streamlink $1
		echo streaming $1 via streamlink
		streamlink $1
	;;
	*htt*://www.youtube.com*|*htt*://youtu.be*)
		notify-send -i "/home/lyze/.config/xfce4/custom/icons/youtube.png" Youtube $1
		echo streaming $1 via mpv
		mpv $1
	;;
	*htt*://www.picarto.tv*|*htt*://picarto.tv*)
		notify-send -i "/home/lyze/.config/xfce4/custom/icons/picarto.png" Streamlink $1
                echo streaming $1 via streamlink
                streamlink $1
	;;
	*htt*://www.pietsmiet.de*)
		notify-send -i "/home/lyze/.config/xfce4/custom/icons/pietsmiet.png" Pietsmiet $1
		echo streaming $1 via mpv
		mpv $1
	;;
	*)
		notify-send -i "/home/lyze/.config/xfce4/custom/icons/vivaldi.png" Vivaldi $1
		echo opening web browser
		vivaldi $1
	;;
esac
