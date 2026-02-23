#!/bin/bash

# Volume scroll script - allows changing volume with mouse scroll

VOLUME_STEP=5

case "$SCROLL_DIRECTION" in
  "up")
    osascript -e "set volume output volume (output volume of (get volume settings) + $VOLUME_STEP)"
    ;;
  "down") 
    osascript -e "set volume output volume (output volume of (get volume settings) - $VOLUME_STEP)"
    ;;
esac

# Trigger volume update
sketchybar --trigger volume_change