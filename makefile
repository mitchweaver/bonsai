bonsai: FORCE
.PHONY: FORCE
FORCE:

all: bonsai

bonsai:
	@:> bonsai
	@echo '[*] collating sources into executable...'
	@find src -type f | while read -r file ; do \
		cat $$file >>bonsai ; \
	done
	@echo 'main "$$@"' >>bonsai
	@echo '[*] removing comments and blank lines from executable...'
	@# note: lines prefixed by '#_' remain blank lines
	@#       '##' are preserved as comments
	@sed -e 's:## :_TEMP_:g' \
	    -e 's:^\s*# .*$$::g' \
	    -e 's:_TEMP_:## :g' \
	    -e '/^$$/d' \
	    -e 's:#_::g' bonsai >bonsai.tmp
	@echo '#!/bin/sh' >bonsai
	@cat bonsai.tmp >>bonsai
	@rm -f bonsai.tmp
	chmod +x bonsai

check-root:
	@[ ${ROOT} ] || \
	{ >&2 echo "Error: \$$ROOT is not defined. Please export it." ; exit 1 ; }

install: check-root bonsai
	install -D -m 0755 bonsai ${ROOT}/src/pkgs/@bonsai/bin/bonsai
	@mkdir -p ${ROOT}/bin
	@[ -L ${ROOT}/bin/bonsai ] || \
	ln -sf ${ROOT}/src/pkgs/@bonsai/bin/bonsai ${ROOT}/bin/bonsai
	@for dir in core extra community xorg gnu shared TESTING ; do \
		rm -rf ${ROOT}/src/ports/$dir 2>/dev/null ; \
	done
	mkdir -p ${ROOT}/src/ports
	cp -rf ports/* ${ROOT}/src/ports/
	@[ -f ${ROOT}/src/bonsai.db ] || :> ${ROOT}/src/bonsai.db


clean:
	rm -f bonsai

ignores = -e SC1090 -e SC2154 -e SC2068 -e SC2046 -e SC2086 -e SC2119 \
		  -e SC2120 -e SC2100 -e SC2153 -e SC1092 -e SC1091 -e SC2059
# ----- ShellCheck Explanations --------
# SC1090: "at run-time file sourcing" ie '. $pkgfile'
#         We use this to import each package's variables.
# SC2154: "var referenced but not assigned"
#		  All of the config variables are set
#		  at run time when the config is sourced.
# SC2068: for i in $@ ; do : ; done --- loop array splitting
#         This is always done intentionally.
# SC2046 + 2086: Word splitting
#		  This one is the hardest to ignore,
#		  but it is the one most carefully managed.
#		  When words are split, they are done so intentionally.
# SC2119 + SC2120: arguments supplied but not forwarded/used
#		  Shellcheck cannot see arguments given from pkgfiles.
# SC2100: Arithmetic
# 		  Broken in shellcheck. Variables containing '-' cause error.
# SC2153: Possible misspelling
#         Some vars are capital in the config file while lower in the script.
#         Manually manage this.
# SC1092 + SC1091: Cannot source non-existant path
#         Config file paths won't exist when outside the chroot.
# SC2059: Variable in printf strings
#         We use this to print color escape codes in messages.
test: bonsai
	shellcheck -s sh -x -a bonsai $(ignores)
	@echo "All checks passed!"
