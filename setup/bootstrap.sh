#!/bin/bash
# Compatible with the Bash 3.2 shipped with macOS.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DRY_RUN=0
CONFIG_ONLY=0
APP_STORE=0
INTERACTIVE=1
EXTENSIONS=1
DESKTOP=0
DESKTOP_ONLY=0
START_DESKTOP=1
KEEP_MENU_BAR=0

usage() {
    printf '%s\n' "Usage: ./install.sh [options]" \
        "  --dry-run          Preview without downloads or filesystem changes" \
        "  --config-only      Deploy configs and PARA; skip installing software" \
        "  --app-store        Also restore the three purchased App Store apps" \
        "  --non-interactive  Skip Git identity prompts" \
        "  --skip-extensions  Skip VS Code extension installation" \
        "  --desktop          Also install/configure AeroSpace, SketchyBar, and JankyBorders" \
        "  --desktop-only     Set up shell, desktop, and configs; skip the main GUI app bundle" \
        "  --no-start         Copy desktop configs without starting desktop services" \
        "  --keep-menu-bar    Do not change macOS menu-bar auto-hide during desktop startup" \
        "  --help             Show this help"
}
for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=1 ;;
        --config-only) CONFIG_ONLY=1 ;;
        --app-store) APP_STORE=1 ;;
        --non-interactive) INTERACTIVE=0 ;;
        --skip-extensions) EXTENSIONS=0 ;;
        --desktop) DESKTOP=1 ;;
        --desktop-only) DESKTOP=1; DESKTOP_ONLY=1; EXTENSIONS=0 ;;
        --no-start) START_DESKTOP=0 ;;
        --keep-menu-bar) KEEP_MENU_BAR=1 ;;
        --help|-h) usage; exit 0 ;;
        *) printf 'Unknown option: %s\n' "$arg" >&2; usage >&2; exit 2 ;;
    esac
done
[ "$(uname -s)" = Darwin ] || { printf 'macOS only.\n' >&2; exit 1; }
[ "$(id -u)" -ne 0 ] || { printf 'Run as your normal user, not sudo.\n' >&2; exit 1; }

install_desktop_dependencies() {
    run brew tap felixkratz/formulae
    run brew tap nikitabobko/tap
    if [ "$DRY_RUN" -eq 1 ] || brew help trust >/dev/null 2>&1; then
        printf 'Trusting only the exact upstream desktop packages, not entire taps.\n'
        run brew trust --formula felixkratz/formulae/sketchybar
        run brew trust --formula felixkratz/formulae/borders
        if [ ! -e /Applications/AeroSpace.app ] && [ ! -L /Applications/AeroSpace.app ] &&
           [ ! -e "$HOME/Applications/AeroSpace.app" ] && [ ! -L "$HOME/Applications/AeroSpace.app" ]; then
            run brew trust --cask nikitabobko/tap/aerospace
        fi
    else
        printf 'This Homebrew version has no trust command; using its normal install behavior.\n'
    fi
    run brew bundle install --verbose --no-upgrade --file="$ROOT/setup/Brewfile.desktop"
}

run() {
    if [ "$DRY_RUN" -eq 1 ]; then
        printf '[dry-run]'
        printf ' %q' "$@"
        printf '\n'
    else
        "$@"
    fi
}

printf '\n1. Shell configuration and Desktop PARA (before downloads)\n'
if [ "$DRY_RUN" -eq 1 ]; then
    /bin/bash "$ROOT/setup/early-shell.sh" --dry-run
else
    /bin/bash "$ROOT/setup/early-shell.sh"
fi

if [ "$CONFIG_ONLY" -eq 0 ]; then
    printf '\n2. Apple Command Line Tools and Homebrew\n'
    if [ "$DRY_RUN" -eq 0 ] && ! xcode-select -p >/dev/null 2>&1; then
        xcode-select --install
        printf 'Finish the Apple installer, then rerun ./install.sh.\n'
        exit 1
    fi
    if ! command -v brew >/dev/null 2>&1; then
        for brew_path in /opt/homebrew/bin/brew /usr/local/bin/brew; do
            if [ -x "$brew_path" ]; then
                eval "$("$brew_path" shellenv)"
                break
            fi
        done
    fi
    if ! command -v brew >/dev/null 2>&1; then
        if [ "$DRY_RUN" -eq 1 ]; then
            printf '[dry-run] Install Homebrew using its official installer.\n'
        else
            installer="$(mktemp -t dotfiles-homebrew)"
            trap 'rm -f "$installer"' EXIT
            curl --fail --silent --show-error --location \
                https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh \
                --output "$installer"
            /bin/bash "$installer"
            if [ "$(uname -m)" = arm64 ]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
            else
                eval "$(/usr/local/bin/brew shellenv)"
            fi
        fi
    fi
    printf '\n3. Homebrew shell tools (no GUI apps yet)\n'
    run brew bundle install --verbose --no-upgrade --file="$ROOT/setup/Brewfile.shell"
    printf '\n3b. Oh My Zsh, upstream NVM, and Node LTS\n'
    if [ ! -e "$HOME/.oh-my-zsh" ]; then
        run git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
    fi
    export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
    if [ ! -s "$NVM_DIR/nvm.sh" ]; then
        if [ -d "$NVM_DIR" ] && [ -n "$(ls -A "$NVM_DIR")" ]; then
            printf 'NVM_DIR exists but has no nvm.sh; inspect it before retrying.\n' >&2
            exit 1
        fi
        run git clone --depth=1 --branch v0.40.8 https://github.com/nvm-sh/nvm.git "$NVM_DIR"
    fi
    if [ "$DRY_RUN" -eq 1 ]; then
        printf '[dry-run] Load NVM; install Node LTS and set it as default.\n'
    else
        # NVM is not compatible with nounset in all supported versions.
        set +u
        . "$NVM_DIR/nvm.sh"
        nvm install --lts
        nvm alias default 'lts/*'
        set -u
    fi
