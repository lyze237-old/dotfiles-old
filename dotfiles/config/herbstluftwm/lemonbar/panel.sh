#!/usr/bin/env bash
# https://www.reddit.com/r/unixporn/comments/4u0onh/discovery_super_responsive_lemonbar_on/

# includes
source ~/.config/herbstluftwm/lemonbar/variables.sh

source ~/.config/herbstluftwm/helpers/hc.sh
source ~/.config/herbstluftwm/helpers/getMonitorCount.sh

source ~/.config/herbstluftwm/lemonbar/mpd.sh
source ~/.config/herbstluftwm/lemonbar/date.sh
source ~/.config/herbstluftwm/lemonbar/workspaces.sh
source ~/.config/herbstluftwm/lemonbar/email.sh

# Fetch all data
function fetchData() {
    hc -i |
    while read line; do
        case $line in
        tag_changed*)
            workspaces
            hc emit_hook RELOAD_LEMONBAR
            ;;


        REFRESH_DATA*BIG*)
            hc emit_hook RELOAD_LEMONBAR
            ;;


        REFRESH_DATA*SMALL*)
            hc emit_hook RELOAD_LEMONBAR
            ;;
        esac
    done &

    # Emit hooks to keep it updating
    while true; do
        hc emit_hook REFRESH_DATA BIG
        for i in {1..10}; do
        hc emit_hook REFRESH_DATA SMALL
        sleep 3
        done
    done &
}

function setupBar() {
    local monitorIndex=$1
    local monitorRegion=$2
    local barRegion=$(echo $monitorRegion $barSize | awk 'match($0, /([0-9]+)x([0-9]+)\+([0-9]+)\+([0-9]+)/, matches) {print matches[1]"x"$2"+"matches[3]"+"matches[4]}')

    echo "Starting bar on monitor $monitorIndex with region $barRegion"

    herbstclient pad $monitorIndex 32

    hc -i |
    while read -r line; do
        case $line in 
            RELOAD_LEMONBAR*)
                workspaces=$(cat $workspacesCache/$monitorIndex)
                ;;
        esac
        
        bar=$workspaces

        echo -e $bar
    done | lemonbar -g "$barRegion" -a 20 | while read -r line; do 
        echo "$line"
        bash <<< "$line"
    done & # -B "$barBgColor" -F "$barFgColor" &
}


function startEverything() {
    fetchData

    while read -r line ; do
        # get id from line
        monitorId=$(echo $line | cut -d':' -f1)
        monitorRegion=$(echo $line | cut -d' ' -f2)
        setupBar $monitorId $monitorRegion
    done <<< $(hc list_monitors)
}


pids=( )
startEverything &
pids+=( $! )
hc -w '(quit_panel|reload)'
kill ${pids[@]}

