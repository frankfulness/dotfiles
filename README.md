# 📂 Dotfiles

> The philosophy is to continually prioritize velocity, discoverability, intelligence, & extensibility.
Simplicity is key, and I value clean aesthetics.

<img src="./assets/books.jpg" alt="Ireland Dublin Trinity College Ancient Library image of book isles full of ancient books with ceramic busts of men at every endcap." />

My macOS development environment configuration.

## What's Included

- **Shell**: Zsh with Oh My Zsh + Powerlevel10k
- **Terminal**: Kitty & Warp
- **Editor**: Neovim (LazyVim), VSCode
- **Window Management**: Aerospace (tiling), JankBorders
- **Menu Bar**: Sketchybar
- **Prompt**: Starship
- **Git**: Global config + GitHub CLI
- Apps: All my 3rd party applications listed

## Installation

On a fresh Mac:

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.config/dotfiles

# Run the install script
cd ~/.config/dotfiles
./install.sh
```

The script will:
1. Install Homebrew (if needed)
2. Install all packages from the Brewfile
3. Symlink all configs to the correct locations
4. Install Oh My Zsh and Powerlevel10k

### VSCode Setup

After running the install script, restore VSCode settings:

```bash
# Copy settings
cp ~/.config/dotfiles/vscode/settings.json ~/Library/Application\ Support/Code/User/
cp ~/.config/dotfiles/vscode/keybindings.json ~/Library/Application\ Support/Code/User/

# Install extensions
cat ~/.config/dotfiles/vscode/extensions.txt | xargs -L 1 code --install-extension
```

## Manual Steps After Install

1. Restart your terminal
2. Start services:
   ```bash
   brew services start sketchybar
   brew services start borders
   ```
3. Open Aerospace to enable tiling
4. Configure any app-specific settings

## Updating

To update the Brewfile after installing new packages:

```bash
brew bundle dump --file=~/.config/dotfiles/Brewfile --force
```

---

## Third-Party Apps (Non-Default macOS)

### Productivity & Utilities
- Amphetamine
- Clipy (Smooth clipboard management)
- Dato (Favorite Calendar/Date/Time MacOS Replacement)
- DevCleaner
- Flow (Pomodoro Timer)
- f.lux (Blue light removal)
- Keyboard Maestro (Custom MacOS Macros/Rebinds)
- Keystroke Pro (Visual keystrokes)
- Magnet (Kinda redundant with AeroSpace but still nice)
- Mirror Magnet (Video for Recording)
- Raycast (Spotlight replacement & more)
- Theine (Keep machine awake)

### Development
- Bruno (API Testing)
- Cursor Pro (for recording)
- Docker (Podman too, Containerization)
- kitty (Pure terminal, backup to warp)
- PopSQL
- Postman (API Testing, sold out)
- Visual Studio Code (Still a crutch)
- Warp (AI + Terminal & more)
- Xcode

### Design & Creative
- Affinity Designer 2
- Affinity Photo 2
- Affinity Publisher 2
- Blender
- Figma
- OBS (Streaming)

### Writing & Notes
- Notion (Public facing notes tool)
- Obsidian (Internal facing 2nd Brain)
- Scapple (Real writing)
- Scrivener (Real writing)
- Typora (Quick markdown notes, kinda redundant)

### Browsers
- Firefox (Default, but switching to Zen slowly)
- Firefox Developer Edition
- Google Chrome
- Microsoft Edge
- Zen

### Communication
- Claude (AI)
- Microsoft Outlook
- Microsoft Teams
- Slack
- Zoom

### Corp Sellout
- Microsoft Excel
- Microsoft OneNote
- Microsoft PowerPoint
- Microsoft Word
- OneDrive

### Mail, Cloud & Security
- Proton Drive
- Proton Mail
- ProtonVPN

### CLI
- awscli
- bash
- bat
- fd
- fish
- fzf
- gh
- git
- go
- lazygit
- lsd
- neofetch
- neovim
- nvm
- opencode
- ripgrep
- starship
- terraform
- tmux
- tree
- yamllint
- zellij
- zoxide
- zsh

### Other
- Advantage 360 SmartSet App (My Kinesis Ergo Keyboard)
- BambuStudio (Our family Bambu P2S 3D Printer)
- Lumary (Professional Recording)
- Raspberry Pi Imager
- Shure (MV7+ Motiv Mix Microphone)
- Spotify (Music)
