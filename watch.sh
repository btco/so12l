#!/bin/bash
echo "Watching all relevant files..."
last_mtime="not_yet_computed"
i=0

if [ "$(uname)" == "Darwin" ]; then
  # MacOS stat command.
  stat_cmd="stat -f %m"
else
  # Linux stat command.
  stat_cmd="stat -c %Y"
fi

while true; do
  xls=`find xl -name '*.xl'`
  js=`find . -name '*.js'`
  luas=`find src -name '*.lua'`
  this_mtime=`$stat_cmd $luas $xls $js`
  if [ "$this_mtime" != "$last_mtime" ]; then
    last_mtime=$this_mtime
    sleep 0.5
    bash go.sh
    cd sim; bash go.sh; cd ..
    echo "[$i]"
    ((i++))
  fi
  sleep 1
done
