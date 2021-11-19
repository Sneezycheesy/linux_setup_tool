#!/bin/bash
playerctl -a pause;
if [ -e "/tmp/mpvsocket" ]; then
    echo '{ "command": ["set_property", "pause", true] }' | socat - /tmp/mpvsocket;
fi 
grim -t png /tmp/lock.png;
swaylock \
       	-S \
	--clock \
	--indicator-idle-visible \
	-K -e \
	--indicator-radius 150 \
	--indicator-thickness 5 \
	--ring-color "#01112a" \
	--line-color "#01112a" \
	--ring-ver-color "#0c567b" \
	--ring-wrong-color "#8f0000" \
	--ring-caps-lock-color "#00A6FF" \
	--ring-clear-color "#AF7F00" \
	--inside-color "#11111100" \
	--inside-ver-color "#11111100" \
	--inside-wrong-color "#11111100" \
	--inside-clear-color "#11111100" \
	--inside-caps-lock-color "#11111100" \
	--text-color "#999999" \
	--text-ver-color "#999999" \
	--text-wrong-color "#999999" \
	--text-clear-color "#999999" \
	--text-caps-lock-color "#999999" \
	--key-hl-color "#01113a" \
	--separator-color "#01113a" \
	--effect-scale 3840x1080 \
        --effect-blur 10x3	
