#!/bin/sh


# grab current open workspace
# https://www.reddit.com/r/i3wm/comments/kk74ef/simple_way_to_print_i3s_current_workspace_in/
current_workspace=$(i3-msg -t get_workspaces | jq '.[] | select(.focused).num')

# move workspaces to correct monitor
i3-msg "workspace 1, move workspace to output HDMI-0"
i3-msg "workspace 2, move workspace to output HDMI-0"
i3-msg "workspace 3, move workspace to output DP-5"
i3-msg "workspace 4, move workspace to output DP-5"
i3-msg "workspace 5, move workspace to output DP-5"
i3-msg "workspace 6, move workspace to output DP-5"
i3-msg "workspace 7, move workspace to output DP-5"
i3-msg "workspace 8, move workspace to output DP-5"
i3-msg "workspace 9, move workspace to output DP-5"



# for_window [ class="Zathura" workspace="1" Title="/home/linus/dev/rust_seminar/.*\.pdf" ] floating enable, resize set 830 1397, move position 3175 34;
# for_window [ class="kitty" workspace="1" Title="tmuxstart" ] floating enable, move position 1929 34, resize set 1240 1397;
i3-msg '[ class="kitty" workspace="1" Title="tmuxstart" ] workspace 1, floating enable, move position 1929 34, resize set 2070 1397;'
i3-msg '[ class="firefox" workspace="2" Title="^(?!Linus045 - Chat - Twitch — Mozilla Firefox)" ] floating enable, move position 1929 34, resize set 2070 1397;'

# with camera
#i3-msg '[ class="firefox" Title="Linus045 - Chat - Twitch — Mozilla Firefox" ] fullscreen disable, sticky enable, border none, floating enable, move position 4011px 34, resize set 300px 1145px;'

# without camera
i3-msg '[ class="firefox" Title="Linus045 - Chat - Twitch — Mozilla Firefox" ] fullscreen disable, sticky enable, border none, floating enable, move position 4011px 34, resize set 300px 1397px;'


# move back to workspace
i3-msg "workspace $current_workspace"
