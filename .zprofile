# Homebrew uses different locations on Apple Silicon and Intel Macs.
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi
[[ ! -r "$HOME/.zprofile.local" ]] || source "$HOME/.zprofile.local"
