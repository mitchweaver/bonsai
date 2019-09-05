#!/bin/sh
#
# http://github.com/bonsai-linux/bonsai
#
# bootstrap a bonsai system
#

msg()  { >&2 echo "$*" ; }
warn() { msg "Warning: $*" ; }
die()  { msg "Error: $*" ; exit 1 ; }

[ "$1" ] && die "usage: ./$(basename "$0")"

BONSAI_SOURCE="$(dirname "$PWD")"
[ -d "$BONSAI_SOURCE"/config ] || \
die "Cannot find source files.\n\
Please run this from the scripts directory."

[ "$ROOT" ] || die "\$ROOT is not defined. Please export it."
case "$ROOT" in
  /*) cd "$ROOT" 2>/dev/null || die "could not cd to \$ROOT. Does it exist?" ;;
   *) die "Please use an absolute path for \$ROOT."
esac

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

create() {
    perm=$1
    shift
    for dir in "$@" ; do
        msg "creating dir $dir with mode $perm..."
        install -d -m $perm "$dir"
    done
}

create 0755 bin boot dev etc home include lib local \
            mnt proc ROOT share src sys var \
            dev/pts dev/pts var/log

create 0775 tmp dev/shm var/tmp var/preserve var/run

for manX in man1 man2 man3 man4 man5 man6 man7 man8 ; do
    create 0744 share/man/$manX
done

create 0775 src/work src/pkgs src/ports src/sources src/config

link() {
    [ -L "$2" ] && rm -f "$2"
    msg "symlinking $2 to $1..."
    ln -sf "$1" "$2"
}

link . usr       # /usr     -> /
link bin sbin    # /sbin    -> /bin
link tmp var/tmp # /var/tmp -> /tmp
link lib libexec # /libexec -> /lib
link var/run run # /run     -> /var/run

for file in "$BONSAI_SOURCE"/etc/* ; do
    file="${file##*/}"
    if [ -f "$ROOT"/etc/$file ] ; then
        warn "\$ROOT/etc/$file exists, refusing to overwrite"
        continue
    fi
    msg "installing \$ROOT/etc/$file with mode 0644..."
    install -m 0644 "$BONSAI_SOURCE"/etc/$file "$ROOT"/etc/$file
done

for file in "$BONSAI_SOURCE"/config/*.cfg ; do
    file="${file##*/}"
    if [ -f "$ROOT"/src/config/$file ] ; then
        warn "\$ROOT/src/config/$file exists, refusing to overwrite"
        continue
    fi
    msg "installing \$ROOT/src/config/$file with mode 0644..."
    install -m 0644 "$BONSAI_SOURCE"/config/$file "$ROOT"/src/config/$file
done
