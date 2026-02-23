#!/bin/bash

# Check Bluetooth status
BT_STATUS=$(system_profiler SPBluetoothDataType 2>/dev/null | grep "Bluetooth Power" | awk '{print $3}')

if [ "$BT_STATUS" = "On" ]; then
    # Check if any devices are connected
    CONNECTED=$(system_profiler SPBluetoothDataType 2>/dev/null | grep "Connected: Yes" | wc -l)
    if [ $CONNECTED -gt 0 ]; then
        sketchybar --set "$NAME" icon="󰂯" icon.color=0xfffacc15
    else
        sketchybar --set "$NAME" icon="󰂲" icon.color=0xffffffff
    fi
else
    sketchybar --set "$NAME" icon="󰂲" icon.color=0xff6272a4
fi