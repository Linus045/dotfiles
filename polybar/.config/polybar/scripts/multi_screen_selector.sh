disconnected_screens=$(xrandr | grep ' disconnected' | awk -F' ' '{ print $1 }')
disconnected_screens=($(echo $disconnected_screens | tr ' ' ' '))

connected_screens=$(xrandr | grep ' connected' | awk -F' ' '{ print $1 }')
connected_screens=($(echo $connected_screens | tr ' ' ' '))


echo "connected_screens"
l=${#connected_screens[@]}
for (( i=1; i<${l}; i++ )); do
  echo ${connected_screens[i]}
  xrandr --output ${connected_screens[i]} --auto --left-of ${connected_screens[0]}
done
echo ""

echo "disconnected_screens"
l=${#disconnected_screens[@]}
for (( i=0; i<${l}; i++ )); do
  echo ${disconnected_screens[i]}
  xrandr --output ${disconnected_screens[i]} --off
done

# restart i3 to reload polybar
# sleep 2 && /bin/bash /home/linus/.config/polybar/launch.sh
