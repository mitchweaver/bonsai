BONSAI_ROOT = ${HOME}/env/bonsai
PREFIX = ${HOME}/.local

all:
	printf '%s\n\n' '#!/bin/sh -e' >bonsai
	for i in src/* ; do cat $$i ; echo ; done >>bonsai
	echo 'main "$$@"' >>bonsai

install:
	mkdir -p ${BONSAI_ROOT}/src
	cp -rf ports ${BONSAI_ROOT}/src/
	install -D -m 0755 bonsai ${PREFIX}/bin/
	install -D -m 0755 tools/* ${PREFIX}/bin/

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# 1090: file sourcing     -  we know, pkgfiles
# 2154: undeclared vars   -  vars inside pkgfiles
# 2046: word splitting    -  this is done sparingly and intentionally
SHELLCHECK = shellcheck -s sh -e 1090 -e 2154 -e 2046

test:
	${SHELLCHECK} bonsai
	${SHELLCHECK} tools/mksum
	@# count lines of code, excluding comments and blank lines:
	@echo SLOC: $$(sed '/^\s*#/d;/^\s*$$/d' bonsai  | wc -l)
