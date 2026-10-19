# Mac dotfiles

A focused, public-safe setup for a fresh Mac: Zsh + Oh My Zsh + Starship, a customized Warp terminal, VS Code, Node through NVM, Git, and a curated application list.

## Fresh Mac

Use the built-in Terminal to get started. If Git is unavailable, run `xcode-select --install`, complete Apple's installer, and then continue. Alternatively, download and extract this repository's ZIP from GitHub.

```sh
git clone https://github.com/frankfulness/dotfiles.git "$HOME/.config/dotfiles"
cd "$HOME/.config/dotfiles"
./install.sh --dry-run
./install.sh
```

The installer must run as your normal user, **not** with `sudo`. Homebrew or individual installers may request administrator approval. Quit Warp and VS Code before restoring their settings; reopen them afterward. If the Command Line Tools are missing, setup opens Apple's installer and asks you to rerun after it completes.

### Installation order

1. Immediately copy `.zshrc`, `.zprofile`, and Starship settings into your home, backing up prior files, and create Desktop PARA. This phase needs neither Python nor Homebrew.
2. Set up Apple Command Line Tools and architecture-appropriate Homebrew.
3. Install the CLI tools from `setup/Brewfile.shell`, then Oh My Zsh, upstream NVM (pinned to v0.40.8 for a new install), and current Node LTS. Existing NVM installs are reused; Node's default becomes `lts/*`.
4. Restore Warp settings, keybindings, theme, and background first, then install missing Warp/fonts using `setup/Brewfile.warp`.
5. If requested, trust/install the exact desktop dependencies. Then install other GUI applications from `setup/Brewfile.apps` (skipped by `--desktop-only`).
6. Restore remaining Git/editor/optional desktop configs, start requested desktop services, and install VS Code extensions.
7. Optionally restore purchased App Store apps.

A script launched with `./install.sh` cannot source Zsh config into its parent terminal. The first phase makes it available immediately to new Zsh terminals; after setup, run `source ~/.zshrc` or `exec zsh -l` in the original terminal. Missing optional tools are guarded, so the early shell can load before downloads finish. Shell shortcuts requiring those tools become available once the tools are installed and the shell is reloaded.

The root `Brewfile` remains an aggregate of the shell, Warp, and other-app manifests for direct `brew bundle` use. Only `install.sh` guarantees the early shell/PARA copies and phased configuration ordering.

Homebrew comes before the apps because it installs them. The default setup does not remove applications, clean Homebrew packages, start background services, import credentials, or silently grant permissions. Existing Homebrew packages are not upgraded by this bootstrap. It does not install Homebrew Node, Powerlevel10k, extra terminals, or the legacy repository's entire tool collection. Desktop tools/services are opt-in as described below.

GUI apps already present in `/Applications` or `~/Applications` are skipped with a visible message, even if installed manually rather than through Homebrew. They are not downloaded, adopted, upgraded, or replaced by these app entries. Existing app symlinks (including broken ones) are also left alone for manual review. Apps stored elsewhere or renamed are not detected by these checks. This applies to the optional App Store apps too. Fonts still use Homebrew's installed-package checks; Homebrew may update dependencies needed by a newly installed package despite `--no-upgrade`.

This app protection does **not** disable configuration restoration: the shell/Warp/remaining configuration phases still back up and replace differing managed config files, and the editor stage installs the configured VS Code extensions.

### Options

- `./install.sh --dry-run`: preview; no downloads, application installs, or configuration changes.
- `./install.sh --config-only`: restore configs and PARA only; requires Python 3 already installed.
- `./install.sh --app-store`: full setup plus purchased App Store apps.
- `./install.sh --non-interactive`: skip Git identity prompts; configure identity separately.
- `./install.sh --skip-extensions`: omit VS Code extension installation.
- `./install.sh --vscode-only`: restore only VS Code settings/keybindings/snippets and install the declared missing extensions, without touching the shell, Warp, Git, or desktop services.
- `./install.sh --desktop`: full setup plus AeroSpace, SketchyBar, and JankyBorders.
- `./install.sh --desktop-only`: skip the main GUI app bundle and VS Code extension stage; install shell/desktop dependencies, set up Oh My Zsh/NVM/Node LTS, copy base and desktop configs, then start desktop services.
- `./install.sh --config-only --desktop`: copy base and desktop configs without installing tools or starting services.
- `./install.sh --desktop-only --no-start`: install tools and copy configs, but defer service startup.
- `./install.sh --desktop-only --keep-menu-bar`: start desktop tools without changing the native menu-bar preference.

