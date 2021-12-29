#!/usr/bin/bash
playerctl -a pause;
if [ -e "/tmp/mpvsocket" ]; then
echo '{ "command": ["set_property", "pause", true] }' | socat - /tmp/mpvsocket;
fi
sh ${HOME}/.xmonad/scripts/discord-deafen.sh lock;
pactl set-source-mute @DEFAULT_SOURCE@ 1;
# betterlockscreen --lock;
# use regular i3lock instead
i3lock -B 5 -k --indicator \ 
                --radius 150 \
                --time-color=FFFFFF \
                --date-color=FFFFFF \
                --ring-color=01112a \
                --keyhl-color=01112a \
                --bshl-color=01112a \
                --separator-color=01112a \
                --line-uses-ring \
                --ringver-color=0c567b \ 
                --insidever-color=0000008F
sh ${HOME}/.xmonad/scripts/discord-deafen.sh;
