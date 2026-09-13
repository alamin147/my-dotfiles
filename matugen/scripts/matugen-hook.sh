#!/bin/bash

HOOK_NAME="$1"
HOOK_VALUE="$2"

# Only run on successful matugen completion
if [[ "$HOOK_NAME" == "onMatugenCompleted" && "$HOOK_VALUE" == *"success"* ]]; then

    # Papirus folder icons
    /bin/bash /home/alamin/.config/matugen/papirus-folders/change-icons.sh

    # Spicetify
    /bin/bash /home/alamin/.config/matugen/scripts/apply-spicetify-theme.sh

    # Thorium
    /bin/bash /home/alamin/.config/matugen/scripts/apply-thorium-theme.sh

fi
