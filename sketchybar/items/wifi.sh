#!/bin/bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

wifi=(
  script="$PLUGIN_DIR/wifi.sh"
  icon.color=0xffffffff
  icon.font="0xProto Nerd Font Mono:Bold:18.0"
  label.color=0xffffffff
  label.font="0xProto Nerd Font Mono:Bold:15.0"
  click_script="open 'x-apple.systempreferences:com.apple.Network-Settings.extension'"
  update_freq=10
)

sketchybar --add item wifi right \
           --set wifi "${wifi[@]}"