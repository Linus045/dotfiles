#zsh config dir
export TERMINAL=kitty
export ZDOTDIR=$HOME/.config/zsh

source ~/.config/zsh/.zshrc
[ -f $HOME/.cargo/env ] && source "$HOME/.cargo/env"
export PATH="/opt/cuda/bin":$PATH

# this is required for gpg signing (used for github)
export GPG_TTY=$(tty)

# add local stuff here wont be tracked in dotfiles)
[ -f "$HOME/.zshenv.local" ] && source "$HOME/.zshenv.local"
