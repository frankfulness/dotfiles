#!/bin/bash

source "$CONFIG_DIR/colors.sh"

sketchybar --add item clock right \
           --set clock update_freq=10 \
           --set clock icon=󰃰 \
           --set clock icon.color=$ICON_COLOR \
           --set clock label.color=$LABEL_COLOR \
           --set clock script="$PLUGIN_DIR/clock.sh" \
           --set clock click_script="$PLUGIN_DIR/zen.sh"