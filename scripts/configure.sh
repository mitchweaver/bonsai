#!/bin/sh
#
# Probe configure script for desired flags.
#
# http://github.com/bonsai-linux/bonsai
#

if [ ! -f "$1" ] || [ ! -f "$2" ] || [ "$1" != configure ] ; then
    >&2 echo "usage: /path/to/configure /path/to/conf.cfg"
    exit 1
fi

cfhelp="$(sh "$1" --help)"
cfflags=

YES() {
    case "$cfhelp" in
        *" --enable-$1 "*|*" --disable-$1 "*)
            cfflags="$cfflags --enable-$1 "
            echo "adding flag: --enable-$1 "
            ;;
        *" --with-$1 "*|*" --without-$1 "*)
            cfflags="$cfflags --with-$1 "
            echo "adding flag: --with-$1 "
    esac
}
NO() {
    case "$cfhelp" in
        *" --disable-$1 "*|*" --enable-$1 "*)
            cfflags="$cfflags --disable-$1 "
            echo "adding flag: --disable-$1 "
            ;;
        *" --without-$1 "*|*" --with-$1 "*)
            cfflags="$cfflags --without-$1 "
            echo "adding flag: --without-$1 "
    esac
}
SET() {
    case "$cfhelp" in
        *" --$1="*)
            cfflags="$cfflags --$1=$2 "
            echo "adding flag: --$1=$2 "
            ;;
        *" --$1 "*)
            cfflags="$cfflags --$1 "
            echo "adding flag: --$1 "
    esac
}

while read -r line ; do
    set -- $line
    case $1 in
        SET) SET $1 $2 ;;
        YES) YES $1 $2 ;;
        NO)  NO  $1 $2 ;;
    esac
done < "$2"

echo "$cfflags"
