#!/bin/bash

# Check Focus/Do Not Disturb status
# This is a simplified version - macOS Focus status is complex to detect

# Try to detect if Focus is active
FOCUS_ACTIVE=0

# Check if Do Not Disturb is enabled (basic detection)
if plutil -extract dnd_prefs xml1 -o - ~/Library/Preferences/com.apple.ncprefs.plist 2>/dev/null | grep -q "userPref.*1"; then
    FOCUS_ACTIVE=1
fi

if [ $FOCUS_ACTIVE -eq 1 ]; then
    sketchybar --set "$NAME" icon="󰂞" icon.color=0xfffacc15
else
    sketchybar --set "$NAME" icon="󰂞" icon.color=0xff6272a4
fi