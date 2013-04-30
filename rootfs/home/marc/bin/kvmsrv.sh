#!/bin/sh

systemctl --type service | grep -q '^network.*wifi.*loaded' && NET='wifi'
systemctl --type service | grep -q '^network.*lan.*loaded' && NET='lan'

case $NET in

    #-------------------------------------------------------------
    # ip tuntap add dev tap0 mode tap user marc
    # ip link set dev tap0 up
    # ip addr add 192.168.2.1/24 dev tap0 broadcast 192.168.2.255
    #-------------------------------------------------------------

    wifi )  qemu-system-x86_64 \
            -enable-kvm \
            -smp 2,sockets=2,cores=1,threads=1 \
            -name puppet01.demo.lan \
            -nodefconfig \
            -rtc base=utc \
            -drive file='/home/marc/CentOS.img',if=virtio \
            -net nic,model=virtio \
            -net tap,vlan=0,ifname=tap0,script=no,downscript=no \
            -serial pty \
            -m 1024 \
            -display none \
            -daemonize
            ;;

    #------------------------------------------------------------
    # ip tuntap add dev tap0 mode tap user marc
    # ip link set dev tap0 up
    # brctl addbr br0
    # brctl addif br0 eth0
    # brctl addif br0 tap0
    # ip addr add 192.168.2.1/24 dev br0 broadcast 192.168.2.255
    #------------------------------------------------------------

    lan )   qemu-system-x86_64 \
            -enable-kvm \
            -smp 2,sockets=2,cores=1,threads=1 \
            -name puppet01.demo.lan \
            -nodefconfig \
            -rtc base=utc \
            -drive file='/home/marc/CentOS.img',if=virtio \
            -net nic,model=virtio \
            -net tap,vlan=0,ifname=tap0,script=no,downscript=no \
            -serial pty \
            -m 1024 \
            -display none \
            -daemonize
            ;;
esac
