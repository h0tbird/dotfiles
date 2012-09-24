#!/bin/bash

#------------------------------------------------------------------------------
# print_song_info:
#------------------------------------------------------------------------------

print_song_info() {
  song_info="$(ncmpcpp --now-playing '{{{{%t Ý }%a}}|{%f}}' | head -c 50)"
  if [[ ! $song_info ]]; then
    song_info="Not playing"
  fi
  echo -ne "\x04Ü\x0D Î ${song_info}"
}

#------------------------------------------------------------------------------
# print_torrent_status:
#------------------------------------------------------------------------------

print_torrent_status() {
  torrent_status="$(transmission-remote -l | awk '/\ \ Up\ &\ Down\ \ /\
      && ! /\ \ Unknown\ \ /\
      {print substr(substr($0,index($0,$13)),0,40), "Ý "$5$6}')"
  if [[ ! $torrent_status ]]; then
    torrent_status="$( transmission-remote -l | awk '/\ \ Downloading\ \ /\
        && ! /\ \ Unknown\ \ /\
        {print substr(substr($0,index($0,$11)),0,40), "Ý "$5$6}')"
  fi
  if [[ ! $torrent_status ]]; then
    torrent_status="Not downloading"
  fi
  echo -ne "\x05Ü\x0C Ù ${torrent_status}" | head -n 1
}

#------------------------------------------------------------------------------
# print_gmail_unread:
#------------------------------------------------------------------------------

print_gmail_unread() {
  gmail_unread="$(find $HOME/.mutt/maildir/gmail/inbox/new -type f | wc -l)"
  echo -ne "\x04Ü\x0B Ó ${gmail_unread}"
}

#------------------------------------------------------------------------------
# print_mq_unread:
#------------------------------------------------------------------------------

print_mq_unread() {
  mq_unread="$(find $HOME/.mutt/maildir/mq/inbox/new -type f | wc -l)"
  echo -ne "Ý Ó ${mq_unread}"
}

#------------------------------------------------------------------------------
# print_last_msg:
#------------------------------------------------------------------------------

print_last_msg() {
  last_msg="$(cat $HOME/.logs/irssi_pipe)"
  echo -ne "\x05Ü\x0A Ò ${last_msg}"
}

#------------------------------------------------------------------------------
# print_mem_used:
#------------------------------------------------------------------------------

print_mem_used() {
  mem_used="$(free -m | awk '/buffers\/cache/ {print $3}')"
  echo -ne "Ý Þ ${mem_used}M"
}

#------------------------------------------------------------------------------
# print_volume:
#------------------------------------------------------------------------------

print_volume() {
  volume="$(amixer get PCM | tail -n1 | sed -r 's/.*\[(.*)%\].*/\1/')"
  echo -ne "\x04Ü\x06 Ô ${volume}%"
}

#------------------------------------------------------------------------------
# print_datetime:
#------------------------------------------------------------------------------

print_datetime() {
  datetime="$(date "+%a %d %b Ý %H:%M:%S")"
  echo -ne "\x05Ü\x02 Õ ${datetime}"
}

rx_old=$(cat /sys/class/net/eth0/statistics/rx_bytes)
tx_old=$(cat /sys/class/net/eth0/statistics/tx_bytes)

#------------------------------------------------------------------------------
# Main loop:
#------------------------------------------------------------------------------

while true; do

  # get new cpu idle and total usage
  eval $(awk '/^cpu /{print "cpu_idle_now=" $5 "; cpu_total_now=" $2+$3+$4+$5 }' /proc/stat)
  cpu_interval=$((cpu_total_now-${cpu_total_old:-0}))

  # calculate cpu usage (%)
  let cpu_used="100 * ($cpu_interval - ($cpu_idle_now-${cpu_idle_old:-0})) / $cpu_interval"

  # get new rx/tx counts
  rx_now=$(cat /sys/class/net/eth0/statistics/rx_bytes)
  tx_now=$(cat /sys/class/net/eth0/statistics/tx_bytes)

  # calculate the rate (K) and total (M)
  let rx_rate=($rx_now-$rx_old)/1024
  let tx_rate=($tx_now-$tx_old)/1024

  # output vars
  print_cpu_used() { printf "%-12b" "\x04Ü\x09 Ï ${cpu_used}%"; }
  print_rx_rate() { printf "%-13b" "\x05Ü\x08 Ð ${rx_rate}K"; }
  print_tx_rate() { printf "%-12b" "\x01Ý \x07Ñ ${tx_rate}K"; }

  # Pipe to status bar, not indented due to printing extra spaces/tabs
  xsetroot -name "$(print_song_info) \
$(print_torrent_status) \
$(print_gmail_unread) $(print_mq_unread) $(print_last_msg) \
$(print_cpu_used) $(print_mem_used) \
$(print_rx_rate) $(print_tx_rate) \
$(print_volume) $(print_datetime) "

  # reset old rates
  rx_old=$rx_now
  tx_old=$tx_now
  cpu_idle_old=$cpu_idle_now
  cpu_total_old=$cpu_total_now

  # loop stats every 1 second
  sleep 1

done
