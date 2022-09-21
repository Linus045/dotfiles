#!/bin/env bash
background1=$(ls -1 ~/.wallpapers | grep "png$\|jpeg$\|jpg$" | shuf -n 1)
background2=$(ls -1 ~/.wallpapers | grep "png$\|jpeg$\|jpg$" | shuf -n 1)

SCREEN_RESOLUTION1="$(xrandr | grep '*' | awk '{ print $1 }' | sed -n '2p')"
SCREEN_RESOLUTION2="$(xrandr | grep '*' | awk '{ print $1 }' | sed -n '1p')"
# BGCOLOR="FFFFFF"
echo $SCREEN_RESOLUTION1
echo $SCREEN_RESOLUTION2

rm ~/.lockscreen.png
rm ~/.lockscreen_1.png
rm ~/.lockscreen_2.png

convert ~/.wallpapers/$background1 -resize "$SCREEN_RESOLUTION1" -background black -gravity Center ~/.lockscreen_1.png 
convert ~/.wallpapers/$background2 -resize "$SCREEN_RESOLUTION2" -background black -gravity West ~/.lockscreen_2.png 
convert ~/.lockscreen_1.png ~/.lockscreen_2.png +append ~/.lockscreen.png
# feh ~/.lockscreen.png
i3lock -i ~/.lockscreen.png -f -e --greeter-text "Enter Password to Unlock" -k --indicator --pass-media --pass-screen --greeter-color="ffffffff" --time-color="ffffffff" --date-color="dddddddd"

 # convert ~/.wallpapers/$background -gravity Center -background $BGCOLOR -extent "$SCREEN_RESOLUTION" RGB:- | i3lock -i /dev/stdin 

# i3lock -i ~/.wallpapers/$background 
