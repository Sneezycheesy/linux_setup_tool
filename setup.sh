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
    chown -R $username:$username .
    cd yay
    su $username -c 'makepkg'
    pacman -U yay*.pkg.*
    cd ..
}

installPackages() {
    packages=""
    while read package; do
        packages="${packages} ${package}"
    done < ./packages/$1.txt
    
    su ${username} -c "yay -S ${packages}"
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
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
    locale-gen

    ln -sf /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime
    hwclock --systohc

    setHostname
    addUser

    pacman-key --init
    pacman-key --populate archlinux
    pacman -Syy

    installYay
    setupAudio
    setupNetworkManager
    installPackages 'packages'
    installPackages 'xmonad'
    installPackages 'print'
    installPackages 'steam'
    installPackages 'wine'
    placeConfigs
}

setupNetworkManager() {
    su ${username} -c 'yay -S networkmanager networkmanager-dmenu-git'
    systemctl enable NetworkManager
}

setupAudio() {
    installPackages audio
    su ${username} -c 'sudo systemctl enable --machine=${username}@.host --user pipewire'
    su ${username} -c 'sudo systemctl enable --machine=${username}@.host --user pipewire-pulse'
}

addUser() {
    echo "Choose a username [arch]: "
    read username
    [[ -n ${username} ]] || username="arch"
    username="$(echo ${username} | tr '[:upper:]' '[:lower:]')"

    useradd -G wheel -m -s /bin/bash ${username}
    
    echo Set password for main account
    passwd $username

    echo Set password for ROOT account
    passwd

    echo '%wheel ALL=(ALL) NOPASSWD: ALL' | EDITOR='tee -a' visudo
}

setHostname() {
    echo "Choose a hostname [archtop]: "
    read hostname
    [[ -n ${hostname} ]] || hostname="archtop"

    echo ${hostname} | tr '[:upper:]' '[:lower:]' > /etc/hostname
}

setupEfiStub() {
    mkinitcpio -p linux-zen
    pacman -S efibootmgr
    lsblk -o PATH,SIZE,LABEL,MOUNTPOINT
    
    echo "Please choose the boot device (i.e. /dev/sda): "
    read boot_device
    echo "Please choose the boot partition [1]: "
    read boot_partition
    [[ -n "${boot_partition}" ]] || boot_partition=1

    lsblk -o PATH,SIZE,LABEL,MOUNTPOINT
    echo "Please choose the root partition (i.e. /dev/sda3):"
    read root_partition

        root_partuuid="$(lsblk -o PATH,PARTUUID | grep ${root_partition} | awk '{print $2}')"

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

placeConfigs() {
    cp -r .config .screenlayouts .scripts .xmonad .icons /home/${username}
    chown -R ${username} /home/${username}
}

main() {
    [[ "$1" == 'default' ]] && runDefaultSetup
}

main default