#!/bin/bash

if [[ $(pgrep X) ]] || [[ $(pgrep Xorg) ]] ; then
    firefox $@
else
    w3m $@
fi
