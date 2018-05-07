#!/bin/bash

to=$(($1 - 1))

monitor=$(bspc query -M -m .focused)
displays=($(bspc query -D -m $monitor))

found=$(echo "${displays[$to]}")

bspc desktop -f $found

