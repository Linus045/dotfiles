set_mode_performance() {
  liquidctl initialize --pump-mode=performance && liquidctl set fan speed 30 25 70 100
  echo "Set mode to performance"
}

set_mode_balanced() {
  liquidctl initialize --pump-mode=balanced && liquidctl set fan speed 30 15 75 100
  echo "Set mode to balanced"
}

set_mode_quiet() {
  liquidctl initialize --pump-mode=quiet && liquidctl set fan speed 35 5 80 100
  echo "Set mode to quiet"
}

case "$1" in
  performance)
	set_mode_performance
    ;;
  balanced)
	set_mode_balanced
    ;;
  quiet)
	set_mode_quiet
    ;;
  next)
	MODE="$(liquidctl status | rg 'mode' | awk '{ print $4 }')"
	if [[ $MODE = "performance" ]]; then
	  set_mode_balanced
	elif [[ $MODE = "balanced" ]]; then
	  set_mode_quiet
	elif [[ $MODE = "quiet" ]]; then
	  set_mode_performance
	fi
    ;;
  *) ;;
esac

