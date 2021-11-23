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