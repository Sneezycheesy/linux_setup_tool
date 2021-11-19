#!/usr/bin/bash
if [[ $1 == toggle ]]; then
	if [[ $2 == mpv ]]; then
		echo '{ "command": ["cycle", "mute"] }' | socat - /tmp/mpvsocket;
	else
		source_sink="@DEFAULT_$2@";
		pactl set-$3-mute ${source_sink} toggle;
	fi
fi

if [[ $1 == mpv ]]; then
	if [[ $2 != volume ]]; then
		if [ -e "/tmp/mpvsocket" ]; then
			echo '{ "command": ["cycle", "mute"] }' | socat - /tmp/mpvsocket;
		fi
	else
		if [[ $3 == 1 ]]; then
			echo '{ "command": ["add", "volume", 1] }' | socat - /tmp/mpvsocket;
		else
			echo '{ "command": ["add", "volume", -1] }' | socat - /tmp/mpvsocket;
		fi
	fi
fi

if [[ $1 == volume ]]; then
	pactl set-$2-volume @DEFAULT_$3@ $41%;
	echo "#24" `#24 pactl get-source-volume @DEFAULT_SOURCE@ | grep "Volume" | cut -d"/" -f2 | polybar screen0`;
fi

if [[ $1 == sink ]]; then
	if [[ $2 == speakers ]]; then
		sink="alsa_output.usb-NAE_Technologies_Inc_R-51PM-01.analog-stereo";
	elif [[ $2 == headset ]]; then
		sink="alsa_output.usb-Logitech_PRO_X_000000000000-00.analog-stereo";
	else
		bluetooth=$(pactl list sinks | grep "Name: bluez_*")
		sink=$(cut -d':' -f2 <<< ${bluetooth});
	fi
	
	new_sink=`pactl set-default-sink $sink`;
	xmonad --restart;
fi

if [[ $1 == source ]]; then
	if [[ $2 == headset ]]; then
		source="alsa_output.usb-Logitech_PRO_X_000000000000-00.analog-stereo.monitor";
	elif [[ $2 == record ]]; then
		source="alsa_input.usb-BurrBrown_from_Texas_Instruments_USB_AUDIO_CODEC-00.analog-stereo";
	fi

	
	pactl set-default-source $source;
	xmonad --restart;
fi
