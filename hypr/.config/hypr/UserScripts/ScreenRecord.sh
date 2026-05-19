#!/usr/bin/env bash

# this is for quick recording. For high quality and with sound use obs 
DIR="$HOME/Videos"
mkdir -p "$DIR"

is_recording() {
    pgrep -x wf-recorder >/dev/null
}

stop_record() {
    pkill -INT wf-recorder
    notify-send "Recording Stopped"
}

start_full() {
    FILE="$DIR/recording_$(date +%F_%H-%M-%S).mp4"
    notify-send "Recording started"
    wf-recorder -f "$FILE"
    notify-send "Recording" "Saved: $(basename "$FILE")"
}

start_area() {
    AREA=$(slurp)
    [ -z "$AREA" ] && exit 0

    FILE="$DIR/recording_$(date +%F_%H-%M-%S).mp4"
    notify-send "Recording started"
    wf-recorder -g "$AREA" -f "$FILE"
    notify-send "Recording" "Saved: $(basename "$FILE")"
}

case "$1" in
    full)
        if is_recording; then
            stop_record
        else
            start_full
        fi
        ;;
    area)
        if is_recording; then
            stop_record
        else
            start_area
        fi
        ;;
esac
