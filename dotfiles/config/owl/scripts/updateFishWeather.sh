#!/bin/bash

mkdir ~/.cache
mkdir ~/.cache/fish/

while true ; do
	wget "http://wttr.in/Wels+UpperAustria?q" -O "$HOME/.cache/fish/weather"
	wget "http://wttr.in/Wels+UpperAustria?1q" -O "$HOME/.cache/fish/weather?1"
	wget "http://wttr.in/Wels+UpperAustria?nq" -O "$HOME/.cache/fish/weather?n"
	wget "http://wttr.in/Wels+UpperAustria?n1q" -O "$HOME/.cache/fish/weather?n1"
	wget "http://wttr.in/Wels+UpperAustria?0q" -O "$HOME/.cache/fish/weather?0"
	sleep 3600
done
