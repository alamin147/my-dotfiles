#!/usr/bin/env bash
set -euo pipefail

/bin/bash /home/alamin/.config/matugen/scripts/apply-thorium-theme.sh >/dev/null 2>&1 || true

exec /usr/bin/thorium-browser "$@"
