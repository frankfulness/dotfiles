#!/bin/bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

volume=(
  script="$PLUGIN_DIR/volume.sh"
  icon.color=0xffffffff
  icon.font="0xProto Nerd Font Mono:Bold:18.0"
  label.color=0xffffffff
  label.font="0xProto Nerd Font Mono:Bold:15.0"
  click_script="open -a 'Audio MIDI Setup'"
  scroll_script="$PLUGIN_DIR/volume_scroll.sh"
)

sketchybar --add item volume right \
           --set volume "${volume[@]}" \
           --subscribe volume volume_change mouse.scrolled
