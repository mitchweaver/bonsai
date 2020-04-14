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
	install -D -m 0755 bonsai ${BONSAI_ROOT}/bin/
	ln -sf bonsai ${PREFIX}/bin/bs
	ln -sf bonsai ${BONSAI_ROOT}/bin/bs

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# SC1090: file sourcing     -  shellcheck is unaware of sourced pkgfiles
# SC2154: undeclared vars   -  shellcheck is unaware vars inside pkgfiles
# SC2120: unused arguments   - shellcheck is unaware of pkgfile function calls
SHELLCHECK = shellcheck -s sh -e 1090 -e 2154 -e 2120

test:
	${SHELLCHECK} bonsai
	${SHELLCHECK} tools/*
	@# SC2034: unused variables
	@#         shellcheck is unaware of how vars in pkgfiles are used
	@# SC2016: expressions in single quotes don't expand
	@#         this is used often in sed calls within pkgfiles
	@# SC2086: word splitting
	@#         this is used often, intentionally, in pkgfiles
	@# SC2209: shellcheck thinks "deps=sed" for example is a misuse
	@#         of command output. False positive.
	${SHELLCHECK} -e 2034 -e 2016 -e 2086 -e 2209 ports/*/*/pkgfile
	@# count lines of code, excluding comments and blank lines:
	@echo SLOC: $$(sed '/^\s*#/d;/^\s*$$/d' bonsai  | wc -l)
