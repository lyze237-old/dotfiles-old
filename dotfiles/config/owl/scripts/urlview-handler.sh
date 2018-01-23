#!/bin/bash

if [[ $(pgrep X) ]] || [[ $(pgrep Xorg) ]] ; then
    nohup firefox $@ -- > /dev/null 2>&1 &
else
    w3m $@
fi
