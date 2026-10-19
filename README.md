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

1. Apple Command Line Tools and architecture-appropriate Homebrew.
2. Curated applications, Git/tools, and fonts from `Brewfile`.
3. Oh My Zsh, upstream NVM (pinned to v0.40.8 for a new install), and the current Node LTS. Existing NVM installs are reused, not overwritten; Node's default becomes `lts/*`.
4. Copy reviewed configs, preserve private Git settings, and create the PARA folders.
5. Install the reviewed VS Code extensions from `vscode/extensions.txt`.
6. Optionally restore purchased App Store apps.

Homebrew comes before the apps because it installs them. Setup does not remove applications, clean Homebrew packages, start background services, import credentials, or silently grant permissions. Existing Homebrew packages are not upgraded by this bootstrap. It does not install Homebrew Node, Powerlevel10k, extra terminals, window managers, or the legacy repository's entire tool collection.

### Options

- `./install.sh --dry-run`: preview; no downloads, application installs, or configuration changes.
- `./install.sh --config-only`: restore configs and PARA only; requires Python 3 already installed.
- `./install.sh --app-store`: full setup plus purchased App Store apps.
- `./install.sh --non-interactive`: skip Git identity prompts; configure identity separately.
- `./install.sh --skip-extensions`: omit VS Code extension installation.

Options can be combined. Rerun after fixing a failed step; identical config files are left unchanged. This is a resumable bootstrap, not a transactional system image or version-locked package snapshot. Never use `brew bundle dump --force` to replace the curated Brewfile with every app on a machine.

## Applications

**Homebrew:** Warp, Claude Desktop, Docker Desktop, Figma, Slack, Zoom, Obsidian, Google Chrome, Visual Studio Code, Bruno, Clipy, Screen Studio, Raycast, Affinity, and Spotify.

**App Store:** [Dato](https://apps.apple.com/app/id1470584107), [Cursor Pro](https://apps.apple.com/app/id1447043133), and [Keystroke Pro](https://apps.apple.com/app/id1572206224). Sign in to the App Store first and purchase/claim the apps with that Apple Account. `--app-store` uses `mas` to restore them; it cannot purchase apps or bypass account prompts. Cursor Pro is the pointer-highlighting utility, not the Cursor editor.

**Vendor install:** [Shure MOTIV Mix](https://www.shure.com/en-US/products/software/motiv-mix) for the MV7+. Download the current macOS installer from Shure, install it, and approve microphone/audio-driver permissions. The Homebrew `shureplus-motiv` package is a different, older product and is intentionally not installed. No unverified download URL or unattended driver installer is used.

After installation, open Docker Desktop to complete its first-run setup. Sign in to apps and activate paid licenses, including Screen Studio/Affinity if required. Accessibility, Screen Recording, microphone access, browser defaults, and login items require explicit user action. No app logins, license files, or app databases are stored here.

## Shell and private overrides

`.zshrc` preserves the portable parts of the current setup: Oh My Zsh Git/web-search plugins, autosuggestions, syntax highlighting, NVM, Git/Python/navigation aliases, fzf colors/previews, zoxide, and the active Starship prompt. Starship remains useful in other terminals even though Warp currently uses its native prompt (`honor_ps1 = false`). Powerlevel10k is not installed.

Work/customer-specific helpers, internal endpoints, cloud account identifiers, personal vault/project paths, and credential assignments are intentionally excluded. Keep those in `~/.zshrc.local`; use `setup/zshrc.local.example` as a starting point. `~/.zprofile.local` is also supported. These files are ignored by Git. Optional aliases activate only when their tools are already present; Go, Terraform, Neovim, and Claude Code are not silently added as extra applications.

Files are **copied**, not symlinked. Editing a live config cannot accidentally edit the public repository. When updating the repo later, copy only reviewed changes back; never recursively copy your home directory or app support folders.

## Warp

`warp/` captures the current portable settings, custom keybindings, custom theme, and its full-resolution background image. Text/EXIF metadata is stripped from the PNG without changing its pixel data. `font-0xproto-nerd-font` and Hack are installed to match the terminal/AI fonts. The custom theme's absolute path is rendered for the new user's home at install time.

The existing single terminal tab, agent startup tab, and two-tab launch layout are represented without personal machine paths. The startup tab opens `~/Desktop/PARA`. Settings include the current appearance, native prompt selection, agent permissions/denylist, privacy/redaction rules, notifications, and settings-sync preference. Settings Sync can subsequently reconcile these with your signed-in account.

**Intentionally excluded:** authentication, MCP server credentials, histories, conversations, session databases, caches, backups, cloud/account data, and project-specific agent skills. Those are not safe public dotfiles. Sign in again and configure private integrations locally. Existing unrelated Warp themes/layouts are not deleted. The legacy `warp-themes/` collection remains in the repo but is no longer linked wholesale.

Only redistribute images/fonts you have rights to share. Berkeley Mono is not bundled; VS Code keeps it first in its font list and falls back to the installed 0xProto Nerd Font Mono and system monospace fonts.

## VS Code

`vscode/settings.json`, `vscode/keybindings.json`, and `vscode/snippets/` restore the reviewed current preferences and global snippets. The extension list is curated for development, rather than exporting all historical extensions. Temporary Postman instruction paths, a machine-specific Python interpreter, the old terminal environment injection, and obsolete extension/model settings are omitted. Extensions' credential storage, profiles' private state, workspace data, and history are not copied. Sign in to extensions separately.

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

Legacy Neovim/window-manager/terminal configs are retained for reference but are not installed by default.

## Offline validation

```sh
python3 setup/test_setup.py
python3 setup/check-public.py --history
bash -n install.sh
bash -n setup/bootstrap.sh
zsh -n .zshrc
zsh -n .zprofile
./install.sh --dry-run --non-interactive
```

Tests modify only temporary homes. Python 3.11+ additionally validates TOML with the standard library. They cover fresh install, rerun idempotence, backups, private overrides, Git signing/identity migration, symlink handling, path escaping, source preflight, and the exact PARA layout. A complete fresh-Mac software installation still requires testing on a disposable Mac/VM and accepting app-specific prompts.
