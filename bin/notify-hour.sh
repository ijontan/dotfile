#!/usr/bin/bash

notify-send "Current Time" $(date +"%I%p") -t 1200 -a Time -i clock -r 1
pw-play ~/sounds/level-up.mp3
