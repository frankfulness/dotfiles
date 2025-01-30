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

# Aliases

# Machine / Terminal
alias n="nvim"
alias zj="zellij"
alias eng="cd Desktop/Engineering"

# Git
alias g="git"
alias gs="git status"
alias ga="git add ."
alias gm="git commit -m "
alias gp="git push"
alias gpl="git pull"
alias gr="git rebase -i dev"

# Zsh/Bash
alias zshrc="n ~/.zshrc"
alias srczsh="source ~/.zshrc"

# Terraform
alias tfi="terraform init"
alias tfa="terraform apply"
alias tfp="terraform plan"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
. "/Users/zion/.deno/env"
