#!/usr/bin/env bash

set -euo pipefail

case "${1:---get}" in
  --get)          dms ipc call audio status ;;
  --inc)          dms ipc call audio increment 5 ;;
  --inc-precise)  dms ipc call audio increment 1 ;;
  --dec)          dms ipc call audio decrement 5 ;;
  --dec-precise)  dms ipc call audio decrement 1 ;;
  --toggle)       dms ipc call audio mute ;;
  --toggle-mic)   dms ipc call audio micmute ;;
  --mic-inc)      dms ipc call mic increment 5 ;;
  --mic-dec)      dms ipc call mic decrement 5 ;;
  --get-icon)     printf '%s\n' 'audio-volume-high-symbolic' ;;
  --get-mic-icon) printf '%s\n' 'microphone-sensitivity-high-symbolic' ;;
  *)
    printf 'Usage: %s [--get|--inc|--inc-precise|--dec|--dec-precise|--toggle|--toggle-mic|--mic-inc|--mic-dec]\n' "$0" >&2
    exit 2
    ;;
esac
