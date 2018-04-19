#!/usr/bin/env bash

date=""
function updateDate() {
    newDate=$(date "+%d %b, %H:%M")
    if [ "$date" != "$newDate" ] ; then
        date="$newDate"
        echo "%{B$otherBgColor F$otherFgColor O6}  $date%{O16}" > "$dateCache"
        return 0
    fi
    return 1
}

function registerDateHook() {
    updateDate 

    hc -i |
    while read -r line; do
        case $line in
            REFRESH_DATA*SMALL*)
                if updateDate ; then
                    hc emit_hook RELOAD_LEMONBAR
                fi
            ;;
        esac
    done 
}
