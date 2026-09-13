#!/usr/bin/env bash
# Restart the systemd-managed Hyprland portal stack.

set -euo pipefail

systemctl --user restart xdg-desktop-portal-hyprland.service
systemctl --user restart xdg-desktop-portal.service
