#!/usr/bin/env bash
# https://www.reddit.com/r/unixporn/comments/4u0onh/discovery_super_responsive_lemonbar_on/

# includes
echo "Sourcing variables"
source ~/.config/herbstluftwm/helpers/gruvbox.sh
source ~/.config/herbstluftwm/lemonbar/variables.sh 

echo "Sourcing functions"
source ~/.config/herbstluftwm/helpers/hc.sh
source ~/.config/herbstluftwm/helpers/getMonitorCount.sh

echo "Sourcing bar specifics"
source ~/.config/herbstluftwm/lemonbar/mpd.sh
source ~/.config/herbstluftwm/lemonbar/date.sh
source ~/.config/herbstluftwm/lemonbar/divider.sh
source ~/.config/herbstluftwm/lemonbar/workspaces.sh 
source ~/.config/herbstluftwm/lemonbar/email.sh

# Fetch all data
function fetchData() {
    echo "Subscribing to mpd events"
    registerMpdHook &

    echo "Subscribing to workspace events"
    registerWorkspacesHook &

    echo "Subscribing to email events"
    registerEmailHook &

    echo "Subscribing to date events"
    registerDateHook &

    echo "Spawning big/small data refresh events"
    # Emit hooks to keep it updating
    while true; do
        hc emit_hook REFRESH_DATA BIG
        for i in {1..10}; do
        hc emit_hook REFRESH_DATA SMALL
        sleep 5
        done
    done &
}

function setupBar() {
    local monitorIndex=$1
    local monitorRegion=$2
    local barRegion="$(echo "$monitorRegion" "$barSize" | awk 'match($0, /([0-9]+)x([0-9]+)\+([0-9]+)\+([0-9]+)/, matches) {print matches[1]"x"$2"+"matches[3]"+"matches[4]}')"

    echo "Starting bar on monitor $monitorIndex with region $barRegion"

    herbstclient pad "$monitorIndex" "$barSize" 

    hc -i |
    while read -r line; do
        case $line in 
            RELOAD_LEMONBAR*)
                newWorkspaces=$(cat "$workspacesCache"/"$monitorIndex")
                newDate=$(cat "$dateCache")
                newEmail=$(cat "$emailCache")
                newMpd=$(cat "$mpdCache")

                needToUpdate="false"
                if [ "$workspaces" != "$newWorkspaces" ] ; then
                    workspaces="$newWorkspaces"
                    needToUpdate="true"
                fi 
                if [ "$date" != "$newDate" ] ; then
                    date="$newDate"
                    needToUpdate="true"
                fi 
                if [ "$mpd" != "$newMpd" ] ; then
                    mpd="$newMpd"
                    needToUpdate="true"
                fi 
                if [ "$needToUpdate" == "true" ] ; then
                    (>&2 echo "Updating bar for real ...")
                    barLeft="$workspaces%{B- F-}$(dividerLeft "$tagBgColor" "$barBgColor")"
                    barCenter="%{F$blueColor}\\%{F$redColor}\"%{F$blueColor}\\%{F$yellowColor}^%{F$fg1Color}v%{F$yellowColor}^%{F$blueColor}/%{F$redColor}\"%{F$blueColor}/%{B- F-}" # \"\OvO/"/
                    barRight="$(dividerRight "$barBgColor" "$otherBgColor")$mpd$(smallDividerRight "$barBgColor" "$otherBgColor")$date%{B- F-}"

                    echo -e "%{l}$barLeft %{c}$barCenter %{r}$barRight"
                fi
                ;;
        esac
    done | lemonbar -g "$barRegion" -a 20 -f "$fontName:size=$fontSize" -f "dejavu sans:size=$fontSize" -B "$barBgColor" -F "$barFgColor" -o -1 | while read -r line; do 
        echo "$line"
        bash <<< "$line"
    done &

    echo "Done setting up bar on monitor $monitorIndex"
}


function startEverything() {
    echo "Fetching data"
    fetchData &

    echo "Spawning bars"
    while read -r line ; do
        monitorId=$(echo "$line" | cut -d':' -f1)
        monitorRegion=$(echo "$line" | cut -d' ' -f2)
        setupBar "$monitorId" "$monitorRegion"
    done <<< $(hc list_monitors)
}

echo "Starting bar"
startEverything &
echo "Waiting for herbstluft quit/reload event"
hc -w '(quit_panel|reload)'
echo "Stopping bar and all other scripts"
kill 0
