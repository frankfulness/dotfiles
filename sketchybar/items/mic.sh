#!/bin/bash

source "$CONFIG_DIR/colors.sh"

mic=(
  script="$PLUGIN_DIR/mic.sh"
  icon=""
  icon.font="0xProto Nerd Font Mono:Bold:12.0"
  icon.color=$RED
  label.drawing=off
  drawing=off
  update_freq=2
  click_script="open 'x-apple.systempreferences:com.apple.preference.security'"
)

sketchybar --add item mic right \
           --set mic "${mic[@]}"