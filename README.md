<div align="center">

# 🛠️ Dotfiles

![macOS](https://img.shields.io/badge/macOS-1d2021?style=for-the-badge&logo=apple&logoColor=ebdbb2)
![Warp](https://img.shields.io/badge/Warp-1d2021?style=for-the-badge&logo=warp&logoColor=8ec07c)
![Zsh](https://img.shields.io/badge/Zsh-1d2021?style=for-the-badge&logo=zsh&logoColor=fe8019)
![VSCode](https://img.shields.io/badge/VS_Code-1d2021?style=for-the-badge&logo=visualstudiocode&logoColor=83a598)

_Velocity • Discoverability • Intelligence • Extensibility_

<img src="./images/books.jpg" alt="Ireland Dublin Trinity College Ancient Library" width="800" />

**My macOS development environment — crafted for speed and aesthetics.**

</div>

---

## 🏛️ Stack Overview

| Category | Tools |
| :------- | :---- |
| **Shell** | [Zsh](https://www.zsh.org/) + [Oh My Zsh](https://ohmyz.sh/) |
| **Terminal** | [Warp](https://www.warp.dev/) |
| **Editor** | [VSCode](https://code.visualstudio.com/) |
| **Prompt** | [Starship](https://starship.rs/) |
| **Node** | [NVM](https://github.com/nvm-sh/nvm) + Node LTS |
| **Git** | [Git](https://git-scm.com/) + [GitHub CLI](https://cli.github.com/) |
| **Note System** | [Obsidian](https://obsidian.md/) |

---

## 🚀 Installation

```bash
git clone https://github.com/frankfulness/dotfiles.git ~/.config/dotfiles
cd ~/.config/dotfiles
./install.sh --dry-run
./install.sh
```

**Shell + desktop setup** (also works after installing the apps separately):

```bash
./install.sh --desktop-only
exec zsh -l
```

Copies `.zshrc` to your home directory, restores the base configs, and installs/configures AeroSpace, SketchyBar, and JankyBorders. Existing configs are backed up first. Approve AeroSpace's Accessibility prompt when asked.

<details>
<summary>📦 What the script does</summary>

1. Copy shell configs and create Desktop PARA immediately, backing up prior files.
2. Install Homebrew, shell tools, Oh My Zsh, NVM, and Node LTS.
3. Restore Warp customization before installing the other apps.
4. Restore Git/VSCode settings and extensions, plus desktop tools if requested.

</details>

<details>
<summary>✅ Manual Steps After Install</summary>

1. Restart your terminal and sign in to your apps.
2. Open Docker Desktop to finish its setup.
3. Restore purchased Dato, Cursor Pro, and Keystroke Pro with `./install.sh --app-store`.
4. Install [Shure MOTIV Mix](https://www.shure.com/en-US/products/software/motiv-mix).
5. Activate licenses and approve macOS permissions as needed.

</details>

For installer options, private overrides, Git signing, and backups, see [ADDITIONAL.MD](ADDITIONAL.MD).

---

## 🖥️ Third-Party Apps

### 🔧 Productivity & Utilities

[![Cursor Pro](https://img.shields.io/badge/Cursor_Pro-1d2021?style=flat-square&logo=apple&logoColor=8ec07c)](https://apps.apple.com/app/id1447043133)
[![Clipy](https://img.shields.io/badge/Clipy-1d2021?style=flat-square&logo=apple&logoColor=8ec07c)](https://clipy-app.com/)
[![Dato](https://img.shields.io/badge/Dato-1d2021?style=flat-square&logo=apple&logoColor=fabd2f)](https://sindresorhus.com/dato)
[![Keystroke Pro](https://img.shields.io/badge/Keystroke_Pro-1d2021?style=flat-square&logo=apple&logoColor=d3869b)](https://apps.apple.com/app/keystroke-pro/id1572206224)
[![Raycast](https://img.shields.io/badge/Raycast-1d2021?style=flat-square&logo=raycast&logoColor=fe8019)](https://www.raycast.com/)

### 💻 Development

[![Bruno](https://img.shields.io/badge/Bruno-1d2021?style=flat-square&logo=bruno&logoColor=fe8019)](https://www.usebruno.com/)
[![Docker](https://img.shields.io/badge/Docker-1d2021?style=flat-square&logo=docker&logoColor=83a598)](https://www.docker.com/)
[![VSCode](https://img.shields.io/badge/VSCode-1d2021?style=flat-square&logo=visualstudiocode&logoColor=83a598)](https://code.visualstudio.com/)
[![Warp](https://img.shields.io/badge/Warp-1d2021?style=flat-square&logo=warp&logoColor=8ec07c)](https://www.warp.dev/)

### 🎨 Design & Creative

[![Screen Studio](https://img.shields.io/badge/Screen_Studio-1d2021?style=flat-square&logo=apple&logoColor=fe8019)](https://screen.studio/)
[![MOTIV Mix](https://img.shields.io/badge/MOTIV_Mix-1d2021?style=flat-square&logo=shure&logoColor=ebdbb2)](https://www.shure.com/en-US/products/software/motiv-mix)
[![Affinity](https://img.shields.io/badge/Affinity-1d2021?style=flat-square&logo=affinity&logoColor=8ec07c)](https://www.affinity.studio/)
[![Figma](https://img.shields.io/badge/Figma-1d2021?style=flat-square&logo=figma&logoColor=d3869b)](https://www.figma.com/)

### 📝 Writing & Notes

[![Obsidian](https://img.shields.io/badge/Obsidian-1d2021?style=flat-square&logo=obsidian&logoColor=d3869b)](https://obsidian.md/)

### 🌎 Browsers

[![Chrome](https://img.shields.io/badge/Chrome-1d2021?style=flat-square&logo=googlechrome&logoColor=fabd2f)](https://www.google.com/chrome/)

### 💬 AI & Communication

[![Claude](https://img.shields.io/badge/Claude-1d2021?style=flat-square&logo=anthropic&logoColor=d3869b)](https://claude.ai/)
[![Slack](https://img.shields.io/badge/Slack-1d2021?style=flat-square&logo=slack&logoColor=8ec07c)](https://slack.com/)
[![Zoom](https://img.shields.io/badge/Zoom-1d2021?style=flat-square&logo=zoom&logoColor=83a598)](https://zoom.us/)


---

## 🤓 CLI Tools

[![eza](https://img.shields.io/badge/eza-1d2021?style=flat-square&logo=github&logoColor=fabd2f)](https://github.com/eza-community/eza)
[![Git LFS](https://img.shields.io/badge/Git_LFS-1d2021?style=flat-square&logo=git&logoColor=fe8019)](https://git-lfs.com/)
[![GnuPG](https://img.shields.io/badge/GnuPG-1d2021?style=flat-square&logo=gnupg&logoColor=8ec07c)](https://gnupg.org/)
[![Python](https://img.shields.io/badge/Python-1d2021?style=flat-square&logo=python&logoColor=fabd2f)](https://www.python.org/)
[![bat](https://img.shields.io/badge/bat-1d2021?style=flat-square&logo=github&logoColor=fabd2f)](https://github.com/sharkdp/bat)
[![fd](https://img.shields.io/badge/fd-1d2021?style=flat-square&logo=github&logoColor=8ec07c)](https://github.com/sharkdp/fd)
[![fzf](https://img.shields.io/badge/fzf-1d2021?style=flat-square&logo=github&logoColor=d3869b)](https://github.com/junegunn/fzf)
[![GitHub CLI](https://img.shields.io/badge/gh-1d2021?style=flat-square&logo=github&logoColor=ebdbb2)](https://cli.github.com/)
[![Git](https://img.shields.io/badge/git-1d2021?style=flat-square&logo=git&logoColor=fe8019)](https://git-scm.com/)
[![nvm](https://img.shields.io/badge/nvm-1d2021?style=flat-square&logo=nodedotjs&logoColor=b8bb26)](https://github.com/nvm-sh/nvm)
[![ripgrep](https://img.shields.io/badge/ripgrep-1d2021?style=flat-square&logo=github&logoColor=8ec07c)](https://github.com/BurntSushi/ripgrep)
[![Starship](https://img.shields.io/badge/starship-1d2021?style=flat-square&logo=starship&logoColor=fabd2f)](https://starship.rs/)
[![tree](https://img.shields.io/badge/tree-1d2021?style=flat-square&logo=gnubash&logoColor=8ec07c)](https://linux.die.net/man/1/tree)
[![zoxide](https://img.shields.io/badge/zoxide-1d2021?style=flat-square&logo=github&logoColor=fabd2f)](https://github.com/ajeetdsouza/zoxide)
[![Zsh](https://img.shields.io/badge/zsh-1d2021?style=flat-square&logo=zsh&logoColor=b8bb26)](https://www.zsh.org/)

---

## ⌨️ Hardware & Other

[![Kinesis 360](https://img.shields.io/badge/Kinesis_Advantage_360-1d2021?style=flat-square&logo=kinesis&logoColor=8ec07c)](https://kinesis-ergo.com/keyboards/advantage360/)
[![Bambu Lab](https://img.shields.io/badge/Bambu_P2S-1d2021?style=flat-square&logo=bambulab&logoColor=b8bb26)](https://bambulab.com/)
[![Raspberry Pi](https://img.shields.io/badge/Raspberry_Pi-1d2021?style=flat-square&logo=raspberrypi&logoColor=fb4934)](https://www.raspberrypi.com/software/)
[![Shure MV7+](https://img.shields.io/badge/Shure_MV7+-1d2021?style=flat-square&logo=shure&logoColor=ebdbb2)](https://www.shure.com/en-US/microphones/mv7)
[![Spotify](https://img.shields.io/badge/Spotify-1d2021?style=flat-square&logo=spotify&logoColor=b8bb26)](https://www.spotify.com/)

---

<div align="center">

<img src="./images/keyboard.png" alt="Kinesis Advantage 360" width="600" />

_Built with ☕_

</div>
