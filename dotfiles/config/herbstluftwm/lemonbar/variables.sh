#!/usr/bin/env bash
# https://linux.die.net/man/1/mpc - idleloop


# {{{ config
# {{{ config - dirs
cache="$HOME/.cache/lemonbar"
workspacesCache="$cache/workspaces"
mpdCache="$cache/mpd"
dateCache="$cache/date"
emailCache="$cache/mail"

mkdir -p "$cache"
mkdir -p "$workspacesCache"
# }}}

# {{{ config - other
delimiter=""
barSize=16
barGeneralOffset=20

emptyTag="○"
fullTag="●"
#emptyCircleMapping=( "⓪" "①" "②" "③" "④" "⑤" "⑥" "⑦" "⑧" "⑨" )
#filledCircleMapping=( "⓿" "❶" "❷" "❸" "❹" "❺" "❻" "❼" "❽" "❾" )

fontSize=14
fontName="UbuntuMonoDerivativePowerline Nerd Font"
# }}}
# }}}

# {{{ Colors
# {{{ colors - general
barFgColor="$fg1Color"
barBgColor="$bg1Color"
# }}}

# {{{ colors - workspaces
tagFgColor="$fg1Color"
tagBgColor="$darkOrangeColor"

emptyTagFgColor="$fg1Color"

focusedTagFgColor="$orangeColor"

focusedTagOtherFgColor="$orangeColor"

urgentTagFgColor="$redColor"

unknownTagFgColor="$pinkColor"
# }}}

# colors - others {{{
otherBgColor="$darkOrangeColor"
otherFgColor="$fg1Color"
# }}}
# }}}
