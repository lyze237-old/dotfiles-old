#!/bin/bash

mkdir ~/.cache
mkdir ~/.cache/fish/

while true ; do
	wget "http://wttr.in/Wels+UpperAustria?" -O "$HOME/.cache/fish/weather"
	wget "http://wttr.in/Wels+UpperAustria?1" -O "$HOME/.cache/fish/weather?1"
	wget "http://wttr.in/Wels+UpperAustria?n" -O "$HOME/.cache/fish/weather?n"
	wget "http://wttr.in/Wels+UpperAustria?n1" -O "$HOME/.cache/fish/weather?n1"
	wget "http://wttr.in/Wels+UpperAustria?0" -O "$HOME/.cache/fish/weather?0"
	sleep 3600
done