Options can be combined. Rerun after fixing a failed step; identical config files are left unchanged. This is a resumable bootstrap, not a transactional system image or version-locked package snapshot. Never use `brew bundle dump --force` to replace the curated Brewfile with every app on a machine.

## Applications

**Homebrew:** Warp, Claude Desktop, Docker Desktop, Figma, Slack, Zoom, Obsidian, Google Chrome, Visual Studio Code, Bruno, Clipy, Screen Studio, Raycast, Affinity, and Spotify.

**App Store:** [Dato](https://apps.apple.com/app/id1470584107), [Cursor Pro](https://apps.apple.com/app/id1447043133), and [Keystroke Pro](https://apps.apple.com/app/id1572206224). Sign in to the App Store first and purchase/claim the apps with that Apple Account. `--app-store` uses `mas` to restore them; it cannot purchase apps or bypass account prompts. Cursor Pro is the pointer-highlighting utility, not the Cursor editor.

**Vendor install:** [Shure MOTIV Mix](https://www.shure.com/en-US/products/software/motiv-mix) for the MV7+. Download the current macOS installer from Shure, install it, and approve microphone/audio-driver permissions. The Homebrew `shureplus-motiv` package is a different, older product and is intentionally not installed. No unverified download URL or unattended driver installer is used.

After installation, open Docker Desktop to complete its first-run setup. Sign in to apps and activate paid licenses, including Screen Studio/Affinity if required. Accessibility, Screen Recording, microphone access, browser defaults, and login items require explicit user action. No app logins, license files, or app databases are stored here.

## Shell and private overrides

`.zshrc` preserves the portable parts of the current setup: Oh My Zsh Git/web-search plugins, autosuggestions, syntax highlighting, NVM, Git/Python/navigation aliases, fzf colors/previews, zoxide, and the active Starship prompt. Starship remains useful in other terminals even though Warp currently uses its native prompt (`honor_ps1 = false`). Powerlevel10k is not installed.

Work/customer-specific helpers, internal endpoints, cloud account identifiers, personal vault/project paths, and credential assignments are intentionally excluded. Keep those in `~/.zshrc.local`; use `setup/zshrc.local.example` as a starting point. `~/.zprofile.local` is also supported. These files are ignored by Git. Optional aliases activate only when their tools are already present; Go, Terraform, and Claude Code are not silently added as extra applications. Neovim is part of the standard shell-tool phase.

Files are **copied**, not symlinked. Editing a live config cannot accidentally edit the public repository. When updating the repo later, copy only reviewed changes back; never recursively copy your home directory or app support folders.

## Warp

`warp/` captures the current portable settings, custom keybindings, custom theme, and its full-resolution background image. Text/EXIF metadata is stripped from the PNG without changing its pixel data. `font-0xproto-nerd-font` and Hack are installed to match the terminal/AI fonts. The custom theme's absolute path is rendered for the new user's home at install time.

The PNG master is retained, but the active theme uses the full-resolution `custom/custom.jpg` export. That image reference is relative to `~/.warp/themes`, not a `~`-prefixed path that the image loader may interpret literally. Assets are deployed before the selected theme/settings. If Warp has not discovered a newly added image/theme yet, reopen Warp to refresh its theme cache.

The portable settings explicitly disable agent attribution using `agents.warp_agent.other.agent_attribution_enabled = false`.

The existing single terminal tab, agent startup tab, and two-tab launch layout are represented without personal machine paths. The startup tab opens `~/Desktop/PARA`. Settings include the current appearance, native prompt selection, agent permissions/denylist, privacy/redaction rules, notifications, and settings-sync preference. Settings Sync can subsequently reconcile these with your signed-in account.

**Intentionally excluded:** authentication, MCP server credentials, histories, conversations, session databases, caches, backups, cloud/account data, and project-specific agent skills. Those are not safe public dotfiles. Sign in again and configure private integrations locally. Existing unrelated Warp themes/layouts are not deleted. The legacy `warp-themes/` collection remains in the repo but is no longer linked wholesale.

Only redistribute images/fonts you have rights to share. Berkeley Mono is not bundled; VS Code keeps it first in its font list and falls back to the installed 0xProto Nerd Font Mono and system monospace fonts.

## VS Code

`vscode/settings.json`, `vscode/keybindings.json`, and `vscode/snippets/` restore the reviewed current preferences and global snippets. The extension list is curated for development, rather than exporting all historical extensions. Temporary Postman instruction paths, a machine-specific Python interpreter, the old terminal environment injection, and obsolete extension/model settings are omitted. Extensions' credential storage, profiles' private state, workspace data, and history are not copied. Sign in to extensions separately.

`./install.sh --vscode-only` completes that setup independently after Visual Studio Code is installed. It includes the Gruvbox theme, icons, formatting/language tools, and extensions supporting the configured Atom keymap, notebooks, Makefiles, and AWS tooling. Existing extension IDs are compared case-insensitively and skipped rather than upgraded or removed. Failures are reported individually; rerun to retry missing items. Reload the VS Code window afterward and sign in to Copilot/AWS/GitHub as needed. Use `--vscode-only --config-only` to restore only preferences. `DOTFILES_VSCODE_CLI` can select a nonstandard CLI location.

`--desktop-only` and `--config-only` still skip extension installation, but now print the explicit completion command so restored preferences are not mistaken for a finished editor setup.

## Neovim

The shell-first Homebrew phase installs `neovim`. The normal, desktop-only, and config-only setup modes copy `init.lua`, the `lua/` modules, `lazy-lock.json`, `lazyvim.json`, `.neoconf.json`, and `stylua.toml` from the repo into `~/.config/nvim`, backing up differing files and detaching an old config-directory symlink safely. Untracked runtime/plugin caches and private local files are not imported from the machine.

Open `nvim` after setup to bootstrap LazyVim/plugins, then run `:checkhealth` inside Neovim for language-specific dependencies. Plugin downloads happen on first launch, not as hidden install-time code execution. Reloading `.zshrc` activates the `vim` alias when Neovim is available.

## Git identity and signing

Shared `.gitconfig` contains no personal identity or signing-key identifier. It includes `~/.gitconfig.local`, which is never tracked. On an existing Mac, prior Git settings are migrated to that private file if it does not already exist. An existing local override is kept unchanged. Original replaced files are backed up. On a fresh Mac, setup prompts for name/email in an interactive terminal; otherwise copy `setup/gitconfig.local.example` to `~/.gitconfig.local` and edit it.

Choose an email suitable for **public commit metadata**, such as your GitHub noreply address. Keeping the config private does not hide the author identity embedded in commits.

A **public signing key or fingerprint is safe to publish**. A **private signing key is never safe to publish**. The setup deliberately keeps even the fingerprint local and does not turn on signing for an unprovisioned machine. Generate/import a key locally, register its public part with GitHub, and enable signing in the private config using the commented GPG/SSH examples. Keys are never generated, copied, or uploaded automatically.

## PARA

Setup creates these directories under `~/Desktop/PARA` without renaming or removing any existing folders:

- `0-index/`
- `1-projects/`
- `2-areas/`
- `3-resources/`
- `4-archive/`
  - `completed-projects/`
  - `finished-tasks/`
  - `inactive-area/`
  - `prior-interest/`

These directories are empty on a fresh install. Existing differently named PARA folders remain untouched; migrate their contents manually if desired.

## Backups and public safety

Changed files are backed up under `~/.local/state/dotfiles/backups/<timestamp>/`, **outside this repository**, with a private backup root. Existing `.zshrc.local` and `.gitconfig.local` are left alone. To undo a config replacement, close the affected app and restore the corresponding file from that backup. Software installation and Node defaults are not automatically rolled back.

Before publishing any changes, review the diff and run the heuristic scan:

```sh
python3 setup/check-public.py --history
git diff --check
```

The checker reports locations, never secret values. It detects common credential formats, literal credential assignments, and machine-specific home paths; it is not a comprehensive secret scanner or a guarantee of safety. Use an independent scanner such as Gitleaks as an additional check. Ignore rules do not protect secrets in already-tracked files. If a real credential ever entered public history, revoke/rotate it; deleting its current line does not erase the old commits.

Extra-terminal configs are retained for reference but are not installed by default. Neovim configuration is deployed by the standard editor-config stage.

## Shell and desktop setup after cloning

From the cloned repo on the new Mac, run `./install.sh --desktop-only`, then `exec zsh -l` (or open a new terminal). Preview with `./install.sh --desktop-only --dry-run`. This copies the repo-root `.zshrc` to `~/.zshrc`, along with the existing base configuration set (including Warp, Git, VS Code preferences, and PARA directories). It does not source private machine-specific helpers from the public repository.

The desktop profile installs the shell tools, `jq`, `felixkratz/formulae/sketchybar`, `felixkratz/formulae/borders`, and `nikitabobko/tap/aerospace`. On Homebrew versions with tap trust, setup first taps the two upstream repositories, then explicitly trusts only the SketchyBar and borders formulas and the AeroSpace cask when installing it. Trust is followed by the actual package installation through `brew bundle install --verbose --no-upgrade`; trust alone does not install anything. It does not trust entire taps, disable trust checks, use `--adopt`, or bypass Gatekeeper.

Existing AeroSpace app bundles are left untouched. A manually installed AeroSpace also needs its separate `aerospace` CLI on PATH; if missing, setup reports this instead of replacing the app. Install that CLI from the official release into `~/.local/bin`.

Config copies go into `~/.config/aerospace`, `~/.config/sketchybar`, and `~/.config/borders`. Scripts retain executable permissions, backup/example files are excluded, and the repo's matching app-icon font is installed into `~/Library/Fonts`. An existing 0xProto Nerd Font file causes the font cask to be skipped to avoid manual-install collisions; if only some styles are installed, complete that font installation separately. An existing `~/.aerospace.toml` is moved into the private backup directory to avoid AeroSpace's conflicting-config-locations error. Desktop-directory symlinks are backed up and replaced with real directories rather than modifying an old checkout.

Once configs are copied, setup opens/reloads AeroSpace and restarts the user-level Homebrew borders/SketchyBar services (which run at future logins). It waits for the bar to respond, reloads the full bar configuration, and refreshes its AeroSpace workspace state. Workspace initialization runs separately, so a slow AeroSpace startup cannot stop the clock, Spotify, or event listener from loading. To retry startup without reinstalling or copying anything, run `bash setup/start-desktop.sh`. AeroSpace is configured to start at login.

After SketchyBar responds and accepts a reload, desktop startup enables native menu-bar auto-hide (`defaults write NSGlobalDomain _HIHideMenuBar -bool true`) and restarts the user's SystemUIServer so the preference takes effect. If the bar does not respond, this preference is left unchanged. Use `--keep-menu-bar` on the installer or startup helper to skip this change. That option preserves the current preference; to show the native menu bar again, set `_HIHideMenuBar` to `false` and restart SystemUIServer, or change the menu-bar auto-hide setting in System Settings.

Before reloading AeroSpace, desktop startup fits `gaps.outer.top` to the live SketchyBar height/offset plus 10 pixels of clearance. It subtracts each notched display's already-reserved safe area using AppKit screen information, with per-monitor rules and a non-notched fallback. This avoids counting the hidden native menu/notch area twice. Previous layout files are backed up privately; the public repo keeps a portable fallback rather than a machine-specific display rule. Rerun `bash setup/start-desktop.sh` after changing monitor arrangements or the bar geometry.

macOS still requires you to approve AeroSpace's Accessibility access and any requested Automation/Screen Recording permissions. The setup does not change display/Spaces preferences, unload system services, remove quarantine flags, or grant permissions automatically. JankyBorders requires macOS 14 or newer. Desktop appearance, multi-monitor behavior, and actual permissions need verification on the new Mac.

## Offline validation

```sh
python3 setup/test_setup.py
python3 -m unittest discover -s setup -p 'test_*.py'
python3 setup/check-public.py --history
bash -n install.sh
bash -n setup/bootstrap.sh
zsh -n .zshrc
zsh -n .zprofile
./install.sh --dry-run --non-interactive
```

Tests modify only temporary homes. Python 3.11+ additionally validates TOML with the standard library. They cover fresh install, rerun idempotence, backups, private overrides, Git signing/identity migration, symlink handling, path escaping, source preflight, and the exact PARA layout. A complete fresh-Mac software installation still requires testing on a disposable Mac/VM and accepting app-specific prompts.
