#!/bin/bash

# Enhanced clock script with better date formatting

DATE=$(date '+%a %b %d')
TIME=$(date '+%H:%M')

sketchybar --set "$NAME" icon="$(date '+%d')" label="$DATE  $TIME"