fi

configure_args=()
[ "$DRY_RUN" -eq 0 ] || configure_args+=(--dry-run)
[ "$INTERACTIVE" -eq 1 ] || configure_args+=(--non-interactive)
[ "$DESKTOP" -eq 0 ] || configure_args+=(--desktop)
configure_phase() {
    if command -v python3 >/dev/null 2>&1; then
        python3 -B "$ROOT/setup/configure.py" --phase "$1" ${configure_args[@]+"${configure_args[@]}"}
    elif [ "$DRY_RUN" -eq 1 ]; then
        printf '[dry-run] Python 3 from the shell-tool phase will restore %s settings.\n' "$1"
    else
        printf 'Python 3 is required for app configs. Shell files and PARA are already in place.\n' >&2
        exit 1
    fi
}

printf '\n4. Warp customization (before other applications)\n'
configure_phase warp
if [ "$CONFIG_ONLY" -eq 0 ]; then
    run brew bundle install --verbose --no-upgrade --file="$ROOT/setup/Brewfile.warp"
fi

if [ "$DESKTOP" -eq 1 ] && [ "$CONFIG_ONLY" -eq 0 ]; then
    printf '\n5. Desktop dependencies: AeroSpace, SketchyBar, and JankyBorders\n'
    install_desktop_dependencies
fi
if [ "$CONFIG_ONLY" -eq 0 ] && [ "$DESKTOP_ONLY" -eq 0 ]; then
    printf '\n6. Other GUI applications (existing apps are skipped)\n'
    run brew bundle install --verbose --no-upgrade --file="$ROOT/setup/Brewfile.apps"
fi

printf '\n7. Remaining Git, editor, and optional desktop configuration\n'
configure_phase remaining
if [ "$DESKTOP" -eq 1 ] && [ "$CONFIG_ONLY" -eq 0 ] && [ "$START_DESKTOP" -eq 1 ]; then
    printf '\nStart/reload AeroSpace, JankyBorders, and SketchyBar\n'
    startup_args=()
    [ "$DRY_RUN" -eq 0 ] || startup_args+=(--dry-run)
    [ "$KEEP_MENU_BAR" -eq 0 ] || startup_args+=(--keep-menu-bar)
    /bin/bash "$ROOT/setup/start-desktop.sh" ${startup_args[@]+"${startup_args[@]}"}
fi
if [ "$CONFIG_ONLY" -eq 0 ] && [ "$EXTENSIONS" -eq 1 ]; then
    printf '\n8. VS Code extensions\n'
    code_bin="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
    if [ ! -x "$code_bin" ] && [ -x "$HOME/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" ]; then
        code_bin="$HOME/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
    fi
    if [ "$DRY_RUN" -eq 0 ] && [ ! -x "$code_bin" ]; then
        printf 'VS Code CLI not found at %s\n' "$code_bin" >&2
        exit 1
    fi
    while IFS= read -r extension || [ -n "$extension" ]; do
        case "$extension" in ''|\#*) continue ;; esac
        run "$code_bin" --install-extension "$extension"
    done < "$ROOT/vscode/extensions.txt"
fi
if [ "$CONFIG_ONLY" -eq 0 ] && [ "$DESKTOP_ONLY" -eq 0 ] && [ "$APP_STORE" -eq 1 ]; then
    printf '\n9. Purchased App Store apps (sign in to the App Store first)\n'
    run brew bundle install --verbose --no-upgrade --file="$ROOT/setup/Brewfile.app-store"
fi
printf '\nSetup phases complete. Remaining interactive steps:\n'
printf '%s\n' \
    "- Install MOTIV Mix: https://www.shure.com/en-US/products/software/motiv-mix (not ShurePlus MOTIV)." \
    "- Sign in, activate licenses, and approve macOS privacy/driver prompts." \
    "- Open Docker Desktop once to finish setup." \
    "- Restore App Store apps with ./install.sh --app-store if needed." \
    "- Provision a Git signing key locally; see setup/gitconfig.local.example." \
    "- Restart the terminal. See README.md for private overrides and backups."
printf '%s\n' 'To use the copied ~/.zshrc immediately, open a new terminal or run: exec zsh -l'
