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
yay=" "
gaming=" "
printing=" "
wm=" "
browser=" "

installYay() {
    [ -n "$git" ] || sudo pacman -S git
    [ -n "$go" ] || sudo pacman -S go
    echo "installing yay"
    git clone https://aur.archlinux.org/yay
    cd yay
    makepkg
    sudo pacman -U yay*.pkg.*
    cd ..
    rm -rf yay
}

displayMenu() {
    echo "Welcome to this setup script, let's get into it"
    echo "[$yay] 0. Install yay (only works on Arch Linux)"
    echo "[$gaming] 1. Install packages for gaming (wine, dxvk, steam, etc.)"
    echo "[$printing] 2. Install printer services"
    echo "[$wm] 3. Install a window manager"
    echo "[$browser] 4. Install a webbrowser"
    echo "[ ] d. Done and quit"
    read choice
    [ -n "$choice" ] || choice="d"
}

while ( "$choice" != "d" ); do
    case "$choice" in
    "0") installYay ;;
    "1") ;;
    "2") ;;
    "3") ;;
    "4") ;;
done