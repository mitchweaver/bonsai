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

test: $(name)
	@clear
	@echo "------- ERRORS --------------"
	shellcheck -s sh -S error -x -a $(name)
	@echo "------ WARNINGS -------------"
	shellcheck -s sh -S warning -x -a $(name) -e 1090 -e 2154 -e 2120 -e 2098 -e 2097 -e 2155 -e 2174
	@echo "-------- INFO ---------------"
	shellcheck -s sh -S info -x -a $(name) -e 2086 -e 1090 -e 2154 -e 2120 -e 2098 -e 2097 -e 2155 -e 2174
	@echo "-------- STYLE ---------------"
	shellcheck -s sh -S style -x -a $(name) -e 2086 -e 1090 -e 2154 -e 2120 -e 2098 -e 2097 -e 2155 -e 2174
	@echo "------------------------------"
	@echo "All passed!"
