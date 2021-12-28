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
    installYay
    setHostname
    addUser
    installPackages 'packages'
    installPackages 'sway'
    installPackages 'print'
    installPackages 'steam'
    installPackages 'wine'
    setupEfiStub
}

setupAudio() {
    installPackages audio
    sudo -u ${username} systemctl enable --machine=${username}@.host --user pipewire
    sudo -u ${username} systemctl enable --machine=${username}@.host --user pipewire-pulse
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

setupEfiStub() {
    pacman -S efimanager
    lsblk -o PATH,SIZE,LABEL,MOUNTPOINT
    while [[ -n ${boot_device} || -n ${boot_partition} ]]; do
        echo "Please choose the boot device (i.e. /dev/sda): "
        read boot_device
        echo "Please choose the boot partition [1]: "
        read boot_partition
        [[ -n "${boot_partition}" ]] || boot_partition=1
    done

    while [[ -n "${root_partuuid}" ]]; do
        lsblk -o PATH,SIZE,LABEL,MOUNTPOINT
        echo "Please choose the root partition (i.e. /dev/sda3):"
        read root_partition

        root_partuuid="$(lsblk -o PATH,PARTUUID | grep ${root_partition} | awk '{print $2}')"
    done

    echo "Want to set up hibernation?[y/N]"
    read i_want_hibernation
    [[ -n "${i_want_hibernation}" || $(echo "${i_want_hibernation} | tr [:upper:] [:lower:]") != "y" ]] || i_want_hibernation="N"
    if [[ "y" = $(echo "${i_want_hibernation}" | tr [:upper:] [:lower:]) ]]; then
        echo "Please choose the swap partition (i.e. /dev/sda2):"
        read swap_partition
        swap_partuuid="$(lsblk -o PATH,PARTUUID | grep ${swap_partition} | awk '{print $2}')"

        efibootmgr --disk ${boot_device} --part ${boot_partition} --create --label "Arch Linux" --loader /vmlinuz-linux \ 
        --unicode "root=PARTUUID=${root_partuuid} resume=PARTUUID=${swap_partuuid} rw initrd=\initramfs-linux.img" --verbose
    else
        efibootmgr --disk ${boot_device} --part ${boot_partition} --create --label "Arch Linux" --loader /vmlinuz-linux \ 
        --unicode "root=PARTUUID=${root_partuuid} rw initrd=\initramfs-linux.img" --verbose
    fi
}

main() {
    [[ "$1" == 'default' ]] && runDefaultSetup
}

main default