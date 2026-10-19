#!/bin/bash
# Compatible with the Bash 3.2 shipped with macOS.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DRY_RUN=0
CONFIG_ONLY=0
APP_STORE=0
INTERACTIVE=1
EXTENSIONS=1

usage() {
    printf '%s\n' "Usage: ./install.sh [options]" \
        "  --dry-run          Preview without downloads or filesystem changes" \
        "  --config-only      Deploy configs and PARA; skip installing software" \
        "  --app-store        Also restore the three purchased App Store apps" \
        "  --non-interactive  Skip Git identity prompts" \
        "  --skip-extensions  Skip VS Code extension installation" \
        "  --help             Show this help"
}
for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=1 ;;
        --config-only) CONFIG_ONLY=1 ;;
        --app-store) APP_STORE=1 ;;
        --non-interactive) INTERACTIVE=0 ;;
        --skip-extensions) EXTENSIONS=0 ;;
        --help|-h) usage; exit 0 ;;
        *) printf 'Unknown option: %s\n' "$arg" >&2; usage >&2; exit 2 ;;
    esac
done
[ "$(uname -s)" = Darwin ] || { printf 'macOS only.\n' >&2; exit 1; }
[ "$(id -u)" -ne 0 ] || { printf 'Run as your normal user, not sudo.\n' >&2; exit 1; }

run() {
    if [ "$DRY_RUN" -eq 1 ]; then
        printf '[dry-run]'
        printf ' %q' "$@"
        printf '\n'
    else
        "$@"
    fi
}

if [ "$CONFIG_ONLY" -eq 0 ]; then
    printf '\n1. Apple Command Line Tools and Homebrew\n'
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
    printf '\n2. Curated applications, fonts, and shell tools\n'
    printf 'Existing apps in /Applications or ~/Applications are skipped, not adopted or replaced.\n'
    run brew bundle install --verbose --no-upgrade --file="$ROOT/Brewfile"
    printf '\n3. Oh My Zsh, upstream NVM, and Node LTS\n'
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

printf '\n4. Portable settings, private Git identity, and PARA folders\n'
configure_args=()
[ "$DRY_RUN" -eq 0 ] || configure_args+=(--dry-run)
[ "$INTERACTIVE" -eq 1 ] || configure_args+=(--non-interactive)
if command -v python3 >/dev/null 2>&1; then
    python3 "$ROOT/setup/configure.py" ${configure_args[@]+"${configure_args[@]}"}
elif [ "$DRY_RUN" -eq 1 ]; then
    printf '[dry-run] Python 3 (installed in step 2) will deploy configuration.\n'
else
    printf 'Python 3 is required. Run the full installer first.\n' >&2
    exit 1
fi
if [ "$CONFIG_ONLY" -eq 0 ] && [ "$EXTENSIONS" -eq 1 ]; then
    printf '\n5. VS Code extensions\n'
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
if [ "$CONFIG_ONLY" -eq 0 ] && [ "$APP_STORE" -eq 1 ]; then
    printf '\n6. Purchased App Store apps (sign in to the App Store first)\n'
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
