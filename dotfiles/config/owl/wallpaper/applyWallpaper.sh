#!/bin/bash


for index in 0 2 2 2 2 ; do
	sleep $index && feh --bg-scale '/home/lyze/.config/owl/wallpaper/middle.png' --bg-scale '/home/lyze/.config/owl/wallpaper/left.png' --bg-scale '/home/lyze/.config/owl/wallpaper/right.png' &
done
