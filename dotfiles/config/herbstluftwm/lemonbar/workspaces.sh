#!/usr/bin/env bash

monitorCount=$(getMonitorCount)

function updateWorkspaces() {
    for (( monitorIndex=0; monitorIndex<monitorCount; monitorIndex++ )) ; do
        local file="$workspacesCache/$monitorIndex"
        local tags=($(hc tag_status $monitorIndex))
        
        local tagsOutput=""

        for tag in ${tags[@]} ; do

            if [[ $tag != *${monitorIndex}_* ]] ; then
                continue
            fi

            local tagHelperIndex="$(echo $tag "_" | awk '{print index($1, $2)}')"
            local cmd="herbstclient chain , focus_monitor $monitorIndex , use ${tag:1}"


            case $tag in
            .${monitorIndex}_*) # tag is empty.
                tagsOutput="$tagsOutput%{F$emptyTagFgColor A:$cmd:}$emptyTag%{A} "
                ;;
            :${monitorIndex}_*) # tag is not empty.
                tagsOutput="$tagsOutput%{F$tagFgColor A:$cmd:}$fullTag%{A} "
                ;;
            +${monitorIndex}_*) # tag is viewed on the monitor but monitor is not focused.
                tagsOutput="$tagsOutput%{F$focusedTagOtherFgColor A:$cmd:}$fullTag%{A} "
                ;;
            \#${monitorIndex}_*) # tag is viewed on the monitor and it is focused.
                tagsOutput="$tagsOutput%{F$focusedTagFgColor A:$cmd:}$fullTag%{A} "
                ;; 
            !${monitorIndex}_*) # the tag contains an urgent window
                tagsOutput="$tagsOutput%{F$urgentTagFgColor A:$cmd:}$fullTag%{A} "
                ;;
            *)
                tagsOutput="$tagsOutput%{F$unknownTagFgColor A:$cmd:}$emptyTag%{A} "
                ;;
            esac
        done

        tagsOutput="%{B$tagBgColor O16}$tagsOutput"
        echo "$tagsOutput" > "$file"

    done 
}

function registerWorkspacesHook() {
    hc -i |
    while read -r line; do
        case $line in
        tag_changed*)
            echo "Tag changed, update workspaces and reload bar"
            updateWorkspaces
            hc emit_hook RELOAD_LEMONBAR
            ;;
        esac
    done
}
