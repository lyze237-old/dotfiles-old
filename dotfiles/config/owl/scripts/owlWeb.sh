#!/bin/bash

echo Got url $1
echo "$1" >> $HOME/.xdg-open.history

echo $1 > $HOME/.cache/requireFullscreen

case "$1" in
	*htt*://www.twitch.tv/r/e/*)
		url=`echo $1 | awk -F '/' '{print $9}' | awk -F '?' '{print $1}'`
		url=`echo https://www.twitch.tv/$url`
		notify-send -i "$HOME/.config/owl/scripts/icons/twitch.png" Streamlink $url
		echo "streaming $1 via streamlink (converted to $url)"
		streamlink $url
		exit 0
	;;
	*htt*://*.twitch.tv*)
		notify-send -i "$HOME/.config/owl/scripts/icons/twitch.png" Streamlink $1
		echo streaming $1 via streamlink
		streamlink $1
		exit 0
	;;
	*htt*://www.youtube.com/watch*|*htt*://youtu.be*)
		notify-send -i "$HOME/.config/owl/scripts/icons/youtube.png" Youtube $1
		echo streaming $1 via mpv
		mpv $1
		exit 0
	;;
	*htt*://www.picarto.tv*|*htt*://picarto.tv*)
		notify-send -i "$HOME/.config/owl/scripts/icons/picarto.png" Streamlink $1
                echo streaming $1 via streamlink
                streamlink $1
		exit 0
	;;
	*htt*://www.pietsmiet.de*)
		notify-send -i "$HOME/.config/owl/scripts/icons/pietsmiet.png" Pietsmiet $1
		echo streaming $1 via mpv
		mpv $1
		exit 0
	;;
	*htt*)
		notify-send -i "$HOME/.config/owl/scripts/icons/qutebrowser.png" Qutebrowser $1
		echo opening web browser
		firefox-beta $1
		exit 0
	;;
esac

notify-send "Error" "No url given"
exit 0

