#!/bin/sh
#
# http://github.com/bonsai-linux/bonsai
#
# verify checksums against tarballs in given dir
#

die() { >&2 echo "$*" ; exit 1 ; }

cd "$1"     || die "$(basename "$0"): cannot cd to $1"
[ -f sums ] || die "$(basename "$0"): checksum file does not exist in $1"

sha512sum -c sums || exit 1
