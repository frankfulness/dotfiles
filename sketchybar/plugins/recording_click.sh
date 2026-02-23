#!/bin/bash

# Stop screen recording when clicked
# This simulates the macOS menu bar behavior

# Try to stop screen recording via keyboard shortcut
osascript -e 'tell application "System Events" to key code 28 using {shift down, command down}'

# Or try to quit QuickTime Player if it's recording
pkill -f "QuickTime Player"