#!/bin/bash

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$CONFIG_DIR/icons.sh"

# Check overall internet connection status
INTERNET_CONNECTED=0

# First check if we can reach the internet
if ping -c 1 8.8.8.8 >/dev/null 2>&1; then
    INTERNET_CONNECTED=1
fi

if [ $INTERNET_CONNECTED -eq 1 ]; then
    # Check if WiFi is on and connected
    WIFI_STATUS=$(networksetup -getairportpower en0 2>/dev/null | awk '{print $4}')
    SSID=$(networksetup -getairportnetwork en0 2>/dev/null | cut -d' ' -f4-)
    
    if [ "$WIFI_STATUS" = "On" ] && [ "$SSID" != "You are not associated with an AirPort network." ] && [ "$SSID" != "" ]; then
        # Connected via WiFi
        sketchybar --set "$NAME" icon="📶" label="$SSID"
    else
        # Connected via Ethernet or other means
        sketchybar --set "$NAME" icon="📶" label="Ethernet"
    fi
else
    # No internet connection at all
    sketchybar --set "$NAME" icon="🚫" label="No Internet"
fi
