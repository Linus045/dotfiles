#!/bin/bash

# This is an overcomplicated as shit script to listen for DBus events
# when flameshot makes a screenshot it calls a notify event on the dbus, we listen for that and then show a custom
# notify message to open it in feh, we also beforehand register a i3 monitor to make the window floating
# I prefer this over the i3 for_window configs because it only makes these feh windows floating


destination=org.freedesktop.Notifications
member=Notify

# Example output:
# method call time=1683136299.314748 sender=:1.33799 -> destination=org.freedesktop.Notifications serial=12 path=/org/freedesktop/Notifications; interface=org.freedesktop.Notifications; member=Notify
#    string "flameshot"
#    uint32 0
#    string "flameshot"
#    string "Flameshot Info"
#    string "Capture saved as /home/linus/.screenshots/2023-05-03_19-51.png"
#    array [
#    ]
#    array [
#       dict entry(
#          string "x-kde-urls"
#          variant             array [
#                string "file:///home/linus/.screenshots/2023-05-03_19-51.png"
#             ]
#       )
#    ]
#    int32 5000


flameshot_found=false

dbus-monitor --monitor "destination='$destination',member='$member'" |
  while read -r line; do
  if [[ "$line" =~ "string \"flameshot\"" ]]; then
	flameshot_found=true	
  fi
  if $flameshot_found && [[ "$line" =~ "string \"Capture saved as" ]]; then
	file_path=$(echo "$line" | sed -n 's/.*string \"Capture saved as \(.*\)\"/\1/p')
	action=$(notify-send "Feh" "Click to open $file_path in feh" --action="open"="Open in feh" --action="close"="Close" -u low) 

	if [[ "$action" =~ "open" ]]; then
	  i3-msg -t subscribe -m '[ "window" ]' | awk '/"change":"new".+"class":"feh"/ { print $1; system("i3-msg floating enable") }' &
	  last_pid=$!
	  echo "Spawned i3-msg subscriber PID: $last_pid"
	  feh $file_path &
	  sleep 1
	  if [[ $last_pid != "" ]]; then
		  echo "Killing $last_pid"
		  kill $last_pid
	  fi
	fi
	flameshot_found=false
  fi


done

