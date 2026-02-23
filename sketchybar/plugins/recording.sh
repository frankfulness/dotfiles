#!/bin/bash

# Detect screen recording and other system recording states

# Comprehensive screen recording detection
SCREEN_RECORDING=0

# Check system processes for screen recording
if ps aux | grep -E "[S]creenCaptureKit|[C]GDisplayStream|screencapture" | grep -v grep > /dev/null; then
    SCREEN_RECORDING=1
fi

# Check for QuickTime Player recording
if ps aux | grep "[Q]uickTime Player" | grep -v grep > /dev/null; then
    SCREEN_RECORDING=1
fi

# Check for common recording applications
if ps aux | grep -E "[O]BS|[C]amtasia|[S]creenSearch|[K]ap|[C]leanShot" | grep -v grep > /dev/null; then
    SCREEN_RECORDING=1
fi

# Check system recording state (macOS 12+)
if pgrep -f "com.apple.controlcenter" > /dev/null && lsof | grep -q "ScreenCaptureKit"; then
    SCREEN_RECORDING=1
fi

# Alternative detection method
if system_profiler SPDisplaysDataType | grep -q "Resolution.*Recording"; then
    SCREEN_RECORDING=1
fi

# Show/hide recording indicator
if [ $SCREEN_RECORDING -eq 1 ]; then
    sketchybar --set "$NAME" drawing=on
else
    sketchybar --set "$NAME" drawing=off
fi
