#!/bin/bash

# apply screenlayout and co
~/.config/owl/scripts/screenlayout.sh
setxkbmap gb
numlockx on
xsetroot -cursor_name Breeze_Obsidian &

# music desktop 
termite --title pulsemixer -e 'fish -c "while true; pulsemixer; end"' &
sleep 0.5 && termite --title htop -e 'fish -c "while true; htop; end"' &
sleep 1 && termite --title ncmpcpp -e 'fish -c "while true; ncmpcpp; end"' &
mopidy &

# awesome desktop 
termite --title dotfiles -d $HOME/.dotfiles/dotfiles-public &
sleep 0.5 && termite --title shell -d $HOME/.config/awesome/ &
sleep 1 && termite --title awesome-rc.lua -e 'fish -c "cd ~/.config/awesome/ ; vim rc.lua ; fish"' &

# reddit desktop 
termite --title rtv -e rtv &

# weechat desktop 
termite --title weechat -e weechat &

# mail desktop 
thunderbird &

# other
bash -c 'sleep 5 ; steam' &
firefox &
bash -c 'sleep 5 ; nextcloud' &
compton &
redshift-gtk &

~/.config/owl/scripts/updateFishWeather.sh &

# chat desktop 
/opt/lyze/Telegram/Telegram &
sleep 0.5 && corebird &
sleep 1 && discord &

# albert
#albert & 