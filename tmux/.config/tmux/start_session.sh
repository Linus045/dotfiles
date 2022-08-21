connected=$(tmux attach -t dev)

# if connected, then exit
if [ -n "$connected" ]; then
    exit 0
fi

tmux new-session -s "dev" -d -n "terminal"

# nvim in project directory
tmux new-window -t dev -da -n "dev"
tmux select-window -t dev:dev
tmux send-keys -t dev:dev "cd ~/dev && nvim" Enter
tmux move-window -t 2

# fun stuff
# tmux new-window -t dev -da -n "aquarium" "asciiquarium"
# tmux select-window -t dev:aquarium
# tmux move-window -t 7

# dotfiles
# tmux new-window -t dev -da -n "dotfiles" "cd ~/dotfiles && nvim"
# tmux select-window -t dev:dotfiles
# tmux move-window -t 8

# Dev Journal
# tmux new-window -t dev -da -n "nvim_journal" "cd && nvim ~/.nvim_journal"
# tmux select-window -t dev:nvim_journal
# tmux move-window -t 9

tmux select-window -t dev:dev

tmux attach -t dev
# tmux kill-session -t dev
