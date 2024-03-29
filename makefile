BONSAI_ROOT = ${HOME}/.bonsai
PREFIX = ${HOME}/.local

all:
	printf '%s\n\n' '#!/bin/sh -e' >bonsai
	for i in src/* ; do cat $$i ; echo ; done >>bonsai
	echo 'main "$$@"' >>bonsai

install:
	@if [ ! -f bonsai ] ; then >&2 echo "Use 'make' first to build the program." ; exit 1 ; fi
	mkdir -p ${BONSAI_ROOT}/src
	cp -rf ports ${BONSAI_ROOT}/src/
	install -D -m 0755 bonsai ${PREFIX}/bin/bonsai
	install -D -m 0755 bonsai ${BONSAI_ROOT}/bin/bonsai
	ln -sf bonsai ${PREFIX}/bin/bs
	ln -sf bonsai ${BONSAI_ROOT}/bin/bs

clean:
	rm bonsai

uninstall:
	rm ${PREFIX}/bin/bonsai
	unlink ${PREFIX}/bin/bs

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# SC1090: file sourcing     -  shellcheck is unaware of sourced pkgfiles
# SC2154: undeclared vars   -  shellcheck is unaware vars inside pkgfiles
# SC2120: unused arguments   - shellcheck is unaware of pkgfile function calls
# SC2295: Expansions with '#' - shellcheck thinks "#" which we are using as
#                               package version delimiter isn't taken literally
SHELLCHECK = shellcheck -s sh --norc -e 1090 -e 2154 -e 2120 -e 2295

test:
	${SHELLCHECK} bonsai
	@# SC2034: unused variables
	@#         shellcheck is unaware of how vars in pkgfiles are used
	@# SC2016: expressions in single quotes don't expand
	@#         this is used often in sed calls within pkgfiles
	@# SC2086: word splitting
	@#         this is used often, intentionally, in pkgfiles
	@# SC2209: shellcheck thinks "deps=sed" for example is a misuse
	@#         of command output. False positive.
	@# SC2164: 'use || exit in case cd fails' -- only used when will never fail
	${SHELLCHECK} -e 2034 -e 2016 -e 2086 -e 2209 -e 2164 ports/*/*/pkgfile
	@# count lines of code, excluding comments and blank lines:
	@echo SLOC: $$(sed '/^\s*#/d;/^\s*$$/d' bonsai  | wc -l)
