BONSAI_ROOT = ${HOME}/env/bonsai

PREFIX = ${HOME}/.local

# 1090: file sourcing     -  we know, pkgfiles
# 2154: undeclared vars   -  vars inside pkgfiles
# 2046: word splitting    -  this is done sparingly and intentionally
SHELLCHECK = shellcheck -s sh -e 1090 -e 2154 -e 2046

all:
	mkdir -p ${BONSAI_ROOT}/src
	cp -rf ports ${BONSAI_ROOT}/src/
	install -Dm 0755 bonsai ${PREFIX}/bin/
	install -Dm 0755 tools/* ${PREFIX}/bin/

test:
	${SHELLCHECK} bonsai
	${SHELLCHECK} tools/mksum
