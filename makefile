name=bore
PREFIX=${HOME}/.local/$(name)

$(name): FORCE
.PHONY: FORCE
FORCE:

all: $(name)

$(name):
	@echo '[*] collating sources into executable...'
	echo '#!/bin/sh' > bore
	ls src | while read -r file ; do \
		cat src/$$file >> $(name) ; \
	done
	echo 'main "$$@"' >> $(name)
	@echo '[*] removing comments from executable...'
	sed 's:^\s*#.*$$::g' $(name) > $(name).tmp
	mv -f $(name).tmp $(name)
	@echo '[*] removing blank lines from executable...'
	sed '/^$$/d' $(name) > $(name).tmp
	mv -f $(name).tmp $(name)
	chmod +x $(name)

install:
	install -Dm755 $(name) ${PREFIX}/src/$(name)
	cp -rf ports ${PREFIX}/src

clean:
	rm -f $(name)

uninstall:
	@echo "Unsafe. Please do this manually."

ignores = -e 1090 -e 2154
# ----- ShellCheck Explanations --------
# SC1090: "at run-time file sourcing" ie '. $pkgfile'
#         We use this to import each package's variables.
#         This is not an error
# SC2154: "var referenced but not assigned"
# 		  All of the config variables are set
# 		  at run time when the config is sourced.
# 		  This is not an error.
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
