background_path="${HOME}/.wallpapers/"

wallpaper=$1
if [ -z $wallpaper ] || [ ! -f $wallpaper ]; then
	wallpaper=$(ls $background_path | grep '\.jpg$\|\.jpeg$\|\.png$' | shuf -n 1)
	echo "Selected new random wallpaper"
else
	background_path=""
	echo "Used $1 as wallpaper"
fi


#echo $wallpaper

# use wal-theme picker to get best theme for background
#theme=$(python ~/aur/wal-theme-picker/wal-theme-picker.py -n 1 -c 5 "$background_path/$wallpaper" | grep '0)' | awk '{print $2}')


# change background
if [[ $XDG_SESSION_TYPE = "wayland" ]]; then
	swww-daemon
	swww img --transition-type random "$background_path$wallpaper"
else
	feh --bg-fill "$background_path$wallpaper"
fi

if [[ $? == 0 ]]; then
	echo "$background_path$wallpaper" > ~/.polybar_current_wallpaper_path
	/usr/bin/notify-send --app-name="Wallpaper Changer" "Wallpaper: $wallpaper"
else
	/usr/bin/notify-send --app-name="Wallpaper Changer" "Error setting wallpaper!"
fi
# uncomment to also change console theme
#wal -e --theme $theme > /dev/null

