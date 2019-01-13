#!/usr/bin/env bash

kill -9 $(ps aux | grep spacespam.sh | grep -v grep | awk '{print $2}')
