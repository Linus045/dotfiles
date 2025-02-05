#!/bin/bash

background_path="${HOME}/.wallpapers/videos/"
DELAY=600


# Send a USR1 signal to trigger wallpaper change
# e.g. 'pkill -SIGUSR1 set_random_vide' (this file is called set_random_video_wallpaper.sh)

change_wallpaper() {
	# disable trap until we are done
	trap USR1

	if [ ! -z $sleep_id ]; then
		echo "Killing sleep process"
		kill $sleep_id
	fi

	wallpaper="$1"
	echo "$1"
	if [ -z "$wallpaper" ] || [ ! -f "$wallpaper" ]; then
		wallpaper="$(ls "$background_path" | grep -E '\.(mp4|mkv)$' | shuf -n 1)"
		echo "Selected new random video"
	else
		background_path=""
		echo "Used $1 as live wallpaper"
	fi


	random_display=$(xrandr --listactivemonitors | awk '{print $4}' | sed '/^$/d' | awk '{$1=$1;print}' | shuf -n1)

	# change background
	if [[ $XDG_SESSION_TYPE = "wayland" ]]; then
		pkill -f "mpvpaper.+$random_display" -KILL
		mpvpaper -o "no-audio hwdec=auto --loop-playlist shuffle" $random_display "$background_path$wallpaper" &
	else
		notify-send "Failed to set live wallpaper. Not on wayland"
	fi


	if [[ $? == 0 ]]; then
		echo "$background_path$wallpaper" > ~/.polybar_current_live_wallpaper_path
		/usr/bin/notify-send --app-name="Wallpaper Changer" "Wallpaper: $wallpaper on $random_display"
	else
		/usr/bin/notify-send --app-name="Wallpaper Changer" "Error setting wallpaper!"
	fi

	# enable trap again
	trap change_wallpaper USR1
}

trap change_wallpaper USR1


while true; do
	change_wallpaper "$1"

	sleep $DELAY &
	sleep_id=$!
	wait $sleep_id
done

trap USR1
