#!/usr/bin/env bash

# close
windows=($(wmctrl -l))
for winid in $(wmctrl -l | awk '{print $1}') ; do
    title=$(xdotool getwindowname $winid)
    echo "Closing $title / $winid"
    herbstclient close $winid
done

# kill
windows=($(wmctrl -l))
for winid in $(wmctrl -l | awk '{print $1}') ; do
    title=$(xdotool getwindowname $winid)
    echo "Killing $title / $winid"
    xdotool windowkill $winid
done
