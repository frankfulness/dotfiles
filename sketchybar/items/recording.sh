#!/bin/bash

source "$CONFIG_DIR/colors.sh"

recording=(
  script="$PLUGIN_DIR/recording.sh"
  icon=""
  icon.font="0xProto Nerd Font Mono:Bold:12.0"
  icon.color=$RED
  label.drawing=off
  drawing=off
  update_freq=2
  click_script="$PLUGIN_DIR/recording_click.sh"
)

sketchybar --add item recording right \
           --set recording "${recording[@]}"