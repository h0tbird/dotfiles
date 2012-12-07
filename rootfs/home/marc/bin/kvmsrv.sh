#!/bin/sh

systemctl --type service | grep -q '^network.*wifi.*loaded' && NET='wifi'
systemctl --type service | grep -q '^network.*lan.*loaded' && NET='lan'

case $NET in

    wifi ) qemu-kvm \
           -enable-kvm \
           -smp 2,sockets=2,cores=1,threads=1 \
           -name puppet.demo.lan \
           -nodefconfig \
           -rtc base=utc \
           -drive file='/home/marc/CentOS.img',if=virtio \
           -net nic,model=virtio \
           -net tap,vlan=0,ifname=tap0,script=no,downscript=no \
           -serial pty \
           -m 1024 \
           -nographic \
           -daemonize
           ;;

    lan ) qemu-kvm \
          -enable-kvm \
          -smp 2,sockets=2,cores=1,threads=1 \
          -name puppet.demo.lan \
          -nodefconfig \
          -rtc base=utc \
          -drive file='/home/marc/CentOS.img',if=virtio \
          -net nic,model=virtio \
          -net bridge,helper='/usr/lib/qemu/qemu-bridge-helper' \
          -serial pty \
          -m 1024 \
          -nographic \
          -daemonize
          ;;
esac
