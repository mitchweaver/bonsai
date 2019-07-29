name=bonsai
PREFIX=${HOME}/.local/$(name)

$(name): FORCE
.PHONY: FORCE
FORCE:

all: $(name)

$(name):
	@echo '[*] collating sources into executable...'
	find src -type f | while read -r file ; do \
		cat $$file >> $(name) ; \
	done
	echo 'main "$$@"' >> $(name)
	@echo '[*] removing comments and blank lines from executable...'
	sed -e 's:^\s*#.*$$::g' -e '/^$$/d' $(name) > $(name).tmp
	echo '#!/bin/sh' > $(name)
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

ignores = -e 1090 -e 2154 -e SC2068 -e SC2046 -e SC2086 -e SC2218
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
# SC2218: "function not yet defined"
# 		  This is a shellcheck bug and it has to do with the way
# 		  we're collating the files.
test: $(name)
	@clear
	@echo "------- ERRORS --------------"
	shellcheck -s sh -S error -x -a $(name) $(ignores)
	@echo "------ WARNINGS -------------"
	shellcheck -s sh -S warning -x -a $(name) $(ignores)
	@echo "-------- INFO ---------------"
	shellcheck -s sh -S info -x -a $(name) $(ignores)
	@echo "-------- STYLE ---------------"
	shellcheck -s sh -S style -x -a $(name) $(ignores)
	@echo "------------------------------"
	@echo "All passed!"
