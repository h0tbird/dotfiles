#!/bin/bash

#------------------------------------------------------------------------------
# Absolute paths.
#------------------------------------------------------------------------------

LS="`which ls` --format=single-column"
AWK=`which awk`
IP=`which ip`
SUDO=`which sudo`
SYSCTL=`which sysctl`

#------------------------------------------------------------------------------
# next_tap: returns the name of the next available TAP interface.
#------------------------------------------------------------------------------

function next_tap {
  taps=`$LS -d /sys/devices/virtual/net/tap* 2> /dev/null`
  [ $? != 0 ] && echo 'tap0' && return
  echo "${taps}" | $AWK -F 'p' 'END {print "tap"$2+1}'
}

#------------------------------------------------------------------------------
# create_tap: creates a new TAP device named $1 and owned by $USER.
#------------------------------------------------------------------------------

function create_tap {
  $SUDO $IP tuntap add dev $1 mode tap user $USER
  $SUDO $IP link set dev $1 up
  echo $1
}

#------------------------------------------------------------------------------
# destroy_tap: destroys the TAP device named $1.
#------------------------------------------------------------------------------

function destroy_tap {
  $SUDO $IP link set dev $1 down
  $SUDO $IP tuntap del dev $1 mode tap
  echo $1
}

#------------------------------------------------------------------------------
# bridge_wifi: Bridges a TAP device named $1 to the wlan0 device.
#------------------------------------------------------------------------------

function bridge_wifi {
  $SUDO $SYSCTL -w net.ipv4.ip_forward=1 &> /dev/null
  $SUDO $SYSCTL -w net.ipv4.conf.wlan0.proxy_arp=1 &> /dev/null
  $SUDO $SYSCTL -w net.ipv4.conf.${1}.proxy_arp=1 &> /dev/null
  echo $1
}

#------------------------------------------------------------------------------
#
#------------------------------------------------------------------------------

case $1 in

  #-----------
  # puppet01:
  #-----------

  puppet01)

    TAP=$(bridge_wifi $(create_tap $(next_tap)))
    $SUDO $IP route add 192.168.1.4 dev ${TAP}

    qemu-system-x86_64 \
    -enable-kvm \
    -smp 2,sockets=2,cores=1,threads=1 \
    -name ${1}.demo.lan \
    -nodefconfig \
    -rtc base=utc \
    -drive file="/home/marc/${1}.img",if=virtio \
    -net nic,model=virtio \
    -net tap,vlan=0,ifname=${TAP},script=no,downscript=no \
    -serial pty \
    -m 1024 \
    -display none \
    -daemonize ;;

  #--------
  # lxc01:
  #--------

  lxc01)

    TAP=$(bridge_wifi $(create_tap $(next_tap)))
    $SUDO $IP route add 192.168.1.8 dev ${TAP}

    qemu-system-x86_64 \
    -enable-kvm \
    -smp 2,sockets=2,cores=1,threads=1 \
    -name ${1}.demo.lan \
    -nodefconfig \
    -rtc base=utc \
    -drive file="/home/marc/${1}.img",if=virtio \
    -net nic,model=virtio \
    -net tap,vlan=0,ifname=${TAP},script=no,downscript=no \
    -serial pty \
    -m 1024 \
    -display none \
    -daemonize ;;

  #----------
  # Default:
  #----------

  *) echo "Usage: `basename $0` <name>" ;;

esac
