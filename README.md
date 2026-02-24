<div align="center">

# 🛠️ Dotfiles

![macOS](https://img.shields.io/badge/macOS-1d2021?style=for-the-badge&logo=apple&logoColor=ebdbb2)
![Neovim](https://img.shields.io/badge/Neovim-1d2021?style=for-the-badge&logo=neovim&logoColor=b8bb26)
![Zsh](https://img.shields.io/badge/Zsh-1d2021?style=for-the-badge&logo=zsh&logoColor=fe8019)
![Lua](https://img.shields.io/badge/Lua-1d2021?style=for-the-badge&logo=lua&logoColor=83a598)

_Velocity • Discoverability • Intelligence • Extensibility_

<img src="./images/books.jpg" alt="Ireland Dublin Trinity College Ancient Library" width="800" />

**My macOS development environment — crafted for speed and aesthetics.**

</div>

---

## 🏛️ Stack Overview

| Category              | Tools                                                                                                                     |
| :-------------------- | :------------------------------------------------------------------------------------------------------------------------ |
| **Shell**             | [Zsh](https://www.zsh.org/) + [Oh My Zsh](https://ohmyz.sh/) + [Powerlevel10k](https://github.com/romkatv/powerlevel10k)  |
| **Terminal**          | [Kitty](https://sw.kovidgoyal.net/kitty/) • [Warp](https://www.warp.dev/)                                                 |
| **Editor**            | [Neovim](https://neovim.io/) ([LazyVim](https://www.lazyvim.org/)) • [VSCode](https://code.visualstudio.com/)             |
| **Window Management** | [AeroSpace](https://github.com/nikitabobko/AeroSpace) • [JankyBorders](https://github.com/FelixKratz/JankyBorders)        |
| **Menu Bar**          | [SketchyBar](https://github.com/FelixKratz/SketchyBar)                                                                    |
| **Prompt**            | [Starship](https://starship.rs/)                                                                                          |
| **Git**               | [Git](https://git-scm.com/) + [GitHub CLI](https://cli.github.com/) + [LazyGit](https://github.com/jesseduffield/lazygit) |
| **Prompt**            | [Starship](https://starship.rs/)                                                                                          |
| **Note System**       | [Obsidian](https://obsidian.md/)                                                                                          |

---

## 🚀 Installation

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.config/dotfiles

# Run the install script
cd ~/.config/dotfiles
./install.sh
```

<details>
<summary>📦 What the script does</summary>

1. Install [Homebrew](https://brew.sh/) (if needed)
2. Install all packages from the Brewfile
3. Symlink all configs to the correct locations
4. Install Oh My Zsh and Powerlevel10k

</details>

<details>
<summary>🔧 VSCode Setup</summary>

```bash
# Copy settings
cp ~/.config/dotfiles/vscode/settings.json ~/Library/Application\ Support/Code/User/
cp ~/.config/dotfiles/vscode/keybindings.json ~/Library/Application\ Support/Code/User/

# Install extensions
cat ~/.config/dotfiles/vscode/extensions.txt | xargs -L 1 code --install-extension
```

</details>

<details>
<summary>✅ Manual Steps After Install</summary>

1. Restart your terminal
2. Start services:
   ```bash
   brew services start sketchybar
   brew services start borders
   ```
3. Open AeroSpace to enable tiling
4. Configure any app-specific settings

</details>

<details>
<summary>🔄 Updating Brewfile</summary>

```bash
brew bundle dump --file=~/.config/dotfiles/Brewfile --force
```

</details>

---

## 🖥️ Third-Party Apps

### 🔧 Productivity & Utilities

[![Clipy](https://img.shields.io/badge/Clipy-1d2021?style=flat-square&logo=apple&logoColor=8ec07c)](https://clipy-app.com/)
[![Dato](https://img.shields.io/badge/Dato-1d2021?style=flat-square&logo=apple&logoColor=fabd2f)](https://sindresorhus.com/dato)
[![DevCleaner](https://img.shields.io/badge/DevCleaner-1d2021?style=flat-square&logo=xcode&logoColor=83a598)](https://apps.apple.com/app/devcleaner-for-xcode/id1388020431)
[![Flow](https://img.shields.io/badge/Flow-1d2021?style=flat-square&logo=apple&logoColor=fb4934)](https://flowapp.info/)
[![f.lux](https://img.shields.io/badge/f.lux-1d2021?style=flat-square&logo=apple&logoColor=fe8019)](https://justgetflux.com/)
[![Keyboard Maestro](https://img.shields.io/badge/Keyboard_Maestro-1d2021?style=flat-square&logo=apple&logoColor=b8bb26)](https://www.keyboardmaestro.com/)
[![Keystroke Pro](https://img.shields.io/badge/Keystroke_Pro-1d2021?style=flat-square&logo=apple&logoColor=d3869b)](https://apps.apple.com/app/keystroke-pro/id1572206224)
[![Magnet](https://img.shields.io/badge/Magnet-1d2021?style=flat-square&logo=apple&logoColor=8ec07c)](https://magnet.crowdcafe.com/)
[![Mirror Magnet](https://img.shields.io/badge/Mirror_Magnet-1d2021?style=flat-square&logo=apple&logoColor=fabd2f)](https://apps.apple.com/app/mirror-magnet/id1563698880)
[![Raycast](https://img.shields.io/badge/Raycast-1d2021?style=flat-square&logo=raycast&logoColor=fe8019)](https://www.raycast.com/)
[![Theine](https://img.shields.io/badge/Theine-1d2021?style=flat-square&logo=apple&logoColor=83a598)](https://apps.apple.com/app/theine/id955848755)

### 💻 Development

[![Bruno](https://img.shields.io/badge/Bruno-1d2021?style=flat-square&logo=bruno&logoColor=fe8019)](https://www.usebruno.com/)
[![Cursor](https://img.shields.io/badge/Cursor-1d2021?style=flat-square&logo=cursor&logoColor=ebdbb2)](https://cursor.sh/)
[![Docker](https://img.shields.io/badge/Docker-1d2021?style=flat-square&logo=docker&logoColor=83a598)](https://www.docker.com/)
[![Kitty](https://img.shields.io/badge/Kitty-1d2021?style=flat-square&logo=gnometerminal&logoColor=b8bb26)](https://sw.kovidgoyal.net/kitty/)
[![PopSQL](https://img.shields.io/badge/PopSQL-1d2021?style=flat-square&logo=postgresql&logoColor=d3869b)](https://popsql.com/)
[![Postman](https://img.shields.io/badge/Postman-1d2021?style=flat-square&logo=postman&logoColor=fe8019)](https://www.postman.com/)
[![VSCode](https://img.shields.io/badge/VSCode-1d2021?style=flat-square&logo=visualstudiocode&logoColor=83a598)](https://code.visualstudio.com/)
[![Warp](https://img.shields.io/badge/Warp-1d2021?style=flat-square&logo=warp&logoColor=8ec07c)](https://www.warp.dev/)
[![Xcode](https://img.shields.io/badge/Xcode-1d2021?style=flat-square&logo=xcode&logoColor=83a598)](https://developer.apple.com/xcode/)

### 🎨 Design & Creative

[![Affinity](https://img.shields.io/badge/Affinity-1d2021?style=flat-square&logo=affinity&logoColor=8ec07c)](https://affinity.serif.com/)
[![Blender](https://img.shields.io/badge/Blender-1d2021?style=flat-square&logo=blender&logoColor=fe8019)](https://www.blender.org/)
[![Figma](https://img.shields.io/badge/Figma-1d2021?style=flat-square&logo=figma&logoColor=d3869b)](https://www.figma.com/)
[![OBS](https://img.shields.io/badge/OBS-1d2021?style=flat-square&logo=obsstudio&logoColor=ebdbb2)](https://obsproject.com/)

### 📝 Writing & Notes

[![Notion](https://img.shields.io/badge/Notion-1d2021?style=flat-square&logo=notion&logoColor=ebdbb2)](https://www.notion.so/)
[![Obsidian](https://img.shields.io/badge/Obsidian-1d2021?style=flat-square&logo=obsidian&logoColor=d3869b)](https://obsidian.md/)
[![Scapple](https://img.shields.io/badge/Scapple-1d2021?style=flat-square&logo=apple&logoColor=fabd2f)](https://www.literatureandlatte.com/scapple/overview)
[![Scrivener](https://img.shields.io/badge/Scrivener-1d2021?style=flat-square&logo=apple&logoColor=8ec07c)](https://www.literatureandlatte.com/scrivener/overview)
[![Typora](https://img.shields.io/badge/Typora-1d2021?style=flat-square&logo=markdown&logoColor=83a598)](https://typora.io/)

### 🌎 Browsers

[![Firefox](https://img.shields.io/badge/Firefox-1d2021?style=flat-square&logo=firefox&logoColor=fe8019)](https://www.mozilla.org/firefox/)
[![Firefox Dev](https://img.shields.io/badge/Firefox_Dev-1d2021?style=flat-square&logo=firefoxbrowser&logoColor=83a598)](https://www.mozilla.org/firefox/developer/)
[![Chrome](https://img.shields.io/badge/Chrome-1d2021?style=flat-square&logo=googlechrome&logoColor=fabd2f)](https://www.google.com/chrome/)
[![Edge](https://img.shields.io/badge/Edge-1d2021?style=flat-square&logo=microsoftedge&logoColor=83a598)](https://www.microsoft.com/edge)
[![Zen](https://img.shields.io/badge/Zen-1d2021?style=flat-square&logo=zedindustries&logoColor=8ec07c)](https://zen-browser.app/)

### 💬 AI, Communication & Corp

[![Claude](https://img.shields.io/badge/Claude-1d2021?style=flat-square&logo=anthropic&logoColor=d3869b)](https://claude.ai/)
[![Outlook](https://img.shields.io/badge/Outlook-1d2021?style=flat-square&logo=microsoftoutlook&logoColor=83a598)](https://www.microsoft.com/microsoft-365/outlook)
[![Teams](https://img.shields.io/badge/Teams-1d2021?style=flat-square&logo=microsoftteams&logoColor=83a598)](https://www.microsoft.com/microsoft-teams)
[![Slack](https://img.shields.io/badge/Slack-1d2021?style=flat-square&logo=slack&logoColor=8ec07c)](https://slack.com/)
[![Zoom](https://img.shields.io/badge/Zoom-1d2021?style=flat-square&logo=zoom&logoColor=83a598)](https://zoom.us/)

[![Excel](https://img.shields.io/badge/Excel-1d2021?style=flat-square&logo=microsoftexcel&logoColor=b8bb26)](https://www.microsoft.com/microsoft-365/excel)
[![OneNote](https://img.shields.io/badge/OneNote-1d2021?style=flat-square&logo=microsoftonenote&logoColor=d3869b)](https://www.microsoft.com/microsoft-365/onenote)
[![PowerPoint](https://img.shields.io/badge/PowerPoint-1d2021?style=flat-square&logo=microsoftpowerpoint&logoColor=fe8019)](https://www.microsoft.com/microsoft-365/powerpoint)
[![Word](https://img.shields.io/badge/Word-1d2021?style=flat-square&logo=microsoftword&logoColor=83a598)](https://www.microsoft.com/microsoft-365/word)
[![OneDrive](https://img.shields.io/badge/OneDrive-1d2021?style=flat-square&logo=microsoftonedrive&logoColor=83a598)](https://www.microsoft.com/microsoft-365/onedrive)

### 🔒 Security & Privacy

[![Proton Drive](https://img.shields.io/badge/Proton_Drive-1d2021?style=flat-square&logo=proton&logoColor=d3869b)](https://proton.me/drive)
[![Proton Mail](https://img.shields.io/badge/Proton_Mail-1d2021?style=flat-square&logo=protonmail&logoColor=d3869b)](https://proton.me/mail)
[![ProtonVPN](https://img.shields.io/badge/ProtonVPN-1d2021?style=flat-square&logo=protonvpn&logoColor=b8bb26)](https://protonvpn.com/)

---

## 🤓 CLI Tools

[![AWS CLI](https://img.shields.io/badge/awscli-1d2021?style=flat-square&logo=amazonaws&logoColor=fe8019)](https://aws.amazon.com/cli/)
[![Bash](https://img.shields.io/badge/bash-1d2021?style=flat-square&logo=gnubash&logoColor=b8bb26)](https://www.gnu.org/software/bash/)
[![bat](https://img.shields.io/badge/bat-1d2021?style=flat-square&logo=github&logoColor=fabd2f)](https://github.com/sharkdp/bat)
[![fd](https://img.shields.io/badge/fd-1d2021?style=flat-square&logo=github&logoColor=8ec07c)](https://github.com/sharkdp/fd)
[![Fish](https://img.shields.io/badge/fish-1d2021?style=flat-square&logo=fish&logoColor=fb4934)](https://fishshell.com/)
[![fzf](https://img.shields.io/badge/fzf-1d2021?style=flat-square&logo=github&logoColor=d3869b)](https://github.com/junegunn/fzf)
[![GitHub CLI](https://img.shields.io/badge/gh-1d2021?style=flat-square&logo=github&logoColor=ebdbb2)](https://cli.github.com/)
[![Git](https://img.shields.io/badge/git-1d2021?style=flat-square&logo=git&logoColor=fe8019)](https://git-scm.com/)
[![Go](https://img.shields.io/badge/go-1d2021?style=flat-square&logo=go&logoColor=83a598)](https://go.dev/)
[![LazyGit](https://img.shields.io/badge/lazygit-1d2021?style=flat-square&logo=git&logoColor=8ec07c)](https://github.com/jesseduffield/lazygit)
[![lsd](https://img.shields.io/badge/lsd-1d2021?style=flat-square&logo=github&logoColor=fabd2f)](https://github.com/lsd-rs/lsd)
[![neofetch](https://img.shields.io/badge/neofetch-1d2021?style=flat-square&logo=github&logoColor=d3869b)](https://github.com/dylanaraps/neofetch)
[![Neovim](https://img.shields.io/badge/neovim-1d2021?style=flat-square&logo=neovim&logoColor=b8bb26)](https://neovim.io/)
[![nvm](https://img.shields.io/badge/nvm-1d2021?style=flat-square&logo=nodedotjs&logoColor=b8bb26)](https://github.com/nvm-sh/nvm)
[![ripgrep](https://img.shields.io/badge/ripgrep-1d2021?style=flat-square&logo=github&logoColor=8ec07c)](https://github.com/BurntSushi/ripgrep)
[![Starship](https://img.shields.io/badge/starship-1d2021?style=flat-square&logo=starship&logoColor=fabd2f)](https://starship.rs/)
[![Terraform](https://img.shields.io/badge/terraform-1d2021?style=flat-square&logo=terraform&logoColor=d3869b)](https://www.terraform.io/)
[![tmux](https://img.shields.io/badge/tmux-1d2021?style=flat-square&logo=tmux&logoColor=b8bb26)](https://github.com/tmux/tmux)
[![tree](https://img.shields.io/badge/tree-1d2021?style=flat-square&logo=gnubash&logoColor=8ec07c)](https://linux.die.net/man/1/tree)
[![Yazi](https://img.shields.io/badge/yazi-1d2021?style=flat-square&logo=github&logoColor=fabd2f)](https://yazi-rs.github.io/)
[![yamllint](https://img.shields.io/badge/yamllint-1d2021?style=flat-square&logo=yaml&logoColor=fb4934)](https://github.com/adrienverge/yamllint)
[![Zellij](https://img.shields.io/badge/zellij-1d2021?style=flat-square&logo=github&logoColor=fe8019)](https://zellij.dev/)
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
