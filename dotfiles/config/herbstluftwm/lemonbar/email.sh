#!/usr/bin/env bash

emails=""
function updateEmail() {
    newEmails="0"

    symbol=""
    if [[ "$newEmails" -eq 0 ]] ; then
        symbol=""
    fi

    newEmails="$symbol $newEmails"

    if [ "$emails" != "$newEmails" ] ; then
        emails="$newEmails"
        echo "%{B$otherBgColor F$otherFgColor O6} $emails%{O6}" > "$emailCache"
        return 0
    fi
    return 0
}

function registerEmailHook() {
    updateEmail

    hc -i |
    while read -r line; do
        case $line in
            REFRESH_DATA*BIG*)
                if updateEmail ; then
                    hc emit_hook RELOAD_LEMONBAR
                fi
            ;;
        esac
    done 
}
