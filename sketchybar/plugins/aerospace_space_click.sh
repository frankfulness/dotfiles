#!/bin/bash

# Handle left/right click on aerospace spaces
# Left click: focus workspace
# Right click: destroy workspace (if using yabai with SIP disabled)

WORKSPACE_NUMBER=$(echo "$NAME" | grep -o '[0-9]\+$')

case "$BUTTON" in
    "left") 
        aerospace workspace "$WORKSPACE_NUMBER"
        ;;
    "right") 
        # Destroy space (requires yabai with SIP disabled)
        # For aerospace, we'll just move all windows from this space to space 1 and focus space 1
        aerospace list-windows --workspace "$WORKSPACE_NUMBER" --format '%{window-id}' | while read -r window_id; do
            if [ -n "$window_id" ]; then
                aerospace move-node-to-workspace --window-id "$window_id" 1
            fi
        done
        aerospace workspace 1
        ;;
esac