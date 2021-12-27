#!/bin/sh
export QT_QPA_PLATFORMTHEME=gtk2
xsetroot -cursor_name left_ptr

eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK
export _JAVA_AWT_WM_WONREPARENTING=1;

#alsactl store &
#wmname LG3D &
#sxhkd &
xmonad --recompile &
#picom &

session=${1:-xmonad}

case $session in
	sway            ) exec sway;;
	xmonad		) exec xmonad;;
	xfce|xfce4	) exec startxfce4;;
	dwm		) exec dwm;;
	qtile		) exec qtile;;
	*		) exec $1;;
esac
