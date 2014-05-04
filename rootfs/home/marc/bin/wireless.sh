#!/bin/sh

echo "#-------------------------------------------------"
echo "# Networks sorted by signal:"
echo "#-------------------------------------------------"
echo

sudo iw dev wlan0 scan | egrep -i "ssid:|signal:" | paste - - | sort

echo
echo "#-------------------------------------------------"
echo "# Current selection:"
echo "#-------------------------------------------------"
echo

sudo iw dev wlan0 link

echo
