#zsh config dir
export TERMINAL=kitty
export ZDOTDIR=$HOME/.config/zsh

source ~/.config/zsh/.zshrc
[ -f $HOME/.cargo/env ] && source "$HOME/.cargo/env"

# this is required for gpg signing (used for github)
export GPG_TTY=$(tty)
