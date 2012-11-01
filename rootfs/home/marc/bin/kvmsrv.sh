#!/bin/sh

case $1 in

    wifi ) qemu-kvm \
           -enable-kvm \
           -smp 1,sockets=1,cores=1,threads=1 \
           -name puppet.demo.lan \
           -drive file='/home/marc/CentOS.img',if=virtio \
           -net nic,model=virtio \
           -net tap,vlan=0,ifname=tap0,script=no,downscript=no \
           -m 1024 \
           -vnc 127.0.0.1:0 \
           -daemonize
           ;;

    lan ) qemu-kvm \
          -enable-kvm \
          -smp 1,sockets=1,cores=1,threads=1 \
          -name puppet.demo.lan \
          -drive file='/home/marc/CentOS.img',if=virtio \
          -net nic,model=virtio \
          -net bridge,helper='/usr/lib/qemu/qemu-bridge-helper' \
          -m 1024 \
          -vnc 127.0.0.1:0 \
          -daemonize
          ;;
esac
