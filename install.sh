#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

echo "🚀 Starting dotfiles installation..."

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon
    if [[ $(uname -m) == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

# Install packages from Brewfile
echo "📦 Installing Homebrew packages..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# Create .config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Symlink config directories
echo "🔗 Symlinking config files..."

configs=(
    "nvim"
    "aerospace"
    "sketchybar"
    "kitty"
    "borders"
    "gh"
    "warp-themes"
)

for config in "${configs[@]}"; do
    if [ -e "$CONFIG_DIR/$config" ]; then
        echo "  ⚠️  $CONFIG_DIR/$config already exists, backing up..."
        mv "$CONFIG_DIR/$config" "$CONFIG_DIR/$config.backup.$(date +%Y%m%d%H%M%S)"
    fi
    ln -sf "$DOTFILES_DIR/$config" "$CONFIG_DIR/$config"
    echo "  ✓ Linked $config"
done

# Symlink starship.toml
if [ -e "$CONFIG_DIR/starship.toml" ]; then
    mv "$CONFIG_DIR/starship.toml" "$CONFIG_DIR/starship.toml.backup.$(date +%Y%m%d%H%M%S)"
fi
ln -sf "$DOTFILES_DIR/starship.toml" "$CONFIG_DIR/starship.toml"
echo "  ✓ Linked starship.toml"

# Symlink home directory dotfiles
echo "🔗 Symlinking home dotfiles..."

home_files=(
    ".zshrc:.zshrc"
    ".gitconfig:.gitconfig"
    ".tmux.conf:.tmux.conf"
)

for mapping in "${home_files[@]}"; do
    target="${mapping%%:*}"
    source="${mapping##*:}"
    
    if [ -f "$DOTFILES_DIR/$source" ]; then
        if [ -e "$HOME/$target" ]; then
            echo "  ⚠️  $HOME/$target already exists, backing up..."
            mv "$HOME/$target" "$HOME/$target.backup.$(date +%Y%m%d%H%M%S)"
        fi
        ln -sf "$DOTFILES_DIR/$source" "$HOME/$target"
        echo "  ✓ Linked $target"
    fi
done

# Symlink .hammerspoon if it exists
if [ -d "$DOTFILES_DIR/.hammerspoon" ]; then
    if [ -e "$HOME/.hammerspoon" ]; then
        mv "$HOME/.hammerspoon" "$HOME/.hammerspoon.backup.$(date +%Y%m%d%H%M%S)"
    fi
    ln -sf "$DOTFILES_DIR/.hammerspoon" "$HOME/.hammerspoon"
    echo "  ✓ Linked .hammerspoon"
fi

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "📦 Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install Powerlevel10k theme if not present
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "📦 Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
fi

echo ""
echo "✅ Dotfiles installation complete!"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal"
echo "  2. Run 'brew services start sketchybar' if you want the menu bar"
echo "  3. Run 'brew services start borders' if you want window borders"
echo "  4. Open Aerospace to enable the tiling window manager"
