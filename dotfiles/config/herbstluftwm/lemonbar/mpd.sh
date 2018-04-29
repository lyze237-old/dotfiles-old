#!/usr/bin/env bash
# https://linux.die.net/man/1/mpc - idleloop

music=""
function updateMpd() {
    local state="$(mpc status | awk -F '[][]' 'NR==2 {print $2}')"

    local song=""
    local artist=""
    local newMusic="Paused"

    if [ "$state" == "playing" ] ; then
        local song="$(mpc current -f '%title%')"
        local artist="$(mpc current -f '%artist%')"

        local toDisplay="$song - $artist"
        if [ -z "$song" ] || [ -z "$artist" ] ; then
            local file="$(mpc current -f '%file%')"
            newMusic="$(basename "$file")"
        fi
    fi 

    if [ "$music" != "$newMusic" ] ; then
        music="$newMusic"
        echo "%{B$otherBgColor F$otherFgColor O6}  $newMusic%{O6}" > "$mpdCache"
        return 0
    fi

    return 1
}

function registerMpdHook() {
    local running="true"
    while true ; do
        if [ ! "$(mpc status 2> /dev/null)" ] ; then
            if [ "$running" == "true" ] ; then
                echo "State changed to not running"
                echo "%{B$otherBgColor F$otherFgColor O6}  mpd not running %{O6}" > "$mpdCache"
                hc emit_hook RELOAD_LEMONBAR
                music=""
                running="false"
            fi
            sleep 1
            continue
        fi

        echo "State changed to running"
        running="true"
        updateMpd
        hc emit_hook RELOAD_LEMONBAR
        mpc idleloop |
        while read -r line; do
            echo "mpd updated, updating song"
            if updateMpd ; then
                hc emit_hook RELOAD_LEMONBAR
            fi
        done 
    done
}
