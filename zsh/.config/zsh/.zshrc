
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#!/bin/sh

# Use powerline
#USE_POWERLINE="true"
# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi


# load nvm versions for nvim github copilot
# export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

source /usr/share/nvm/init-nvm.sh

HISTFILE=~/.zsh_history
HISTTIMEFORMAT="%d.%m.%y %T "
HISTSIZE=200000
HISTFILESIZE=200000
setopt appendhistory
setopt extendedhistory


# to show history in zsh's fzf reverse search see:
# https://github.com/junegunn/fzf/issues/1308
# sudo -e /usr/share/fzf/key-bindings.zsh
# add -i option to the fc command  in line 100

# like so here:       V see here
#   selected=( $(fc -ril 1 | perl -ne 'print if !$seen{(/^\s*[0-9]+\**\s+(.*)/, $1)}++' | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort,ctrl-z:ignore $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" $(__fzfcmd)) )


# some useful options (man zshoptions)
setopt autocd #cd automatically when entering a path
setopt extendedglob nomatch menucomplete
setopt interactive_comments
setopt complete_aliases

# we need the <$TTY >$TTY stuff here due to instant Prompt
# see https://github.com/romkatv/powerlevel10k/issues/388
stty stop undef <$TTY >$TTY       # Disable ctrl-s to freeze terminal.
zle_highlight=('paste:none')

# beeping is annoying
unsetopt BEEP

# completions
autoload -Uz compinit
_comp_options+=(globdots)		# Include hidden files.
compinit

# Do menu-driven completion.
zstyle ':completion:*' menu select

# Color completion for some things.
# http://linuxshellaccount.blogspot.com/2008/12/color-completion-using-zsh-modules-on.html
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion::complete:lsof:*' menu yes select

# formatting and messages
# http://www.masterzen.fr/2009/04/19/in-love-with-zsh-part-one/
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format "$fg[yellow]%B--- %d%b"
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format "$fg[red]No matches for:$reset_color %d"
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

zmodload zsh/complist

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Colors
autoload -Uz colors && colors

# Useful Functions
source "$ZDOTDIR/zsh-functions"

# Normal files to source
zsh_add_file "zsh-exports"
zsh_add_file "zsh-vim-mode"
zsh_add_file "zsh-aliases"
zsh_add_file "zsh-prompt"
zsh_add_file "zsh-user-functions"

# Plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "hlissner/zsh-autopair"
# zsh_add_completion "esc/conda-zsh-completion" false
# For more plugins: https://github.com/unixorn/awesome-zsh-plugins
# More completions https://github.com/zsh-users/zsh-completions

# Key-bindings
# bindkey -s '^o' 'ranger^M'
# bindkey -s '^f' 'zi^M'
# bindkey -s '^s' 'ncdu^M'
# bindkey -s '^n' 'nvim $(fzf)^M'
# bindkey -s '^v' 'nvim\n'
# bindkey -s '^z' 'zi^M'
# bindkey '^[[P' delete-char
#bindkey "^p" up-line-or-beginning-search # Up
#bindkey "^n" down-line-or-beginning-search # Down
#bindkey "^k" up-line-or-beginning-search # Up
#bindkey "^j" down-line-or-beginning-search # Down
#bindkey -r "^u"
#bindkey -r "^d"
bindkey  "^[[3~"  delete-char
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# FZF 
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f $ZDOTDIR/completion/_fnm ] && fpath+="$ZDOTDIR/completion/"
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'

# Bind caps to escape
setxkbmap -option caps:escape
# swap escape and caps
# setxkbmap -option caps:swapescape

# faster keys see "man xset" 
# r rate <delay> <rate>
xset r rate 210 50
# xset r rate 210 5

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# load color scheme from image
# -n so it doesn't set wallpaper background
# NOTE: now set in .xprofile to run on startup
# wal -i ~/background.png -n -q

# make sure to load the last theme if it was changed automatically
# -e to not reload i3
# wal -a 0 -e -R > /dev/null

typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
curl --max-time 1 -s "https://wttr.in/?lang=de&format=%C+%t+%w" | cowsay -f stegosaurus


zshstartup
