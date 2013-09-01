#!/bin/bash

if [[ -z $1 ]]; then

  urxvt +sb -pe default,-tabbedex -title kbcast-$$ -e bash -c \
  "xdotool search --name kbcast-$$ windowmove 500 430 windowsize 600 80 windowactivate; $0 x"

else

  while true; do
    read cmd
    xdotool search --onlyvisible --maxdepth 1 --name rxvt type --delay 0 --window %@ "$(printf "${cmd}\n ")"
  done

fi
