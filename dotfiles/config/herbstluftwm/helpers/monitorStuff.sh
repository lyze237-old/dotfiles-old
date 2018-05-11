#!/usr/bin/env bash

function getMonitorCount() {
    hc list_monitors | wc -l
}

function getActiveMonitorRegion() {
    getMonitorRegion
}

function getMonitorRegion() {
    monId="$1"
    monRect=$(herbstclient monitor_rect $monId)
    echo MonitorX=$(echo $monRect | cut -d" " -f1)
    echo MonitorY=$(echo $monRect | cut -d" " -f2)
    echo MonitorWidth=$(echo $monRect | cut -d" " -f3)
    echo MonitorHeight=$(echo $monRect | cut -d" " -f4)
}

