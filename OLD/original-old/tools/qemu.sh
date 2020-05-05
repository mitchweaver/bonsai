#!/bin/sh -e
#
# http://github.com/bonsai-linux/tools
#
# launches qemu with sane arguments for our iso
#

case "$1" in
    -h|*help)
        >&2 echo 'usage: ./qemu.sh /path/to/bonsai.iso'
        exit 1
esac

iso="$1"
[ ! -f "$iso" ] && { >&2 echo "$iso is not a valid .iso file" ; exit 1 ; }

# use half of total ram
set -- $(free -h | awk 'NR==2{print $2}NR==2{print $3}')
ram="${1%.*}"
ram="$(( $ram / 2 ))G"

qemu-system-x86_64 \
    -daemonize \
    -m $ram \
    -vga std \
    -usb \
    -device usb-tablet \
    -cdrom "$iso" &

    #-enable-kvm
