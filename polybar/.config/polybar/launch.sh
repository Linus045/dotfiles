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

# detects the default network interface (for the network module)
# see: https://github.com/polybar/polybar/issues/339#issuecomment-447674287
export DEFAULT_NETWORK_INTERFACE=$(ip route | grep '^default' | awk '{print $5}' | head -n1)

# set the correct icon for the network module (idk if there is a better way to do this)
#  󰈁 󰈂  󰖪
if [[ $DEFAULT_NETWORK_INTERFACE =~ "enp" ]]; then
  echo "wired"
  export DEFAULT_NETWORK_INTERFACE_CONNECTED_ICON='<label-connected>󰈁'
  export DEFAULT_NETWORK_INTERFACE_DISCONNECTED_ICON='<label-disconnected>󰈂'
else
  echo "wireless"
  export DEFAULT_NETWORK_INTERFACE_CONNECTED_ICON='<label-connected>'
  export DEFAULT_NETWORK_INTERFACE_DISCONNECTED_ICON='<label-disconnected>󰖪'
fi

# Manage multiple monitors
for m in $(polybar --list-monitors | cut -d":" -f1); do
  # use top_i3 bar if i3 is used (it has other logout config and stuff)
  if [ $I3ENABLED = 1 ]; then
	if [ $m == "eDP" ]; then
	  MONITOR=$m polybar --reload top_i3_laptop
	# TODO: set correct monitor for tower pc
	elif [ $m == "HDMI-0" ]; then
	  MONITOR=$m polybar --reload top_i3_tower
	else
	  MONITOR=$m polybar --reload top_i3_secondary_monitor
	fi
  fi
done
