S="$(safeeyes --status)";
if echo $S | grep -q Disabled; then
  echo " Idle/Disabled";
elif echo $S | grep -q "not running"; then
  echo " Off";
else
  # safeeyes --status uses a non-breaking space (U+202F) as a separator (why?)
  # so we need to remove it before passing the time to date
  Time=$( echo $S | awk '{print $4,$5}' | tr -d $(echo $'\u202F') )
  TimeInUTC=$(date -u +%H:%M -d $(date +@%s -d $Time))
  echo "" $(datediff time -i"%H:%M" $TimeInUTC -f"%M:%0S");
fi

