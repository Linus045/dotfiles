


#mode "drawing" {
# bindsym $mod+b exec "sleep 0.5; gromit-mpx -v"
#   bindsym Escape mode "default"; exec "sleep 0.5; gromit-mpx -t -v"
#   # bindsym Return mode "default";
# }

# if gromit is not running start it
# also automatically press F9 after starting
# bindsym $mod+b mode "drawing"; exec "gromit-mpx -v -t 0";:e 

# bindsym $mod+r mode "resize"

#dmenu which contains all programs


gromit_running=$(ps aux | grep -E "(^|\s)gromit-mpx(\s|$)" | grep -v grep)
echo $gromit_running

case "$1" in
  start)
    echo "Start passed"
    if [ -z "$gromit_running" ]; then
      notify-send "Gromit" "Gromit is not running. Starting up..."
      gromit-mpx -a > /dev/null &
    else
      notify-send "Gromit" "Gromit is running";
      gromit-mpx -v
      gromit-mpx -t 0
    fi
    ;;
  stop)
    notify-send "Gromit" "Stopping..."
    gromit-mpx -q
    ;;
  undo)
    notify-send "Gromit" "Undo"
    gromit-mpx -z
    ;;
  redo)
    notify-send "Gromit" "Redo"
    gromit-mpx -y
    ;;
  clear)
    notify-send "Gromit" "Cleared screen"
    gromit-mpx -c
    ;;
  visible)
    notify-send "Gromit" "Changed visibility"
    gromit-mpx -v
    ;;
  pen)
    notify-send "Gromit" "Toggled pen"
    gromit-mpx -t 0
    ;;
  *) ;;
esac

# echo "dbus-launch ${dbus_args[*]}"


