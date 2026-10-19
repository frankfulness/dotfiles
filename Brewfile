# Only requested desktop apps and dependencies for the portable shell.
# Node is installed by upstream NVM, not Homebrew. No Powerlevel10k.
app_present = lambda do |name|
  paths = ["/Applications/#{name}.app", File.expand_path("~/Applications/#{name}.app")]
  present = paths.any? { |path| File.exist?(path) || File.symlink?(path) }
  puts "Skipping #{name}: app already present; leaving it untouched." if present
  present
end
brew "git"
brew "git-lfs"
brew "gh"
brew "gnupg"
brew "python"
brew "starship"
brew "bat"
brew "eza"
brew "fd"
brew "fzf"
brew "ripgrep"
brew "tree"
brew "zoxide"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"
cask "font-0xproto-nerd-font"
cask "font-hack"

# Terminal, development, communication, and design
cask "warp" unless app_present.call("Warp")
cask "claude" unless app_present.call("Claude")
cask "docker-desktop" unless app_present.call("Docker")
cask "figma" unless app_present.call("Figma")
cask "slack" unless app_present.call("Slack")
cask "zoom" unless app_present.call("zoom.us")
cask "obsidian" unless app_present.call("Obsidian")
cask "google-chrome" unless app_present.call("Google Chrome")
cask "visual-studio-code" unless app_present.call("Visual Studio Code")
cask "bruno" unless app_present.call("Bruno")

# Requested utilities and other apps
cask "clipy" unless app_present.call("Clipy")
cask "screen-studio" unless app_present.call("Screen Studio")
cask "raycast" unless app_present.call("Raycast")
cask "affinity" unless app_present.call("Affinity")
cask "spotify" unless app_present.call("Spotify")

# Purchased apps: setup/Brewfile.app-store (explicit opt-in).
# MOTIV Mix: official vendor download; shureplus-motiv is NOT a substitute.
