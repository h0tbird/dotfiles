#!/bin/bash

if [[ -z $1 ]]; then

  urxvt +sb -pe default,-tabbedex -title kbcast-$$ -e bash -c \
  "xdotool search --name kbcast-$$ windowmove 500 430 windowsize 600 80 windowactivate; $0 x"

else

  rlwrap -a -H ~/.kbcast_history bash -c "
  while true; do
    echo -n '> '
    read cmd
    xdotool search --onlyvisible --maxdepth 1 --name urxvt type --delay 0 --window %@ \"\$(printf \"\${cmd}\n \")\"
  done"

fi
