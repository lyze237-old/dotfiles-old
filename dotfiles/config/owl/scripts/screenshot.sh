#!/bin/bash

rm /tmp/screenshot.png

case "$1" in
    "full" | "fullscreen")
        echo fullscreen
        flameshot full -p /tmp
        ;;
    "region")
        echo region
        flameshot gui -p /tmp
        ;;
    *)
        echo "Usage:"
        echo  "./screenshot.sh fullscreen: Creates a fullscreen image"
        echo "./screenshot.sh region: Creates a region"
        ;;
esac


while [ ! -f /tmp/screenshot.png ]
do
    sleep 0.1
done

xclip -selection clipboard -t image/png < /tmp/screenshot.png
curl -F'file=@/tmp/screenshot.png' https://0x0.st | xargs echo -n |xclip -selection clipboard

notify-send Screenshot "Uploaded to 0x0.st"
