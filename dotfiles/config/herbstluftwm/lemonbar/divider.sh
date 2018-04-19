#!/usr/bin/env bash

function dividerLeft() {
    if [ "$#" -ne 2 ] ; then
        echo "Divier requires 2 arguments (leftColor rightColor)"
        return
    fi

    leftColor=$1
    rightColor=$2

    echo "%{F$leftColor}%{B$rightColor}%{R}%{R}%{F- B-}"
}

function dividerRight() {
    if [ "$#" -ne 2 ] ; then
        echo "Divier requires 2 arguments (leftColor rightColor)"
        return
    fi

    leftColor=$2
    rightColor=$1

    echo "%{F$leftColor}%{B$rightColor}%{R}%{R}%{F- B-}"
}

function smallDividerRight() {
    if [ "$#" -ne 2 ] ; then
        echo "Divier requires 2 arguments (leftColor rightColor)"
        return
    fi

    leftColor=$1
    rightColor=$2

    echo "%{F$leftColor}%{B$rightColor}%{R}%{F- B-}"
}
