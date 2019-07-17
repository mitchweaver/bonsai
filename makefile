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
	mkdir -p ${PREFIX}/src
	cp -rf ports ${PREFIX}/src

clean:
	rm -f $(name)

uninstall:
	@echo "Unsafe. Please do this manually."
