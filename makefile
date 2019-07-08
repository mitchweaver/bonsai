name=bore

$(name): FORCE
.PHONY: FORCE
FORCE:

all: $(name)

$(name):
	@echo '#!/bin/sh' > bore
	@for file in `ls src` ; do \
		echo "# -*-*- $$file *-*-*-*-*-*-*-" >> $(name) ; \
		cat src/$$file >> $(name) ; \
	done
	@echo 'main "$$@"' >> $(name)
	@chmod +x $(name)

install:
	install -Dm755 $(name) ${PREFIX}/src/$(name)
	install -Dm644 $(name).rc ${PREFIX}/src/$(name).rc
	@if [ -d ${PREFIX}/src/ports ] ; then \
		rm -rf ${PREFIX}/src/ports ; \
	fi
	cp -rf ports ${PREFIX}/src/ports

clean:
	rm -f $(name)
