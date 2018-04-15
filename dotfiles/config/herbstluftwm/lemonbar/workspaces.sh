#!/usr/bin/env bash

monitorCount=$(getMonitorCount)

function getTagName() {
    local monitor=$1
    local tag=$2
    local index=$(echo $tag "_" | awk '{print index($1, $2)}')
    local cmd="herbstclient chain , focus_monitor $monitor , use ${tag:1}"

    echo "%{A:$cmd:}${tag:$index}%{A}"
}

function workspaces() {
    for (( monitorIndex=0; monitorIndex<$monitorCount; monitorIndex++ )) ; do
        local file="$workspacesCache/$monitorIndex"
        local tags=($(hc tag_status $monitorIndex))
        
        local tagsOutput=""

        for tag in ${tags[@]} ; do

            if [[ $tag != *${monitorIndex}_* ]] ; then
                continue
            fi

            case $tag in
            .${monitorIndex}_*) # tag is empty.
                tagsOutput="$tagsOutput %{F$emptyTagColor}$(getTagName $monitorIndex $tag)"
                ;;
            :${monitorIndex}_*) # tag is not empty.
                tagsOutput="$tagsOutput %{F$barFgColor}$(getTagName $monitorIndex $tag)" 
                ;;
            +${monitorIndex}_*) # tag is viewed on the monitor but monitor is not focused.
                tagsOutput="$tagsOutput %{F$focusedTagColor}$(getTagName $monitorIndex $tag)" 
                ;;
            \#${monitorIndex}_*) # tag is viewed on the monitor and it is focused.
                tagsOutput="$tagsOutput %{F$focusedTagColor}$(getTagName $monitorIndex $tag)" 
                ;;
            !${monitorIndex}_*) # the tag contains an urgent window
                tagsOutput="$tagsOutput %{F$urgentTagColor}$(getTagName $monitorIndex $tag)"
                ;;
            *)
                tagsOutput="$tagsOutput %{F$unknownTagColor}$(getTagName $monitorIndex $tag)"
                ;;
            esac
        done

        echo "$tagsOutput" > "$file"

    done 
}

workspaces

