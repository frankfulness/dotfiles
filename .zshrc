# ╔═══════════════════════════════════════════════════════════════╗
# ║                     OH-MY-ZSH & THEME                         ║
# ╚═══════════════════════════════════════════════════════════════╝
export ZSH="$HOME/.oh-my-zsh"
plugins=(git web-search zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# ╔═══════════════════════════════════════════════════════════════╗
# ║                     ENVIRONMENT VARIABLES                     ║
# ╚═══════════════════════════════════════════════════════════════╝
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
. "/Users/zion/.deno/env"

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.govm/shim:$PATH"
export GOROOT="$HOME/.govm/versions/go1.24.6"
export PATH=$PATH:$(go env GOPATH)/bin

export BAT_THEME=gruvbox-dark

# Claude API key from macOS Keychain
export ANTHROPIC_API_KEY=$(security find-generic-password -a "$USER" -s "anthropic-api-key" -w 2>/dev/null)

# ╔═══════════════════════════════════════════════════════════════╗
# ║                     SHELL ALIASES                             ║
# ╚═══════════════════════════════════════════════════════════════╝
alias vim="nvim"
alias zj="zellij"
alias zshrc="vim ~/.zshrc"
alias src="source ~/.zshrc"
alias c="clear"
alias q="exit"
alias btw="neofetch"
alias tr='tree -I "node_modules"'
alias up="cd .."
alias up2="cd ../../"
alias up3="cd ../../../"
alias conf="cd ~/.config"

# ╔═══════════════════════════════════════════════════════════════╗
# ║                     NAVIGATION ALIASES                        ║
# ╚═══════════════════════════════════════════════════════════════╝
alias p="cd ~ && cd Desktop/PARA"
alias sb="cd ~ && cd Desktop/PARA/2\ Areas/writing/cerebro"
alias tech="cd ~ && cd Desktop/PARA/2\ Areas/tech"
alias learn="cd ~ && cd Desktop/PARA/2\ Areas/tech/learn"
alias ops="cd ~ && cd Desktop/PARA/2\ Areas/devops"
alias godev="cd ~ && cd Desktop/PARA/2\ Areas/tech/learn/go"
alias ws="cd ~/Desktop/PARA/2\ Areas/tech/workspace"
alias playful="cd ~/Desktop/PARA/2\ Areas/tech/workspace/opensource/playfulprogramming"
alias vids="cd ~/Desktop/PARA/0\ Inbox/Screen\ Recordings && open ."
alias work="cd ~ && cd Desktop/PARA/2\ Areas/work"
alias agi="cd ~ && cd Desktop/PARA/2\ Areas/work/agilitycredit"
alias myblog="z blog/data/blog"

# ╔═══════════════════════════════════════════════════════════════╗
# ║                     PYTHON ALIASES                            ║
# ╚═══════════════════════════════════════════════════════════════╝
alias ve="python3 -m venv ./venv"
alias va="source ./venv/bin/activate"
alias vq="deactivate"

# ╔═══════════════════════════════════════════════════════════════╗
# ║                     GIT ALIASES                               ║
# ╚═══════════════════════════════════════════════════════════════╝
alias g="git"
alias gs="git status"
alias ga="git add ."
alias gm="git commit -m "
alias gp="git push"
alias gpl="git pull"
alias glog="git log --oneline"
alias gr="git rebase -i dev"
alias grs="git reset --soft HEAD~1"
alias grh="git reset --hard HEAD~1"
alias stash="git stash push -m"
unalias apply 2>/dev/null
apply() { git stash apply "stash^{/$1}"; }

# ╔═══════════════════════════════════════════════════════════════╗
# ║                     GO ALIASES                                ║
# ╚═══════════════════════════════════════════════════════════════╝
alias grun="go run"
alias gv="govm"
alias gver="go version"

# ╔═══════════════════════════════════════════════════════════════╗
# ║                     TERRAFORM ALIASES                         ║
# ╚═══════════════════════════════════════════════════════════════╝
alias tf="terraform"
alias tfi="terraform init"
alias tfa="terraform apply"
alias tfp="terraform plan"
alias tfc="terraform console"
alias tfd="terraform destroy"
alias tff="terraform fmt"
alias tfg="terraform graph"
alias tfim="terraform import"

# ╔═══════════════════════════════════════════════════════════════╗
# ║                     CLAUDE CODE ALIASES                       ║
# ╚═══════════════════════════════════════════════════════════════╝
alias cc="claude"
alias cco="claude --model opus"
alias ccs="claude --model sonnet"
alias ccr="claude --resume"
alias ccl="claude --resume --list"

# ╔═══════════════════════════════════════════════════════════════╗
# ║                     OPENCODE / AI ALIASES                     ║
# ╚═══════════════════════════════════════════════════════════════╝
alias ai='noglob _ai_func'
function _ai_func { opencode --prompt "$*"; }

alias aii='noglob _aii_func'
function _aii_func { opencode "$*"; }

alias aiq='noglob _aiq_func'
function _aiq_func { opencode run "$*"; }

# ╔═══════════════════════════════════════════════════════════════╗
# ║                     MACOS / WINDOW MANAGEMENT                 ║
# ╚═══════════════════════════════════════════════════════════════╝
alias qf='osascript -e "tell application \"Finder\" to close every window"'
alias rsa="brew services restart sketchybar && killall AeroSpace && sleep 2 && open -a AeroSpace"

# AeroSpace window management
alias asw="aerospace list-windows --all"
function asfloat() {
  if [[ -z "$1" ]]; then
    echo "Usage: asfloat <window-id>"
    echo "Run 'asw' to list all window IDs"
    return 1
  fi
  aerospace layout --window-id "$1" floating
}
function astile() {
  if [[ -z "$1" ]]; then
    echo "Usage: astile <window-id>"
    echo "Run 'asw' to list all window IDs"
    return 1
  fi
  aerospace layout --window-id "$1" tiling
}

# JankyBorders (window borders)
alias jankyon="pkill -f borders; brew services restart borders && sleep 1 && borders active_color=0xffffffff inactive_color=0x00ffffff width=5.0 style=round > /dev/null 2>&1 &"
alias jankyoff="pkill -f borders && brew services stop borders"

# Toggle macOS menu bar visibility
alias togglemenu="
if defaults read NSGlobalDomain _HIHideMenuBar 2>/dev/null | grep -q 1; then
    echo \"Showing macOS menu bar...\"
    defaults write NSGlobalDomain _HIHideMenuBar -bool false
else
    echo \"Hiding macOS menu bar...\"
    defaults write NSGlobalDomain _HIHideMenuBar -bool true
fi
killall SystemUIServer 2>/dev/null
echo \"Menu bar toggled! (may take a moment to apply)\"
"

alias showsketchy='
echo "Switching to sketchybar..."
defaults write NSGlobalDomain _HIHideMenuBar -bool true
defaults write com.apple.dock autohide-menu-bar -bool true
osascript -e "tell application \"System Preferences\" to quit"
osascript -e "
tell application \"System Events\"
    tell dock preferences
        set properties to {autohide menu bar: true}
    end tell
end tell
"
killall SystemUIServer 2>/dev/null
killall Dock 2>/dev/null
sleep 2
brew services start felixkratz/formulae/sketchybar
sleep 2
echo "Sketchybar active with menu bar hidden!"
'

alias showmac='
echo "Switching to macOS menu bar..."
brew services stop felixkratz/formulae/sketchybar
sleep 1
defaults write NSGlobalDomain _HIHideMenuBar -bool false
defaults write com.apple.dock autohide-menu-bar -bool false
osascript -e "
tell application \"System Events\"
    tell dock preferences
        set properties to {autohide menu bar: false}
    end tell
end tell
"
killall SystemUIServer 2>/dev/null
killall Dock 2>/dev/null
sleep 1
echo "macOS menu bar restored!"
'

# ╔═══════════════════════════════════════════════════════════════╗
# ║                     FZF CONFIGURATION                         ║
# ╚═══════════════════════════════════════════════════════════════╝
eval "$(fzf --zsh)"

fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

_fzf_compgen_path() { fd --hidden --exclude .git . "$1"; }
_fzf_compgen_dir() { fd --type=d --hidden --exclude .git . "$1"; }

source ~/fzf-git.sh/fzf-git.sh

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

_fzf_comprun() {
  local command=$1
  shift
  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# ╔═══════════════════════════════════════════════════════════════╗
# ║                     ZOXIDE & STARSHIP                         ║
# ╚═══════════════════════════════════════════════════════════════╝
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
bindkey -e

# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                                                                           ║
# ║                          CHEATSHEET FUNCTIONS                             ║
# ║                                                                           ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

# ── FAQ: all aliases at a glance (run first!) ─────────────────
function faq() {
cat <<'CHEAT'
╭──────────────────────────────────────────────────────────╮
│              ALL MY ALIASES  (quick ref)                 │
╰──────────────────────────────────────────────────────────╯

📁 NAVIGATION
   p/sb/tech/learn/ops/godev/work/agi/myblog

🔧 SHELL
   zshrc/src/c/q/btw/tr/up/up2/up3/conf

🔀 GIT
   g/gs/ga/gm/gp/gpl/glog/gr/grs/grh/stash/apply

🐹 GO
   grun/gv/gver

🏗️  TERRAFORM
   tf/tfi/tfa/tfp/tfc/tfd/tff/tfg/tfim

🐍 PYTHON
   ve/va/vq

🖥️  MACOS / WINDOW MGMT
   as/asw/asfloat/astile/rsa/togglemenu/showsketchy/showmac
   jankyon/jankyoff/qf

🤖 AI
   ai/aii/aiq (OpenCode)
   cc/cco/ccs/ccr/ccl/cc-portal/cc-backend/ccp/ccp-fe/ccp-be

📝 CHEATSHEETS
   faq     = this list (all aliases)
   nv      = neovim essentials (files, search, harpoon, LSP)
   vm      = vim motions & editing
   as      = aerospace window management
   nvkeys  = open full keybinds in nvim
CHEAT
}

# ── NEOVIM ESSENTIALS (combined practical reference) ──────────
alias nvkeys="nvim ~/.config/nvim/KEYBINDS.md"

function nv() {
cat <<'CHEAT'
╭──────────────────────────────────────────────────────────╮
│  NEOVIM ESSENTIALS  (SPACE = leader)                    │
│  Tip: press SPACE and wait for which-key!               │
╰──────────────────────────────────────────────────────────╯

📂 FILES (Neo-tree)
   SPACE e         →  toggle file explorer
   a / d / r       →  create / delete / rename (in tree)
   H               →  toggle hidden files

📑 BUFFERS & WINDOWS
   SHIFT-h/l       →  prev / next buffer
   SPACE b d       →  close buffer
   CTRL-h/j/k/l    →  navigate windows
   SPACE w s/v     →  split horizontal / vertical

🔍 SEARCH (Telescope)
   SPACE SPACE     →  find files
   SPACE s g       →  grep across project
   SPACE s w       →  search word under cursor
   SPACE f r       →  recent files
   SPACE f b       →  find buffers
   CTRL-j/k        →  navigate results, ENTER to open

📌 HARPOON (quick file switching)
   SPACE a         →  add file to harpoon
   CTRL-e          →  open harpoon menu
   SPACE h 1-4     →  jump to harpoon file 1-4
   CTRL-p/n        →  prev / next harpoon file

💡 LSP
   K               →  hover docs
   gd / gr         →  go to definition / references
   SPACE c a       →  code actions
   SPACE c r       →  rename symbol
   SPACE c f       →  format
   [ d / ] d       →  prev / next diagnostic

🔀 GIT
   SPACE g g       →  lazygit
   SPACE g b       →  git blame
   ] h / [ h       →  next / prev hunk
CHEAT
}

# ── CORE VIM MOTIONS ──────────────────────────────────────────
function vm() {
cat <<'CHEAT'
╭──────────────────────────────────────────────────────────╮
│               VIM MOTIONS  (the essentials)              │
╰──────────────────────────────────────────────────────────╯

🧠 MODES
   i               →  insert mode (type text)
   v / V / CTRL-v  →  visual / visual line / visual block
   ESC or jk       →  back to normal mode
   :               →  command mode

🚀 MOVEMENT
   h j k l         →  left / down / up / right
   w / W           →  next word / WORD (skip punctuation)
   b / B           →  back word / WORD
   e / E           →  end of word / WORD
   0               →  beginning of line
   ^               →  first non-blank char
   $               →  end of line
   gg / G          →  top / bottom of file
   { / }           →  paragraph up / down
   CTRL-d / CTRL-u →  half-page down / up
   CTRL-f / CTRL-b →  full-page down / up
   %               →  matching bracket
   H / M / L       →  screen top / middle / bottom
   zz / zt / zb    →  center / top / bottom cursor on screen
   :<number>       →  jump to line number

🎯 PRECISE JUMPS
   f<c> / F<c>     →  jump TO char forward / backward
   t<c> / T<c>     →  jump TILL char forward / backward
   ; / ,           →  repeat f/t forward / backward
   / <text>        →  search forward  (n=next, N=prev)
   ? <text>        →  search backward (n=next, N=prev)
   *  / #          →  search word under cursor fwd / back
   CTRL-o / CTRL-i →  jump back / forward in jumplist
   gd              →  go to definition

✏️  OPERATORS (combine with any motion!)
   d + motion      →  delete   (dw, dd, d$, dG, dip)
   c + motion      →  change   (cw, cc, c$, ciw, ci")
   y + motion      →  yank     (yw, yy, y$, yip)
   > / <           →  indent / outdent (visual: > or <)
   =               →  auto-indent (== for line, =ip)
   gu / gU         →  lowercase / uppercase + motion

🔲 TEXT OBJECTS (use with d, c, y, v — i=inner a=around)
   iw / aw         →  word
   i" / a"         →  double quotes      i' / a'  = single
   i( / a(         →  parentheses        i{ / a{  = braces
   i[ / a[         →  brackets           i< / a<  = angle
   it / at         →  HTML/XML tag
   ip / ap         →  paragraph
   if / af         →  function
   ic / ac         →  class

📝 EDITING
   i / a           →  insert before / after cursor
   I / A           →  insert at line start / end
   o / O           →  new line below / above (enters insert)
   r<c>            →  replace single char
   x / X           →  delete char forward / backward
   J               →  join current line with next
   ~               →  toggle case of char
   .               →  repeat last change
   u / CTRL-r      →  undo / redo
   p / P           →  paste after / before
   gcc             →  toggle comment line
   gc              →  toggle comment (visual selection)

💾 SAVE & QUIT
   :w              →  save
   :q              →  quit
   :wq / ZZ        →  save and quit
   :q! / ZQ        →  quit without saving
   SPACE q q       →  quit all (LazyVim)
CHEAT
}

# ── AEROSPACE CHEATSHEET ──────────────────────────────────────
alias as='echo "
╭─────────────────────────────────────────╮
│        AeroSpace Cheatsheet             │
╰─────────────────────────────────────────╯

🧭 Focus:        alt-h/j/k/l
📦 Move:         alt-shift-h/j/k/l
🔧 Resize:       alt-r (then h/j/k/l, esc to exit)
❌ Quit:         cmd-q
🖥️  Workspaces:   alt-1/2/3 (shift to move window)
🪟 Float/Tile:   alt-shift-f / alt-shift-t
"'
