#
# ~/.bashrc
#

#colorscript random

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias yt-dl-mp3='youtube-dl --extract-audio --embed-thumbnail --audio-quality 0 --audio-format mp3'
alias yt-dl-flac='youtube-dl --extract-audio --audio-quality 0 --audio-format flac --write-thumbnail'
alias stresscpu='openssl speed -multi $(nproc --all)'
alias playmusic='cd ~/ && mp3blaster --playmode="allrandom" -a Music/favourites.m3u'
alias update='yay -Syyu | tee ~/.updates/$(date +"%H:%M|%d-%m-%Y").log'
alias updates='yay -Qu | wc -l'
alias ssh='TERM="xterm-256color" ssh'
alias udmount='udisksctl mount -b'
alias udunmount='udisksctl unmount -b'
alias handbrake='ghb'
alias screenshot='scrot -so "/tmp/screenshot.png" && cat /tmp/screenshot.png | xclip -selection clipboard -target image/png -i'
alias fooleac='sh ~/Downloads/SC_EAC_workaround/SC_EAC_workaround.sh'
PS1='[\u@\h \W]\$ '

export VISUAL="vim"
export EDITOR="vim"


PATH=${PATH}:/opt/linuxtrack/bin

complete -C "/usr/bin/symfony self:autocomplete" symfony
. "$HOME/.cargo/env"

if [[ "$(tty)" = "/dev/tty2" || "$(tty)" = "/dev/tty1" ]]; then
	cp ~/.config/chromium/Default/Prefs ~/.config/chromium/Default/Preferences &&
	startx ~/.xinitrc;
elif [[ "$(tty)" = "/dev/tty3" ]]; then
	startx ~/.xinitrc
else
    neofetch
fi
