#!/bin/bash

background_path="${HOME}/.wallpapers/videos/"
DELAY=600


# Send a USR1 signal to trigger wallpaper change
# e.g. 'pkill -SIGUSR1 set_random_vide' (this file is called set_random_video_wallpaper.sh)

change_wallpaper() {
	wallpaper=$1
	if [ -z $wallpaper ] || [ ! -f $wallpaper ]; then
		wallpaper=$(ls $background_path | grep '\.mp4$' | shuf -n 1)
		echo "Selected new random video"
	else
		background_path=""
		echo "Used $1 as live wallpaper"
	fi


	random_display=$(xrandr --listactivemonitors | awk '{print $4}' | sed '/^$/d' | awk '{$1=$1;print}' | shuf -n1)

	# change background
	if [[ $XDG_SESSION_TYPE = "wayland" ]]; then
		current_id=$(pkill -f "mpvpaper.+$random_display")
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
}

trap change_wallpaper USR1


while true; do
	change_wallpaper

	sleep $DELAY &
	wait $!
done

trap USR1
