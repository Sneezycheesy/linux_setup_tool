#!/usr/bin/bash

if [[ $1 == system ]]; then
	playerctl -a pause; 
	if [ -e "/tmp/mpvsocket" ]; then 
		echo '{ "command": ["set_property", "pause", true] }' | socat - /tmp/mpvsocket;
	fi
fi

if [[ $1 == mpv ]]; then
	if [ -e "/tmp/mpvsocket" ]; then
		echo '{ "command": ["cycle", "pause"] }' | socat - /tmp/mpvsocket;
	fi
	
	if [[ $2 == next ]]; then
		if [ -e "/tmp/mpvsocket" ]; then
			echo '{ "command": ["playlist-next"] }' | socat - /tmp/mpvsocket;
			echo '{ "command": ["set_property", "pause", false] }' | socat - /tmp/mpvsocket; 
		fi
	fi
	
	if [[ $2 == prev ]]; then
		if [ -e "/tmp/mpvsocket" ]; then
			echo '{ "command": ["playlist-prev"] }' | socat - /tmp/mpvsocket;
			echo '{ "command": ["set_property", "pause", false] }' | socat - /tmp/mpvsocket; 
		fi
	fi
fi

if [[ $1 == toggle ]]; then
	playerctl -a -i firefox,google-chrome,qutebrowser play-pause;
fi