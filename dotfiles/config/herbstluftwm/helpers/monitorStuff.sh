#!/usr/bin/env bash

source $HOME/.config/herbstluftwm/variables
source $HOME/.config/herbstluftwm/helpers/hc.sh

function getActiveMonitorRegion() {
    getMonitorRegion
}

function getMonitorCount() {
    hc list_monitors | wc -l
}

function getMonitorOfWindow() {
    winId="$1"
    eval $(xdotool getwindowgeometry --shell $winId)
    # X, Y, WIDTH, HEIGHT => window coordinates

    X=$(($X + $WIDTH / 2))
    Y=$(($Y + $HEIGHT/ 2))

    while read -r line ; do
        monitorId=$(echo "$line" | cut -d':' -f1)
        monitorName=$(echo "$line" | cut -d' ' -f7)
        if [[ "$monitorName" == "\"$floatingMonitorName\"" ]] ; then
            continue
        fi

        # X, Y => window middle 
        # MonitorX, MonitorY, MonitorWidth, MonitorHeight => monitor coordinates
        eval $(getMonitorRegion $monitorId)
        if [[ $X -lt $(($MonitorX + $MonitorWidth)) && \
            $X -gt $MonitorX && \
            $Y -gt $MonitorY && \
            $Y -lt $(($MonitorY + $MonitorHeight)) ]] ; then
            echo $monitorId
            break
        fi
    done <<< $(hc list_monitors)
}

function getMonitorRegion() {
    monId="$1"
    monRect=$(herbstclient monitor_rect $monId)
    echo MonitorX=$(echo $monRect | cut -d" " -f1)
    echo MonitorY=$(echo $monRect | cut -d" " -f2)
    echo MonitorWidth=$(echo $monRect | cut -d" " -f3)
    echo MonitorHeight=$(echo $monRect | cut -d" " -f4)
}

function shiftWindowToMonitor() {
    windowId="$1"
    monitorId="$(getMonitorOfWindow $windowId)"

    echo Shifting $windowId to $monitorId
    
    herbstclient chain , jumpto $windowId , shift_to_monitor $monitorId
}

