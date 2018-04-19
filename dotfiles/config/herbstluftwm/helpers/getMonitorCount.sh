#!/usr/bin/env bash

function getMonitorCount() {
    hc list_monitors | wc -l
}


