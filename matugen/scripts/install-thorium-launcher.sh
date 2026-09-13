#!/usr/bin/env bash
set -euo pipefail

app_dir="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
wrapper="/home/alamin/.config/matugen/scripts/launch-thorium-matugen.sh"

# Keep the policy directory writable by this user without making it
# world-writable. The hook then updates the policy without sudo on each theme
# change.
for policy_dir in /etc/chromium/policies/managed /etc/thorium/policies/managed; do
  sudo mkdir -p "$policy_dir"
  sudo chown "$(id -un):$(id -gn)" "$policy_dir"
  sudo chmod 755 "$policy_dir"
done

install_entry() {
  local source_file="$1"
  local target_file="$2"

  cp "$source_file" "$target_file"
  sed -i "s|^Exec=/usr/bin/thorium-browser\\(.*\\)$|Exec=$wrapper\\1|" "$target_file"
}

mkdir -p "$app_dir"
install_entry "/usr/share/applications/thorium-browser.desktop" "$app_dir/thorium-browser.desktop"

if [[ -f "/usr/share/applications/org.chromium.Thorium.desktop" ]]; then
  install_entry "/usr/share/applications/org.chromium.Thorium.desktop" "$app_dir/org.chromium.Thorium.desktop"
fi
