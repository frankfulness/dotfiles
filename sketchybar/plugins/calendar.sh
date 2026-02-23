#!/bin/bash

# Calendar plugin with proper date formatting

# Get current date components
DAY=$(date '+%d')
MONTH_DAY=$(date '+%a %b %d')
TIME=$(date '+%H:%M')

# Remove leading zero from day for icon
ICON_DAY=$(date '+%-d')

# Format the display
sketchybar --set "$NAME" icon="$ICON_DAY" label="$MONTH_DAY  $TIME"