#!/bin/sh

if `ip l | grep -q tap1`; then TAP='tap1'; fi
if `ip l | grep -q tap0`; then TAP='tap0'; fi

#------------------------------------------------------------------------------
# Setup the context:
#------------------------------------------------------------------------------

case $TAP in

    #------
    # LAN:
    #------

    tap0) sudo sysctl -w net.ipv4.ip_forward=0
          sudo sysctl -w net.ipv4.conf.eth0.proxy_arp=0
          sudo sysctl -w net.ipv4.conf.tap0.proxy_arp=0 ;;

    #-------
    # WiFi:
    #-------

    tap1) sudo sysctl -w net.ipv4.ip_forward=1
          sudo sysctl -w net.ipv4.conf.wlan0.proxy_arp=1
          sudo sysctl -w net.ipv4.conf.tap1.proxy_arp=1
          sudo ip route add 192.168.1.4 dev tap1 ;;
esac

#------------------------------------------------------------------------------
# Launch the KVM instance:
#------------------------------------------------------------------------------

qemu-system-x86_64 \
-enable-kvm \
-smp 2,sockets=2,cores=1,threads=1 \
-name puppet01.demo.lan \
-nodefconfig \
-rtc base=utc \
-drive file='/home/marc/CentOS.img',if=virtio \
-net nic,model=virtio \
-net tap,vlan=0,ifname=${TAP},script=no,downscript=no \
-serial pty \
-m 1024 \
-display none \
-daemonize
