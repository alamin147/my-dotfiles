#!/usr/bin/env bash
# Dependencies: wf-recorder slurp pactl
# sudo dnf install wf-recorder slurp pipewire-utils

DIR="$HOME/Videos"
mkdir -p "$DIR"

PID_FILE="/tmp/wf-recorder.pid"
MODULES_FILE="/tmp/wf-recorder-modules.tmp"

# ============================================================
# SETTINGS — edit these to change defaults
# ============================================================

# Quality preset: high | ultra | lossless
#   high     — CRF 18, fast encode  (recommended)
#   ultra    — CRF 15, slow encode  (smaller file, best quality)
#   lossless — CRF 0,  lossless     (huge file, saves as .mkv)
QUALITY="high"

# Framerate
FPS=60

# Audio mode: none | desktop | mic | both
#   none     — no audio
#   desktop  — capture what's playing (speaker loopback)
#   mic      — capture microphone
#   both     — desktop + mic mixed via virtual PipeWire sink
AUDIO_MODE="desktop"

# ============================================================

# ---------- Notification ----------
notify() {
    local title="$1" msg="$2"
    if command -v dms >/dev/null 2>&1; then
        dms notify "$title" "$msg"
    else
        notify-send "$title" "$msg"
    fi
}

# ---------- Quality ----------
quality_flags() {
    case "$QUALITY" in
        ultra)    echo "-c libx264 -p crf=15 -p preset=fast" ;;
        lossless) echo "-c libx264rgb -p crf=0" ;;
        high|*)   echo "-c libx264 -p crf=18 -p preset=ultrafast" ;;
    esac
}

file_ext() {
    case "$QUALITY" in
        lossless) echo "mkv" ;;
        *)        echo "mp4" ;;
    esac
}

# ---------- Audio ----------
setup_combined_audio() {
    local sink_id loop_mic loop_desk
    sink_id=$(pactl load-module module-null-sink \
        sink_name=wf_combined \
        sink_properties=device.description=ScreenRecordMix)
    loop_mic=$(pactl load-module module-loopback \
        source="$(pactl get-default-source)" \
        sink=wf_combined latency_msec=1)
    loop_desk=$(pactl load-module module-loopback \
        source="$(pactl get-default-sink).monitor" \
        sink=wf_combined latency_msec=1)
    echo "$sink_id $loop_mic $loop_desk" > "$MODULES_FILE"
    echo "-awf_combined.monitor"
}

cleanup_combined_audio() {
    [ -f "$MODULES_FILE" ] || return
    read -r sid lm ld < "$MODULES_FILE"
    pactl unload-module "$ld"  2>/dev/null
    pactl unload-module "$lm"  2>/dev/null
    pactl unload-module "$sid" 2>/dev/null
    rm -f "$MODULES_FILE"
}

desktop_monitor() {
    local sink monitor
    sink=$(pactl get-default-sink 2>/dev/null)
    monitor="${sink}.monitor"
    # verify it exists, otherwise fall back to first available monitor source
    if ! pactl list sources short 2>/dev/null | awk '{print $2}' | grep -qxF "$monitor"; then
        monitor=$(pactl list sources short 2>/dev/null | awk '/\.monitor/{print $2; exit}')
    fi
    echo "$monitor"
}

audio_flags() {
    case "$AUDIO_MODE" in
        desktop) echo "-a$(desktop_monitor)" ;;
        mic)     echo "-a$(pactl get-default-source 2>/dev/null)" ;;
        both)    setup_combined_audio ;;
        none|*)  echo "" ;;
    esac
}

# ---------- State ----------
is_recording() {
    [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null
}

stop_record() {
    if is_recording; then
        kill -INT "$(cat "$PID_FILE")" 2>/dev/null
        rm -f "$PID_FILE"
        cleanup_combined_audio
        notify "Recording" "Stopped"
    fi
}

# ---------- Fullscreen ----------
start_full() {
    local qflags aflags ext
    qflags=$(quality_flags)
    aflags=$(audio_flags)
    ext=$(file_ext)
    FILE="$DIR/recording_$(date +%F_%H-%M-%S).$ext"

    notify "Recording" "Fullscreen started · ${QUALITY} · audio:${AUDIO_MODE}"

    # shellcheck disable=SC2086
    wf-recorder $qflags $aflags -f "$FILE" >/dev/null 2>&1 &
    echo $! > "$PID_FILE"
}

# ---------- Area ----------
start_area() {
    AREA=$(slurp -b "#00000066" -c "#cba6f7" -w 2)
    [ -z "$AREA" ] && exit 0

    local qflags aflags ext
    qflags=$(quality_flags)
    aflags=$(audio_flags)
    ext=$(file_ext)
    FILE="$DIR/recording_$(date +%F_%H-%M-%S).$ext"

    notify "Recording" "Area started · ${QUALITY} · audio:${AUDIO_MODE}"

    # shellcheck disable=SC2086
    wf-recorder -g "$AREA" $qflags $aflags -f "$FILE" >/dev/null 2>&1 &
    echo $! > "$PID_FILE"
}

# ---------- Main ----------
case "$1" in
    full)
        if is_recording; then stop_record; else start_full; fi ;;
    area)
        if is_recording; then stop_record; else start_area; fi ;;
    stop)
        stop_record ;;
    *)
        echo "Usage: $0 {full|area|stop}" ;;
esac
