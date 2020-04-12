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
# SC1090: file sourcing     -  shellcheck is unaware of sourced pkgfiles
# SC2154: undeclared vars   -  shellcheck is unaware vars inside pkgfiles
SHELLCHECK = shellcheck -s sh -e 1090 -e 2154

test:
	${SHELLCHECK} bonsai
	${SHELLCHECK} tools/*
	@# SC2034: unused variables - shellcheck is unaware of how vars in
	@#                            pkgfiles are used
	${SHELLCHECK} -e 2034 ports/*/*/pkgfile
	@# count lines of code, excluding comments and blank lines:
	@echo SLOC: $$(sed '/^\s*#/d;/^\s*$$/d' bonsai  | wc -l)
