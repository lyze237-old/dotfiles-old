#!/bin/bash

notify-send ClipboardXdg Starting application
xdg-open $(xclip -o)

