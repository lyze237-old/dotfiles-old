#!/usr/bin/env bash

function restart() {
    $HOME/.config/herbstluftwm/rofi/closeAll.sh
    systemctl reboot 
}

function lock() {
    $HOME/.config/owl/scripts/lock/lock.sh
}

function shutdown() {
    $HOME/.config/herbstluftwm/rofi/closeAll.sh
    systemctl poweroff
}

function quitWm() {
    $HOME/.config/herbstluftwm/rofi/closeAll.sh
    herbstclient quit
}

ret=$(echo -e "Lock\nShutdown\nQuit\nRestart" | rofi -dmenu)
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
    "Quit")
        quitWm
        ;;
esac
