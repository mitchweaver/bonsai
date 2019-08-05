name=bonsai
PREFIX=${HOME}/.local/$(name)

$(name): FORCE
.PHONY: FORCE
FORCE:

all: $(name)

$(name):
	:> $(name)
	@echo '[*] collating sources into executable...'
	find src -type f | while read -r file ; do \
		cat $$file >> $(name) ; \
	done
	echo 'main "$$@"' >> $(name)
	@echo '[*] removing comments and blank lines from executable...'
	sed -e 's:^\s*#.*$$::g' -e '/^$$/d' $(name) > $(name).tmp
	echo '#!/bin/sh -e' > $(name)
	cat $(name).tmp >> $(name)
	rm $(name).tmp
	chmod +x $(name)

install:
	install -Dm755 $(name) ${PREFIX}/src/$(name)
	cp -rf ports ${PREFIX}/src

clean:
	rm -f $(name)

uninstall:
	@echo "Unsafe. Please do this manually."

ignores = -e SC1090 -e SC2154 -e SC2068 -e SC2046 -e SC2086 -e SC2119 -e SC2120
# ----- ShellCheck Explanations --------
# SC1090: "at run-time file sourcing" ie '. $pkgfile'
#         We use this to import each package's variables.
# SC2154: "var referenced but not assigned"
# 		  All of the config variables are set
# 		  at run time when the config is sourced.
# SC2068: for i in $@ ; do : ; done --- loop array splitting
#         This is always done intentionally.
# SC2046 + 2086: Word splitting
# 		  This one is the hardest to ignore,
# 		  but it is the one most carefully managed.
# 		  When words are split, they are done so intentionally.
# SC2119 + SC2120: arguments supplied but not forwarded/used
# 		  Shellcheck cannot see arguments given from pkgfiles.
test: $(name)
	shellcheck -s sh -x -a $(name) $(ignores)
	@echo "All checks passed!"
