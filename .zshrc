if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git web-search zsh-autosuggestions zsh-syntax-highlighting web-search)
source $ZSH/oh-my-zsh.sh
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Go Setup
export GOPATH=$HOME/go # in home dir create dir called go and where everything is gonna go in there.
export PATH=$PATH:$GOPATH/bin # Adding to my path and path is stuff I can run from my term and concatinating in go/bin all in my path to be useable

# Example aliases
alias n="nvim"
alias zj="zellij"
alias eng="cd Desktop/Engineering"
alias g="git"
alias gs="git status"
alias ga="git add ."
alias zrc="code ~/.zshrc"
alias szrc="source ~/.zshrc"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
. "/Users/zion/.deno/env"
