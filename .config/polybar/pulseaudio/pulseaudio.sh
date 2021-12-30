#!/bin/sh

status() {
    muted=$(pactl get-${device}-mute @DEFAULT_${DEVICE}@ | awk '{print $2}')
    [[ "$1" = "--muted" && "$muted" = "yes" ]] || [[ "$1" != "--muted" && "$muted" = "no" ]] && pactl get-${device}-volume @DEFAULT_${DEVICE}@ | awk '{print $5}' || echo ""
}

listen() {
    # status $1

    LANG=EN; pactl subscribe | while read -r event; do
        if echo "$event" | grep -q "sink" || echo "$event" | grep -q "client"; then
            status $1
        fi
    done
}

toggle() {
  pactl set-${device}-mute @DEFAULT_${DEVICE}@ toggle
}

change() {
    pactl set-${device}-volume @DEFAULT_${DEVICE}@ ${1}1%
}

device="$(echo $2 | tr [:upper:] [:lower:])"
DEVICE="$(echo $2 | tr [:lower:] [:upper:])"

case "$1" in
    --toggle)
        toggle
        ;;
    --increase)
        change +
        ;;
    --decrease)
        decrease
        ;;
    --muted|--not-muted)
        listen $1
        ;;
esac
