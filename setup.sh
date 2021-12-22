#!/bin/bash
#
#   Script to install required packages for specific features
#   These features include:
#   - Printing
#   - Gaming
#   - Window manager(s)
#   - Browsers
#
#
installPackages() {
    packages=""
    while read package; do
        packages="${packages} ${package}"
    done < packages/$1.txt
    
    sudo -u ${username} yay -S ${packages}
}

installGraphicalInterface() {
    # TODO: Prompt what GUI to use; Possibilities:
    #   Sway (wayland)
    #   XMonad (xorg)
    #   XFCE4 (xorg)

    # Currently just install sway packages
    installPackages 'sway'
}

installPrinter() {
    #TODO: Prompt for custom scanner drivers

    # Currently just install printer packages
    installPackages 'print'
}

installGaming() {
    #TODO: Prompt for installing steam/wine(-staging/wayland)
    # Currently just install all gaming packages

    installPackages 'steam'
    installPackages 'wine'
}

runDefaultSetup() {
    installPackages 'sway'
    installPackages 'print'
    installPackages 'steam'
    installPackages 'wine'
}

main() {
    [[ "$1" == 'default' ]] && runDefaultSetup
}

main default