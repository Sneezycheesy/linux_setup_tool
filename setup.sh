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
installYay() {
    pacman -S git go
    git clone https://aur.archlinux.org/yay
    cd yay
    makepkg -i
    cd ..
}

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
    installPackages xmonad
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
    setHostname
    addUser
    installPackages 'packages'
    installPackages 'sway'
    installPackages 'print'
    installPackages 'steam'
    installPackages 'wine'
}

setupAudio() {
    installPackages audio
    sudo -u ${username} systemctl enable --machine=$(hostname)@.host --user pipewire
    sudo -u ${username} systemctl enable --machine=$(hostname)@.host --user pipewire-pulse
}

addUser() {
    echo "Choose a username [arch]: "
    read username
    [[ -n ${username} ]] || username="arch"
    username="$(echo ${username} | tr '[:upper:]' '[:lower:]')"

    useradd -G wheel,libvirt -d -s /bin/bash ${username}
}

setHostname() {
    echo "Choose a hostname [archtop]: "
    read hostname
    [[ -n ${hostname} ]] || hostname="archtop"

    echo ${hostname} | tr '[:upper:]' '[:lower:]' > /etc/hostname
}

main() {
    [[ "$1" == 'default' ]] && runDefaultSetup
}

installYay
main default