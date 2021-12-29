#!/bin/sh
xrandr --output DisplayPort-2 --off --output DisplayPort-0 --off DisplayPort-1 --mode 1920x1080 --pos 0x0 --rotate normal --primary --output HDMI-A-0 --mode 1920x1080 --pos 1920x0 --rotate normal
echo default-amd > /home/joshii/.screenlayout/check.txt

# --mode 1920x1080 --pos 1920x0 --rotate normal # Monitor 2
# --mode 1920x1080 --pos 3840x0 --rotate normal # Monitor 3
