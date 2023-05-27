S="$(safeeyes --status)";
if echo $S | grep -q Disabled; then
  echo " Idle";
elif echo $S | grep -q "not running"; then
  echo " Off";
else
  Time=$( echo $S | awk '{print $4$5}');
  TimeInUTC=$(date -u +%H:%M -d $(date +@%s -d $Time));
  echo "" $(datediff time -i"%H:%M" $TimeInUTC -f"%M:%0S");
fi

