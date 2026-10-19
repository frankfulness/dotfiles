#!/bin/bash
# This first step needs no Homebrew, Python, or shell plugins.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DRY_RUN=0
case "${1:-}" in
    --dry-run) DRY_RUN=1 ;;
    "") ;;
    *) printf 'Usage: bash setup/early-shell.sh [--dry-run]\n' >&2; exit 2 ;;
esac
backup=""
copy_config() {
    local source="$1" destination="$HOME/$2"
    if [ -f "$destination" ] && [ ! -L "$destination" ] &&
       cmp -s "$ROOT/$source" "$destination"; then
        printf 'Unchanged: ~/%s\n' "$2"
        return
    fi
    printf 'Copy %s -> ~/%s\n' "$source" "$2"
    [ "$DRY_RUN" -eq 0 ] || return 0
    if [ -e "$destination" ] || [ -L "$destination" ]; then
        if [ -z "$backup" ]; then
            mkdir -p "$HOME/.local/state/dotfiles/backups"
            backup="$(mktemp -d "$HOME/.local/state/dotfiles/backups/early-shell-$(date +%Y%m%d-%H%M%S).XXXXXX")"
            chmod 700 "$backup"
        fi
        mkdir -p "$(dirname "$backup/$2")"
        mv "$destination" "$backup/$2"
    fi
    mkdir -p "$(dirname "$destination")"
    # Keep the new config private and publish it atomically.
    local temporary
    temporary="$(mktemp "$(dirname "$destination")/.dotfiles-shell.XXXXXX")"
    if ! cp "$ROOT/$source" "$temporary"; then
        rm -f "$temporary"
        return 1
    fi
    chmod 600 "$temporary"
    mv "$temporary" "$destination"
}

# Preflight before changing anything.
for source in .zshrc .zprofile starship.toml; do
    [ -f "$ROOT/$source" ] || { printf 'Missing %s\n' "$source" >&2; exit 1; }
done
copy_config .zshrc .zshrc
copy_config .zprofile .zprofile
copy_config starship.toml .config/starship.toml
for relative in 0-index 1-projects 2-areas 3-resources 4-archive \
    4-archive/completed-projects 4-archive/finished-tasks \
    4-archive/inactive-area 4-archive/prior-interest; do
    printf 'Ensure directory: ~/Desktop/PARA/%s\n' "$relative"
    if [ "$DRY_RUN" -eq 0 ]; then mkdir -p "$HOME/Desktop/PARA/$relative"; fi
done
if [ -n "$backup" ]; then printf 'Previous shell files backed up to: %s\n' "$backup"; fi
printf '%s\n' \
    'Shell files and PARA are ready (or previewed in --dry-run mode).' \
    'New Zsh terminals load ~/.zshrc automatically; missing optional tools are guarded.' \
    'This installer cannot change the parent shell: open a new terminal, or run source ~/.zshrc after setup.'
