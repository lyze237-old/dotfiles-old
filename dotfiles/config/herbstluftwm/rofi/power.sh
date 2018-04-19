#!/usr/bin/env bash

function restart() {
    $HOME/.config/herbstluftwm/rofi/closeAll.sh
    systemctl restart 
}

function lock() {
    $HOME/.config/owl/scripts/lock/lock.sh
}

function shutdown() {
    $HOME/.config/herbstluftwm/rofi/closeAll.sh
    systemctl poweroff
}





ret=$(echo -e "Lock\nShutdown\nRestart" | rofi -dmenu)
case "$ret" in
    "Lock")
        lock
        ;;
    "Shutdown")
        shutdown
        ;;
    "Restart")
        restart
        ;;
esac
