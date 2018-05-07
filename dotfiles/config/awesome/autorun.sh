#!/bin/bash

# apply screenlayout and co
~/.config/awesome/screenlayout.sh
setxkbmap gb
numlockx on
xsetroot -cursor_name Breeze_Obsidian &

# music desktop 
xfce4-terminal --title pulsemixer -x fish -c "while true; pulsemixer; end" &
sleep 0.5 && xfce4-terminal --title htop -x fish -c "while true; htop; end" &
sleep 1 && xfce4-terminal --title mopidy -e 'fish -c "while mopidy; end"' --tab --title ncmpcpp -e 'fish -c "while true; ncmpcpp; end"' &

# awesome desktop 
xfce4-terminal --title dotfiles --working-directory=$HOME/.dotfiles/dotfiles-public &
sleep 0.5 && xfce4-terminal --title shell --working-directory=$HOME/config/awesome/ &
sleep 1 && xfce4-terminal --title awesome-rc.lua -e 'fish -c "cd ~/.config/awesome/ ; nano rc.lua ; fish"' &

# reddit desktop 
xfce4-terminal --title rtv -x rtv &

# weechat desktop 
xfce4-terminal --title weechat -x weechat &

# mail desktop 
thunderbird &

# other
bash -c 'sleep 5 ; steam' &
vivaldi &
bash -c 'sleep 30 ; nextcloud' &
compton &
redshift-gtk &
flameshot &

~/.config/awesome/scripts/updateFishWeather.sh &

# chat desktop 
/opt/Telegram/Telegram &
sleep 0.5 && corebird &
sleep 1 && discord &
