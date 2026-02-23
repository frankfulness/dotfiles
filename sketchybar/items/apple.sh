#!/bin/bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

POPUP_OFF="sketchybar --set apple.icon popup.drawing=off"
POPUP_CLICK_SCRIPT="sketchybar --set \$NAME popup.drawing=toggle"

# Apple icon (far left) - opens popup menu on click
apple_icon=(
  icon=""
  icon.drawing=on
  icon.font="SF Pro:Black:28.0"
  icon.color=$YELLOW
  label.drawing=off
  background.drawing=off
  padding_right=4
  padding_left=10
  click_script="$POPUP_CLICK_SCRIPT"
)

apple_logo=(
  icon.drawing=off
  label.drawing=off
  padding_right=0
  padding_left=0
  width=0
)

apple_prefs=(
  icon="⚙️"
  label="System Preferences"
  click_script="open 'x-apple.systempreferences:'; $POPUP_OFF"
)

apple_activity=(
  icon="📊"
  label="Activity Monitor"
  click_script="open -a 'Activity Monitor'; $POPUP_OFF"
)

apple_lock=(
  icon="🔒"
  label="Lock Screen"
  click_script="open -a ScreenSaverEngine; $POPUP_OFF"
)

# Add apple icon first (far left)
sketchybar --add item apple.icon left                  \
           --set apple.icon "${apple_icon[@]}"

sketchybar --add item apple.logo left                  \
           --set apple.logo "${apple_logo[@]}"         \
                                                       \
           --add item apple.prefs popup.apple.icon     \
           --set apple.prefs "${apple_prefs[@]}"       \
                                                       \
           --add item apple.activity popup.apple.icon  \
           --set apple.activity "${apple_activity[@]}" \
                                                       \
           --add item apple.lock popup.apple.icon      \
           --set apple.lock "${apple_lock[@]}"
