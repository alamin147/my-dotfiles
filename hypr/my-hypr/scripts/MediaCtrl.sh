#!/usr/bin/env bash

set -euo pipefail

case "${1:-}" in
  --nxt)   dms ipc call mpris next ;;
  --prv)   dms ipc call mpris previous ;;
  --pause) dms ipc call mpris playPause ;;
  --stop)  dms ipc call mpris stop ;;
  *)
    printf 'Usage: %s [--nxt|--prv|--pause|--stop]\n' "$0" >&2
    exit 2
    ;;
esac
