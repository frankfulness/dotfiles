#!/bin/bash

# Dato integration with clean 12-hour format
# Simple, clean date and time display

# Get current date and time in 12-hour format  
DAY=$(date '+%-d')
MONTH=$(date '+%B')
YEAR=$(date '+%Y')
TIME=$(date '+%-I:%M %p %Z')

# Add ordinal suffix to day
case $DAY in
  1|21|31) SUFFIX="st";;
  2|22) SUFFIX="nd";;
  3|23) SUFFIX="rd";;
  *) SUFFIX="th";;
esac

# Set clean label with full format
sketchybar --set "$NAME" label="$MONTH ${DAY}${SUFFIX}, $YEAR $TIME"
