#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Dato integration for proper date/time display
dato=(
  icon.drawing=off
  label.font="0xProto Nerd Font Mono:Bold:15.0"
  label.color=$GREEN
  label.padding_left=10
  label.padding_right=0
  padding_left=20
  padding_right=0
  update_freq=30
  script="$PLUGIN_DIR/dato.sh"
  click_script="open -a Dato"
)

sketchybar --add item dato right       \
           --set dato "${dato[@]}" \
           --subscribe dato system_woke
