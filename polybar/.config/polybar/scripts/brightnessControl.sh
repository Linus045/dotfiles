#!/usr/bin/env bash

# https://gist.github.com/Blaradox/030f06d165a82583ae817ee954438f2e
# Slightly modified to work with my setup


# You can call this script like this:
# $ ./brightnessControl.sh up
# $ ./brightnessControl.sh down
# $ ./brightnessControl.sh notify

# Script inspired by these wonderful people:
# https://github.com/dastorm/volume-notification-dunst/blob/master/volume.sh
# https://gist.github.com/sebastiencs/5d7227f388d93374cebdf72e783fbd6a

function get_brightness {
  current=$(brightnessctl -q get)
  max=$(brightnessctl -q max)
  printf %.0f "$(( 10**2 * 100 * (current+1) / max ))e-2"
}

function send_notification {
  icon="preferences-system-brightness-lock"
  brightness=$(get_brightness)
  # Make the bar with the special character
  bar=$(seq -s "" 0 $((brightness / 3)) | sed 's/[0-9]//g')
  # Send the notification
  dunstify -i "$icon" -r 5555 -t 500 -u normal "$(get_brightness)%       $bar"
}

case $1 in
  notify)
    send_notification
    ;;
  up)
    if [[ $(get_brightness) -lt 100 ]]; then
      # increase the backlight by 5%
      brightnessctl -q set +5%
      send_notification
    fi
    ;;
  down)
    if [[ $(get_brightness) -gt 0 ]]; then
      # decrease the backlight by 5%
      brightnessctl -q set 5%-
      send_notification
    fi
    ;;
esac
