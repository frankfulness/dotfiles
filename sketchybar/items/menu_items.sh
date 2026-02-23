#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Control Center style menu items
# These will be positioned to the right of the workspaces

# Bluetooth
bluetooth=(
  script="$PLUGIN_DIR/bluetooth.sh"
  icon="󰂯"
  icon.font="0xProto Nerd Font Mono:Bold:18.0"
  icon.color=0xffffffff
  label.drawing=off
  update_freq=10
  click_script="open 'x-apple.systempreferences:com.apple.BluetoothSettings'"
)

# AirDrop
airdrop=(
  icon="󰀦"
  icon.font="0xProto Nerd Font Mono:Bold:18.0"
  icon.color=0xffffffff
  label.drawing=off
  click_script="open 'x-apple.systempreferences:com.apple.AirDrop-Handoff-Settings'"
)

# Focus/Do Not Disturb
focus=(
  script="$PLUGIN_DIR/focus.sh"
  icon="󰂞"
  icon.font="0xProto Nerd Font Mono:Bold:18.0"
  icon.color=0xffffffff
  label.drawing=off
  update_freq=30
  click_script="shortcuts run 'Toggle Focus'"
)

sketchybar --add item bluetooth right \
           --set bluetooth "${bluetooth[@]}" \
           \
           --add item airdrop right \
           --set airdrop "${airdrop[@]}" \
           \
           --add item focus right \
           --set focus "${focus[@]}"