#!/bin/sh
#
# http://github.com/bonsai-linux/bonsai
#
# decompress a tarball to given directory
#

die() { >&2 echo "$*" ; exit 1 ; }

[ -f "$1" ] || die "$(basename "$0"): no such file $1"
[ -d "$2" ] || mkdir -p "$2" || die "$(basename "$0"): no output directory given"

decompress() {
    case "${1##*.}" in
        xz|txz) 
            if type xz-embedded >/dev/null 2>&1 ; then
                xz-embedded <"$1"
            else
                xz -qdc "$1"
            fi
            ;;
        gz|tgz)  gunzip  -qdc  "$1" ;;
        bz2|tbz) bunzip2 -qdc  "$1" ;;
        zip)     unzip   -qp   "$1" ;;
        *) die "$(basename "$0"): unsupported filetype"
    esac || die "$(basename "$0"): failed to decompress $1"
}

extract() {
    case "$1" in
        *.tar.*) ext=.tar
    esac
    ext="$ext.${1##*.}"

    case "$ext" in
        .tar.*|.tgz|.tbz|.txz)
            { decompress "$1" | tar -C "$2" -xf - ; } || 
                die "$(basename "$0"): failed to decompress $1"

            # ensure files are in toplevel (ie $dir/name, not $dir/$name/$name)
            mv -f "$2"/*/* "$2"/
            # copy any hidden files
            find "$2"/*/* -type f -name ".*" 2>/dev/null | while read -r file ; do
                mv "$file" "$2"/
            done
            # try to remove any possible empty dirs
            rmdir -p "$2"/* 2>/dev/null ||:
            ;;
        *)  # if not a tarball, simply write it out
            file="$(basename "$1")"
            decompress "$1" >"$2/${file%%$ext}"
    esac || die "$(basename "$0"): failed to extract $1"
}

extract "$1" "$2"
