#!/bin/bash

# Detect microphone usage from various apps

# Check for apps that commonly use microphone
MIC_USAGE=0

# Check for Zoom
if pgrep -f "zoom.us" > /dev/null; then
    MIC_USAGE=1
fi

# Check for Teams  
if pgrep -f "Microsoft Teams" > /dev/null; then
    MIC_USAGE=1
fi

# Check for Discord
if pgrep -f "Discord" > /dev/null; then
    MIC_USAGE=1
fi

# Check for QuickTime recording
if pgrep -f "QuickTime Player" > /dev/null && lsof | grep -q "AppleH13CamIn"; then
    MIC_USAGE=1
fi

# Show/hide mic indicator based on usage
if [ $MIC_USAGE -eq 1 ]; then
    sketchybar --set "$NAME" drawing=on
else
    sketchybar --set "$NAME" drawing=off
fi