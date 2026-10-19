#!/bin/bash
# Re-run after granting permissions; does not install or copy configuration.
set -euo pipefail
DRY_RUN=0
case "${1:-}" in
    --dry-run) DRY_RUN=1 ;;
    "") ;;
    *) printf 'Usage: bash setup/start-desktop.sh [--dry-run]\n' >&2; exit 2 ;;
esac
[ "$(uname -s)" = Darwin ] || { printf 'macOS only.\n' >&2; exit 1; }
[ "$(id -u)" -ne 0 ] || { printf 'Run as your normal user, not sudo.\n' >&2; exit 1; }
export PATH="$HOME/.local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/local/sbin:$PATH"

run() {
    printf '+'
    printf ' %q' "$@"
    printf '\n'
    if [ "$DRY_RUN" -eq 0 ]; then "$@"; fi
}

if [ "$DRY_RUN" -eq 0 ]; then
    for tool in brew sketchybar borders; do
        command -v "$tool" >/dev/null 2>&1 || {
            printf 'Missing %s. Run ./install.sh --desktop-only first.\n' "$tool" >&2
            exit 1
        }
    done
fi

ready=0
if [ "$DRY_RUN" -eq 0 ] && command -v aerospace >/dev/null 2>&1 &&
   aerospace list-workspaces --focused >/dev/null 2>&1; then
    run aerospace reload-config
    ready=1
else
    run open -a AeroSpace
    if [ "$DRY_RUN" -eq 0 ] && command -v aerospace >/dev/null 2>&1; then
        for attempt in 1 2 3 4 5; do
            if aerospace list-workspaces --focused >/dev/null 2>&1; then
                ready=1
                break
            fi
            sleep 1
        done
    fi
fi

# Homebrew services run as this user and register for the user's next login.
run brew services restart felixkratz/formulae/borders
run brew services restart felixkratz/formulae/sketchybar
if [ "$DRY_RUN" -eq 0 ] && [ "$ready" -eq 1 ]; then
    # Allow launchd to finish starting the bar before its initial refresh.
    for attempt in 1 2 3 4 5; do
        if sketchybar --query bar >/dev/null 2>&1; then
            run sketchybar --trigger aerospace_workspace_change
            break
        fi
        sleep 1
    done
fi
if [ "$DRY_RUN" -eq 0 ] && ! command -v aerospace >/dev/null 2>&1; then
    printf '%s\n' \
        'AeroSpace app is present but its companion CLI is missing.' \
        'Install the aerospace CLI from the official AeroSpace release into ~/.local/bin.' \
        'The existing app was not replaced or adopted.'
fi
if [ "$DRY_RUN" -eq 0 ] && [ "$ready" -eq 0 ]; then
    printf '%s\n' \
        'AeroSpace is not responding yet. Complete its first-run/Accessibility prompts.' \
        'Then rerun: bash setup/start-desktop.sh'
fi
printf '%s\n' \
    'macOS permissions cannot be granted automatically:' \
    '- Allow AeroSpace in System Settings > Privacy & Security > Accessibility.' \
    '- Approve any Automation/Screen Recording prompts for bar features as needed.' \
    '- Set the macOS menu bar to automatically hide if you want only SketchyBar visible.' \
    '- Enable requested login items; AeroSpace config enables start-at-login.' \
    'No system services or macOS security protections were disabled.'
