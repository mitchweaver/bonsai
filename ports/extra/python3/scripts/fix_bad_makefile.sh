#!/bin/sh

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# Preface:
# 
# For some reason makesetup outputs these variables all
# on one giant line, which causes them to be interpreted
# as a command - "no such file or directory".
#
# Not sure if this is a due to sbase, dash, or what.
#
# As a fix, here we split the file on the bad line, delete it,
# append the variables how they shold be, and put the file back together.
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

# 1) csplit file on the bad line
#    this will output them to xx00 and xx01
csplit Makefile  '/LOCALMODLIBS= /'

# 2) append the correct line, formatted, onto xx00
cat >> xx00 << 'EOF'
LOCALMODLIBS=-lreadline -ltermcap -L$(SSL)/lib -lssl -lcrypto -lncurses -ltermcap -L$(exec_prefix)/lib -lz
BASEMODLIBS=
SSL=/
COREPYTHONPATH=$(DESTPATH)$(SITEPATH)$(TESTPATH)
PYTHONPATH=$(COREPYTHONPATH)
TESTPATH=
SITEPATH=
DESTPATH=
MACHDESTLIB=$(BINLIBDEST)
DESTLIB=$(LIBDEST)
EOF

# 3) delete the bad line from xx01, appending remainder to xx00
sed '1d' xx01 >> xx00

# 4) rename final file
mv -f xx00 Makefile
