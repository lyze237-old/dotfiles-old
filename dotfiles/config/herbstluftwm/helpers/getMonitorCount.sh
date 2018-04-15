#!/usr/bin/env bash

function getMonitorCount() {
    echo $(hc list_monitors | wc -l)
}


