#!/bin/sh -e
#
# Requires: bonsai-{core,kernel,init,bpm}, syslinux, dash
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# functions
msg() { printf "%s\n" "→ $*" ; }
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# config
root=~/.local/bonsai
builddir="$PWD"/build
bonsai=$root/src/bonsai
rm -r "${builddir:?}" 2>/dev/null ||: ; mkdir -p "$builddir"
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
msg 'relinking world...'
$bonsai --relink-world --chroot
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
msg 'zipping up the root file system...'
cd "$root"
find . | cpio -R root:root -H newc -o | gzip > "$builddir"/rootfs.gz
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
msg 'copying kernel image...'
cd "$builddir"
cp -f "$root"/src/pkgs/bonsai-kernel/vmlinuz ./kernel.gz
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
msg 'copying bootloader...'
cp -f "$root"/src/pkgs/syslinux/isolinux.bin ./isolinux.bin
cp -f "$root"/src/pkgs/syslinux/ldlinux.c32  ./ldlinux.c32
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
msg 'creating syslinux config...'
echo 'default kernel.gz initrd=rootfs.gz' > isolinux.cfg
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
msg 'creating iso...'
xorriso \
    -as mkisofs \
    -o "$builddir"/bonsai.iso \
    -b isolinux.bin \
    -c boot.cat \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table .
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
