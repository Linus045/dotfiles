#!/bin/env bash

# Terminate already running bars
killall -q --signal KILL polybar

# Wait until bars have been terminated
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar
# polybar top &)
# i3 when i3 is used or xfce depending on the current window manager
#echo $XDG_CURRENT_DESKTOP
# $XDG_CURRENT_DESKTOP is set by sddm i believe
I3ENABLED=0;
if [ "i3" = "$XDG_CURRENT_DESKTOP" ]; then
  I3ENABLED=1
fi

# Manage multiple monitors
for m in $(polybar --list-monitors | cut -d":" -f1); do
  # use top_i3 bar if i3 is used (it has other logout config and stuff)
  if [ $I3ENABLED = 1 ]; then
	if [ $m == "eDP" ]; then
	  MONITOR=$m polybar --reload top_i3_main 2> ~/.polybar_errorlog_$m &
	elif [ $m == "HDMI-0" ]; then
	  MONITOR=$m polybar --reload single_monitor
	else
	  MONITOR=$m polybar --reload top_i3 2> ~/.polybar_errorlog_$m &
	fi
  fi
done
