BONSAI_ROOT = ${HOME}/env/bonsai
PREFIX = ${HOME}/.local

all:
	printf '%s\n\n' '#!/bin/sh -e' >bonsai
	for i in src/* ; do cat $$i ; echo ; done >>bonsai
	echo 'main "$$@"' >>bonsai

install:
	mkdir -p ${BONSAI_ROOT}/src ${BONSAI_ROOT}/src/tools
	cp -rf ports ${BONSAI_ROOT}/src/
	install -D -m 0755 tools/* ${BONSAI_ROOT}/src/tools/
	install -D -m 0755 tools/* ${PREFIX}/bin/
	install -D -m 0755 bonsai ${PREFIX}/bin/
	ln -sf ${PREFIX}/bin/bonsai ${PREFIX}/bin/bs

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# SC1090: file sourcing     -  we know, pkgfiles
# SC2154: undeclared vars   -  vars inside pkgfiles
# SC2046: word splitting    -  this is done sparingly and intentionally
# SC2144: globs with test   -  intentional, it works in this instance
SHELLCHECK = shellcheck -s sh -e 1090 -e 2154 -e 2046 -e 2144

test:
	${SHELLCHECK} bonsai
	${SHELLCHECK} tools/*
	@# count lines of code, excluding comments and blank lines:
	@echo SLOC: $$(sed '/^\s*#/d;/^\s*$$/d' bonsai  | wc -l)
