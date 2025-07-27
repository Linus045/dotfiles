connected=$(tmux attach -t dev)

# if connected, then exit
if [ -n "$connected" ]; then
    exit 0
fi

tmux new-session -s "dev" -d -n "terminal"
tmux move-window -t 2

# nvim in project directory
# tmux new-window -t dev -da -n "dev"
# tmux select-window -t dev:dev
# tmux send-keys -t dev:dev "cd ~" Enter
# tmux move-window -t 2

# nvim in project directory
tmux new-window -da -c "$PWD" -n "nvim" -t dev
tmux select-window -t dev:nvim
tmux send-keys -t dev:nvim "nvim" Enter
tmux move-window -t 1

# bachelorarbeit
# dotfiles
# tmux new-window -t dev -da -n "dotfiles" "cd ~/dotfiles && nvim"
# tmux select-window -t dev:dotfiles
# tmux move-window -t 8

# Dev Journal
# tmux new-window -da -c "~/.nvim_journal" -n "nvim_journal" -t dev
# tmux select-window -t dev:nvim_journal
# tmux send-keys -t dev:nvim_journal "z nvim_journal && nvim" Enter
# tmux move-window -t 9

tmux select-window -t dev:nvim

tmux attach -t dev
# tmux kill-session -t dev
