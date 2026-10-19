#!/bin/bash
# Restore only portable VS Code preferences and missing extensions.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DRY_RUN=0
EXTENSIONS_ONLY=0
SETTINGS_ONLY=0
for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=1 ;;
        --extensions-only) EXTENSIONS_ONLY=1 ;;
        --settings-only) SETTINGS_ONLY=1 ;;
        *) printf 'Usage: bash setup/vscode.sh [--dry-run] [--extensions-only|--settings-only]\n' >&2; exit 2 ;;
    esac
done
if [ "$EXTENSIONS_ONLY" -eq 1 ] && [ "$SETTINGS_ONLY" -eq 1 ]; then
    printf 'Choose extensions-only or settings-only, not both.\n' >&2
    exit 2
fi
if [ "$EXTENSIONS_ONLY" -eq 0 ]; then
    command -v python3 >/dev/null 2>&1 || { printf 'Python 3 is required to restore VS Code settings.\n' >&2; exit 1; }
    args=(--phase vscode --non-interactive)
    [ "$DRY_RUN" -eq 0 ] || args+=(--dry-run)
    python3 -B "$ROOT/setup/configure.py" "${args[@]}"
fi
[ "$SETTINGS_ONLY" -eq 0 ] || exit 0

code_bin="${DOTFILES_VSCODE_CLI:-/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code}"
if [ -z "${DOTFILES_VSCODE_CLI:-}" ] && [ ! -x "$code_bin" ]; then
    code_bin="$HOME/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
fi
installed=""
if [ "$DRY_RUN" -eq 0 ]; then
    [ -x "$code_bin" ] || { printf 'VS Code CLI not found. Install Visual Studio Code first.\n' >&2; exit 1; }
    installed="$("$code_bin" --list-extensions)"
fi
newline=$'\n'
shopt -s nocasematch
failures=0
while IFS= read -r extension || [ -n "$extension" ]; do
    case "$extension" in ''|\#*) continue ;; esac
    case "$newline$installed$newline" in
        *"$newline$extension$newline"*)
            printf 'Skipping extension %s: already installed; not upgrading.\n' "$extension"
            continue
            ;;
    esac
    if [ "$DRY_RUN" -eq 1 ]; then
        printf '[dry-run] Install VS Code extension: %s\n' "$extension"
    else
        printf '\nInstalling VS Code extension: %s\n' "$extension"
        if ! "$code_bin" --install-extension "$extension"; then
            printf 'Failed to install extension: %s\n' "$extension" >&2
            failures=1
        fi
    fi
done < "$ROOT/vscode/extensions.txt"
if [ "$failures" -ne 0 ]; then
    printf 'Some extensions failed; rerun ./install.sh --vscode-only to retry missing ones.\n' >&2
    exit 1
fi
printf '\nVS Code setup complete. Reload its window to activate themes/extensions; sign in where required.\n'
