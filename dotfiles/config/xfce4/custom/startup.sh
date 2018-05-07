#!/usr/bin/fish

# chat desktop
discord &
/opt/Telegram/Telegram &
corebird &

# other
bash -c 'sleep 5 ; steam' &
vivaldi &
bash -c 'sleep 30 ; nextcloud' &
compton &
redshift-gtk &
thunderbird &

# music desktop
terminator -l music &

# position all windows
/home/lyze/.config/xfce4/custom/positionWindows.sh &

