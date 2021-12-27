#!/usr/bin/env bash
# This script is called JSS (J's Setup Script)
# This will prompt for a few settings,
# But does most setup steps automatically
# Non interactively

installMandatoryPackages() {
    pacman -S gvfs ntfs-3g jq wget noto-fonts ttf-font-awesome go \
        playerctl pipewire pipewire-pulse pipewire-alsa base-devel \
        firefox chromium neofetch kitty slurp grim udisks2
}

installDesktopEnvironments() {
    # Future feature:
    #   Create a selection list for multiple des/wms
    #   Allow for multiple selections (e.g. xmonad && sway && xfce4)
    #   Grab required packages from the .txt files in the packages
    #   folder and install them

    # Needs to be run AFTER setting up the user to make use of yay
    pacman -S sway waybar bemenu bemenu-wayland mako wl-clipboard
}

installGamingPackages() {
    installPackages gaming
}

installPackagesFromFile() {
    packages=""
    while read package; do
        packages="${packages} ${package}"
    done < packages/$1.txt
    
    sudo -u ${username} yay ${packages}
}

contains_element() { # {{{
	#check if an element exist in a string
	for e in "${@:2}"; do [[ "$e" == "$1" ]] && break; done
} # }}} 

main() {
    return
    # setupBaseSystem
    # setLocale
    # setTimeZone
    # setHostname
    # setDesktopEnvironment
    # installPackages
    # setupEfistub
}

# main
