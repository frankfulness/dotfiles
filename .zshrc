# Portable interactive shell. Private overrides belong in ~/.zshrc.local.
# Configs are copied, not symlinked: local edits never silently change the repo.
if ! command -v brew >/dev/null 2>&1; then
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git web-search)
[[ ! -r "$ZSH/oh-my-zsh.sh" ]] || source "$ZSH/oh-my-zsh.sh"
typeset -U path
path=("$HOME/.local/bin" "$HOME/go/bin" $path)
export BAT_THEME=gruvbox-dark
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
[[ ! -s "$NVM_DIR/nvm.sh" ]] || source "$NVM_DIR/nvm.sh"
[[ ! -r "$HOME/.deno/env" ]] || source "$HOME/.deno/env"

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_SPACE HIST_IGNORE_DUPS SHARE_HISTORY
bindkey -e
bindkey -s '^f' 'fg\n'

alias c='clear'
alias q='exit'
alias src='source ~/.zshrc'
alias zshrc='${EDITOR:-vi} ~/.zshrc'
alias tr='tree -I node_modules'
alias up='cd ..'
alias up2='cd ../..'
alias up3='cd ../../..'
alias conf='cd ~/.config'
alias f='fg'
alias p='cd ~/Desktop/PARA'
alias projects='cd ~/Desktop/PARA/1-projects'
alias areas='cd ~/Desktop/PARA/2-areas'
alias resources='cd ~/Desktop/PARA/3-resources'
alias archive='cd ~/Desktop/PARA/4-archive'
alias ve='python3 -m venv ./venv'
alias va='source ./venv/bin/activate'
alias vq='deactivate'
alias g='git'
alias gs='git status'
alias ga='git add .'
alias gm='git commit -m'
alias gp='git push'
alias glog='git log --oneline'
alias grs='git reset --soft HEAD~1'
alias stash='git stash push -m'
gpl() { git pull origin "$(git branch --show-current)"; }

# Optional tools are never required just to open a terminal.
if command -v nvim >/dev/null 2>&1; then
    alias vim='nvim'
fi
if command -v go >/dev/null 2>&1; then
    alias grun='go run'
    alias gver='go version'
fi
if command -v terraform >/dev/null 2>&1; then
    alias tf='terraform'
    alias tfi='terraform init'
    alias tfp='terraform plan'
    alias tfa='terraform apply'
    alias tff='terraform fmt'
fi
if command -v claude >/dev/null 2>&1; then
    alias cc='claude'
    alias cco='claude --model opus'
    alias ccs='claude --model sonnet'
    alias ccr='claude --resume'
fi

if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type=d --hidden --strip-cwd-prefix --exclude .git'
    _fzf_compgen_path() { fd --hidden --exclude .git . "$1"; }
    _fzf_compgen_dir() { fd --type=d --hidden --exclude .git . "$1"; }
fi
export FZF_DEFAULT_OPTS='--color=fg:#CBE0F0,bg:#011628,hl:#B388FF,fg+:#CBE0F0,bg+:#143652,hl+:#B388FF,info:#06BCE4,prompt:#2CF9ED,pointer:#2CF9ED,marker:#2CF9ED,spinner:#2CF9ED,header:#2CF9ED'
export FZF_CTRL_T_OPTS="--preview 'if [ -d {} ]; then eza --tree --level=3 --color=always {}; else bat -n --color=always --line-range :500 {}; fi'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=3 --color=always {}'"
command -v fzf >/dev/null 2>&1 && eval "$(fzf --zsh)"
[[ ! -r "$HOME/fzf-git.sh/fzf-git.sh" ]] || source "$HOME/fzf-git.sh/fzf-git.sh"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

if command -v brew >/dev/null 2>&1; then
    _brew_prefix="$(brew --prefix)"
    [[ ! -r "$_brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] ||
        source "$_brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi
# Load private overrides before syntax highlighting (which should be last).
[[ ! -r "$HOME/.zshrc.local" ]] || source "$HOME/.zshrc.local"
if [[ -n "${_brew_prefix:-}" && -r "$_brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "$_brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
unset _brew_prefix
