background_path="${HOME}/.wallpapers"


wallpaper=$(ls $background_path | grep '\.jpg$\|\.jpeg$\|\.png$' | shuf -n 1)

#echo $wallpaper

# use wal-theme picker to get best theme for background
#theme=$(python ~/aur/wal-theme-picker/wal-theme-picker.py -n 1 -c 5 "$background_path/$wallpaper" | grep '0)' | awk '{print $2}')


# change background
feh --bg-fill "$background_path/$wallpaper"
# uncomment to also change console theme
#wal -e --theme $theme > /dev/null

/usr/bin/notify-send --app-name="Wallpaper Changer" "Wallpaper: $wallpaper"
