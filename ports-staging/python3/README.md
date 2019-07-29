broken

Errors out at end of configure.

output:

```
checking for //bin/gcc option to accept ISO C89... none needed
checking how to run the C preprocessor... //bin/gcc -E
checking for grep that handles long lines and -e... grep
checking for a sed that does not truncate output... sed
checking for --with-cxx-main=<compiler>... no
checking for c++... c++
configure:

  By default, distutils will build C++ extension modules with "c++".
  If this is not intended, then set CXX on the configure command line.

checking for the platform triplet based on compiler characteristics... x86_64-linux-gnu
configure: error: internal configure error for the platform triplet, please file a bug report
make: *** No targets specified and no makefile found.  Stop.
make: *** No rule to make target 'altinstall'.  Stop.
→ error: python3 build() failed
%
```
