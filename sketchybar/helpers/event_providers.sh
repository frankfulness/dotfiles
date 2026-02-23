#!/bin/bash

aerospace_workspace_change() {
  source "$CONFIG_DIR/colors.sh"
  CURRENT_WORKSPACE=$(aerospace list-workspaces --focused)
  
  args=()
  while read -r line
  do
    if [[ $line =~ (aerospace\.workspace\.[0-9]+) ]]; then
      WORKSPACE_NUMBER=${line##*.}
      if [ "$WORKSPACE_NUMBER" = "$CURRENT_WORKSPACE" ]; then
        args+=(--set "${line}" icon.highlight=on)
      else
        args+=(--set "${line}" icon.highlight=off)
      fi
    fi
  done <<< "$(sketchybar --query bar | jq -r '.items[]')"
  
  [ ${#args[@]} -gt 0 ] && sketchybar "${args[@]}"
}

case "$SENDER" in
  "aerospace_workspace_change") aerospace_workspace_change
  ;;
esac