#!bash
## Global variables
packages=""
git="$(pacman -Qe | grep 'git')"
go="$(pacman -Qe | grep 'go')"
choice=""

setPackages() {
    for var in "$@"; do
        while read package; do
            packages="$packages $package"
        done < $PWD/packages/$var.txt
        [ "$var" = "sway" ] && cargo install -f swayws
    done
}

installPackages() {
    # echo $packages
    yay -S $packages
}

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

setupPrinter() {
    echo "Please answer the following questions to properly setup a network printer/scanner (Brother printers only)"
}

echo "Welcome to JBIS (J's Basic Installation Script)"

echo "Install yay first?[Y/n]"
read yay

[ -n "$yay" ] || yay="Y"

case "$yay" in "Y" | "y") installYay;;
    *) ;;
esac

displayMenuOptions() {
    echo "Please choose one of the following options to proceed [ALL]:"
    echo "[A] Install audio drivers with pipewire and pulse"
    echo "[C] Make a custom selection of packages (NYI)"
    echo "[G] Install everything you need for gaming on an AMD Linux computer (including wine and steam)"
    echo "[O] Install 'other' packages that fall outside the specific options"
    echo "[P] Install printer packages for printing and scanning"
    echo "[S] Install sway and all its lovely custom configuration"
    echo "[ALL] Install all packages supplied with this repo"
    echo "[F] Forward (skip this step)"
    echo "[Q] Quit"

    read choice
    [ -n "$choice" ] || choice=ALL
    installOptions
}

installOptions() {
    case "$choice" in 
        "A" | "a") setPackages audio;;
        "C" | "c") ;;
        "G" | "g") setPackages gaming;;
        "O" | "o") setPackages packages;;
        "P" | "p") setPackages printing;;
        "S" | "s") setPackages sway;;
        "Q" | "q") exit;;
        "F" | "f") ;;
        *) setPackages audio sway gaming copying printing virtualization packages
    esac

    installPackages
}

while [ "$choice" != "F" ] && [ "$choice" != "f" ]; do
    displayMenuOptions
done

echo "Create standard home folder directories? [y/N]"
read newDirs

[ "$newDirs" = "y" ] || [ "$newDirs" = "Y" ] && mkdir ~/Documents ~/Downloads ~/Videos ~/Music ~/Pictures

echo "Copy over config files? [Y/n]"
read copy
[ -n $copy ] || copy=Y

case $copy in "Y" | "y")
    [ -d "~/.config" ] && cp -r ~/.config ~/.config.bak
    cp -r $PWD/.config ~/ &&
    cp -r $PWD/.scripts ~/ ;;
esac

echo "Setup chromium prefs file? [y/N]"
read chromium
[ -n $chromium ] || chromium="N"
case $chromium in "Y" | "y")
    [ -d "~/.config/chromium" ] || mkdir ~/.config/chromium 
    [ -d "~/.config/chromium/Default" ] || mkdir ~/.config/chromium/Default
    cp $PWD/.config/chromium/Prefs ~/.config/chromium/Default/ ;;
esac

# setup cursor theme
echo "Setup cursor theme(s)? [y/N]"
read cursor_setup

[ -n $cursor_setup ] || cursor_setup="N"

case $cursor_setup in "Y" | "y")
    [ ! -d "~/.icons" ] || mkdir ~/.icons
    [ ! -d "~/.icons/default" ] || mkdir ~/.icons/default
    echo "[Icon Theme]" > ~/.icons/default/index.theme
    echo "Name=Default" >> ~/.icons/default/index.theme
    echo "Comment=Default Cursor Theme" >> ~/.icons/default/index.theme

    echo "Which cursor theme to install? [P]"
    read cursor_theme

    [ -n "$cursor_theme" ] || cursor_theme=P

    case $cursor_theme in "p" | "P")
        tar xf cursor_themes/PearDarkCursors.tar.gz &&

        [ ! -d "~/.local" ] || mkdir ~/.local 
        [ ! -d "~/.local/share" ] || mkdir ~/.local/share 
        [ ! -d "~/.local/share/icons" ] || mkdir ~/.local/share/icons
        cp -r PearDarkCursors ~/.local/share/icons/ 
        echo "Inherits=PearDarkCursors" >> ~/.icons/default/index.theme

        rm -r PearDarkCursors
        ;;
    esac
    ;;
esac