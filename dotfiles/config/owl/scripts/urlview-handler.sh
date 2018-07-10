#!/bin/bash

if [ -z ${DISPLAY+x} ] ; then
    w3m $@
else
    nohup firefox $@ -- > /dev/null 2>&1 &
fi
