#!/bin/bash

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$CONFIG_DIR/colors.sh"

# ─── Fast path: workspace switch (color-only update) ─────────────────────────
# When called from exec-on-workspace-change, FOCUSED_WORKSPACE and
# PREV_WORKSPACE are passed as env vars. We can swap highlight colors
# with ZERO aerospace CLI calls — just one sketchybar call (~10ms).
if [ -n "$FOCUSED_WORKSPACE" ] && [ -n "$PREV_WORKSPACE" ] \
   && [ "$FOCUSED_WORKSPACE" != "$PREV_WORKSPACE" ]; then
  sketchybar --animate sin 8 \
    --set aerospace.workspace.$PREV_WORKSPACE \
      background.color=$BACKGROUND_2 \
      icon.color=$WHITE \
      label.color=$WHITE \
    --set aerospace.workspace.$FOCUSED_WORKSPACE \
      background.color=$GREEN \
      icon.color=$BLACK \
      label.color=$BLACK
fi

# ─── Full path: initial load / icon refresh ──────────────────────────────────
# Only source the 986-line icon map when we actually need it.
source "$CONFIG_DIR/helpers/icon_map.sh"

# Use env var if available, otherwise query (1 call)
CURRENT_WORKSPACE="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}" || exit
[ -z "$CURRENT_WORKSPACE" ] && exit

# ONE aerospace call gets every window across all workspaces
ALL_WINDOWS=$(aerospace list-windows --all --format '%{workspace}|%{app-name}' 2>/dev/null)

# Parse into per-workspace app lists — pure bash, no subprocesses
# (bash 3.2 compatible: no associative arrays)
WS_1_APPS="" WS_2_APPS="" WS_3_APPS="" WS_4_APPS="" WS_5_APPS=""
WS_6_APPS="" WS_7_APPS="" WS_8_APPS="" WS_9_APPS=""
WS_1_ACT=0 WS_2_ACT=0 WS_3_ACT=0 WS_4_ACT=0 WS_5_ACT=0
WS_6_ACT=0 WS_7_ACT=0 WS_8_ACT=0 WS_9_ACT=0

while IFS='|' read -r ws app; do
  [ -z "$ws" ] && continue
  case "$ws" in
    1) WS_1_ACT=1; WS_1_APPS="${WS_1_APPS:+${WS_1_APPS}|}$app" ;;
    2) WS_2_ACT=1; WS_2_APPS="${WS_2_APPS:+${WS_2_APPS}|}$app" ;;
    3) WS_3_ACT=1; WS_3_APPS="${WS_3_APPS:+${WS_3_APPS}|}$app" ;;
    4) WS_4_ACT=1; WS_4_APPS="${WS_4_APPS:+${WS_4_APPS}|}$app" ;;
    5) WS_5_ACT=1; WS_5_APPS="${WS_5_APPS:+${WS_5_APPS}|}$app" ;;
    6) WS_6_ACT=1; WS_6_APPS="${WS_6_APPS:+${WS_6_APPS}|}$app" ;;
    7) WS_7_ACT=1; WS_7_APPS="${WS_7_APPS:+${WS_7_APPS}|}$app" ;;
    8) WS_8_ACT=1; WS_8_APPS="${WS_8_APPS:+${WS_8_APPS}|}$app" ;;
    9) WS_9_ACT=1; WS_9_APPS="${WS_9_APPS:+${WS_9_APPS}|}$app" ;;
  esac
done <<< "$ALL_WINDOWS"

# Always show the focused workspace even if empty
case "$CURRENT_WORKSPACE" in
  [1-9]) eval "WS_${CURRENT_WORKSPACE}_ACT=1" ;;
esac

# Build ONE sketchybar call for all 9 workspaces
args=(--animate sin 8)

for i in {1..9}; do
  eval "IS_ACTIVE=\$WS_${i}_ACT"

  if [ "$IS_ACTIVE" = "1" ]; then
    eval "APPS_STR=\$WS_${i}_APPS"

    # Build icon strip (up to 3 app icons)
    ICON_STRIP=""
    APP_COUNT=0
    OLD_IFS="$IFS"; IFS='|'
    for APP in $APPS_STR; do
      [ -z "$APP" ] && continue
      APP_COUNT=$((APP_COUNT + 1))
      [ $APP_COUNT -gt 3 ] && break
      __icon_map "$APP"
      if [ -n "$icon_result" ] && [ "$icon_result" != ":default:" ]; then
        ICON_STRIP="${ICON_STRIP}${icon_result} "
      fi
    done
    IFS="$OLD_IFS"

    ICON_STRIP="${ICON_STRIP% }"
    [ -z "$ICON_STRIP" ] && ICON_STRIP="$i"

    if [ "$i" = "$CURRENT_WORKSPACE" ]; then
      BG_COLOR=$GREEN; ICON_COLOR=$BLACK; TEXT_COLOR=$BLACK
    else
      BG_COLOR=$BACKGROUND_2; ICON_COLOR=$WHITE; TEXT_COLOR=$WHITE
    fi

    args+=(
      --set aerospace.workspace.$i drawing=on
      --set aerospace.workspace.$i icon="$ICON_STRIP"
      --set aerospace.workspace.$i icon.color="$ICON_COLOR"
      --set aerospace.workspace.$i label="$i"
      --set aerospace.workspace.$i label.color="$TEXT_COLOR"
      --set aerospace.workspace.$i background.color="$BG_COLOR"
    )
  else
    args+=(--set aerospace.workspace.$i drawing=off)
  fi
done

sketchybar "${args[@]}" 2>/dev/null
