#!/bin/sh

sudo iw dev wlan0 scan | grep -i ssid
sudo iw dev wlan0 link
