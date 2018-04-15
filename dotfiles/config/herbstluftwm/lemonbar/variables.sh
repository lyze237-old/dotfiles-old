#!/usr/bin/env bash
# https://linux.die.net/man/1/mpc - idleloop


# dirs
cache="$HOME/.cache/lemonbar"
workspacesCache="$cache/workspaces"
mpdCache="$cache/mpd"
dateCache="$cache/date"
mailCache="$cache/mail"

mkdir -p $cache
mkdir -p $workspacesCache
mkdir -p $mpdCache
mkdir -p $dateCache
mkdir -p $mailCache

# colors - gruvbox
bg1Color="#1d2021"
bg2Color="#3c3836"
bg3Color="#504945"
fg1Color="#ebdbb2"
fg2Color="#a89984"
fg3Color="#7c6f64"

pinkColor="#d3869b"
redColor="#fb4934"
orangeColor="#fe8019"
yellowColor="#fabd2f"
limeColor="#b8bb26"
greenColor="#b8bb26"
blueColor="#83a598"

darkRedColor="#cc241d"
darkGreenColor="#98971a"
darkYellowColor="#d79921"
darkBlueColor="#458588"
darkPurpleColor="#b16286"
darkAquaColor="#689d6a"
darkOrangeColor="#d65d0e"


# colors - general
barBgColor="$bg1Color"
barFgColor="$fg1Color"

# colors - workspaces
emptyTagColor="$fg3Color"
focusedTagColor="$redColor"
urgentTagColor="$orangeColor"
unknownTagColor="$pinkColor"

# other
delimiter=">"
barSize=32

