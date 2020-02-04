#!/bin/sh
#
# http://github.com/bonsai-linux/tools
#
# enter a bonsai chroot
#

case "$1" in
    -h|*help)
        printf "%s\n\n%s\n\n%s\n" \
            'usage: ./chroot.sh /path/to/chroot' \
            'OR' \
            'with no arguments, using $ROOT variable from environment'
        exit
esac

if [ "$1" ] ; then
    path="$1"
elif [ "$ROOT" ] ; then
    path="$ROOT"
fi

# sanity checks
if [ ! -d "$path" ] ; then
    >&2 echo "$path does not exist"
    exit 1
else
    for i in proc dev sys ; do
        if [ ! -d "$path"/$i ] ; then
            >&2 echo "$path does not seem to be a chroot"
            exit 1
        fi
    done
    if [ ! -L "$path"/bin/sh ] && [ ! -x "$path"/bin/sh ] ; then
        >&2 echo "$path/bin/sh is bad"
        exit 1
    fi
fi

# if not running as root, restart script
if [ $(id -u) -ne 0 ] ; then
    if type sudo >/dev/null 2>&1 ; then
        sudo -E "$0" "$@"
    else
        doas sh -c "ROOT=\"$ROOT\"; $0 $@"
    fi
    exit $?
fi

echo 'mounting proc,dev,sys...'
mount -o bind -t devtmpfs /dev     "$path"/dev     2>/dev/null
mount -o bind -t devpts   /dev/pts "$path"/dev/pts 2>/dev/null
mount -o bind -t proc     /proc    "$path"/proc    2>/dev/null
mount -o bind -t sysfs    /sys     "$path"/sys     2>/dev/null

echo 'copying /etc/resolv.conf'
cp -f /etc/resolv.conf "$path"/etc

# linebreak before entering chroot
echo

OLD_PS1="$PS1"
export PS1='% '

# prefer a nice interactive shell if one is installed in the chroot
for shell in loksh mksh bash zsh dash sh ; do
    [ -L "$path"/bin/$shell ] && break
done

# set up some env variables for the chroot
# notice we unset $ROOT if it exists in the env
root= \
USER=root \
HOME=/root \
SHELL=$shell \
chroot "$path" /bin/$shell

tryumount() {
    if ! umount "$1" 2>/dev/null ; then
        sleep 1
        if ! umount -f "$1" 2>/dev/null ; then
            umount -l "$1" 2>/dev/null
            >&2 echo "WARNING: could not unmount $1!"
        fi
    fi
}

printf "\n%s\n" "unmounting proc,dev,sys..."
sleep 1
tryumount "$path"/dev
tryumount "$path"/proc
tryumount "$path"/sys

export PS1="$OLD_PS1"

echo "Exited chroot!"
