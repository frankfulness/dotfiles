#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Simple calendar item for far right
simple_calendar=(
  icon="📅"
  icon.font="0xProto Nerd Font Mono:Bold:14.0"
  icon.color=0xffffffff
  label.drawing=off
  click_script="open -a Calendar"
)

sketchybar --add item simple_calendar right \
           --set simple_calendar "${simple_calendar[@]}"