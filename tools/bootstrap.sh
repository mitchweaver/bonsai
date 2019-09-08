#!/bin/sh
#
# http://github.com/bonsai-linux/bonsai
#
# bootstrap a bonsai system
#

die() { >&2 echo "$*" ; exit 1 ; }

[ "$ROOT" ] || die "\$ROOT is not defined. Please export it."

# make sure an absolute path was provided for $ROOT
case "${ROOT}" in
    /*) cd "${ROOT}" 2>/dev/null || 
        { >&2 echo "Error: could not cd to \$$ROOT. Does it exist?" ; exit 1 ; }
        ;;
     *) >&2 echo "Error: Please use an absolute path for \$$ROOT." ; exit 1
esac

# assign vars as we don't yet have a config file
# you can override these defaults by providing them in the environment
: "${SRC:="$ROOT/src"}" "${PKGS:="$SRC/pkgs"}" \
  "${PORTS:="$SRC/ports"}" "${SOURCES:="$SRC/sources"}" \
  "${WORK:="$SRC/work"}" "${CONFIG:="$SRC/config"}" \
  "${PKGDB:="$SRC/bonsai.db"}" "${TOOLS:="$SRC/tools"}" \
  "${DELIM:=#}" "${PROMPT:="→"}" "${CONFIRM_PROMPT:="continue? (y/n): "}" \
  "${STRIP_BINS:=true}" "${JOBS:="$(($(grep -c 'cpu cores' /proc/cpuinfo) + 1))"}"
export SRC PKGS PORTS SOURCES WORK CONFIG PKGDB TOOLS \
       DELIM PROMPT CONFIRM_PROMPT STRIP_BINS JOBS
export BOOTSTRAP=1
export NO_PROMPT=1

set -e

"$ROOT"/bin/bonsai isinst @stage0 >/dev/null || \
"$ROOT"/bin/bonsai add @stage0

echo "Downloading additional packages..."
DL_ONLY=1 NO_WARN=1 "$ROOT"/bin/bonsai add @stage1

"$ROOT"/bin/bonsai --relink-world --chroot

set +e
