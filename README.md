# bonsai

<img align="right" src="res/bonsai.png">

Linux done differently.

For the idealists, for the hobbyists.

# Core Philosophy

### *"Software shouldn't come with compromise."*

1. **Static Linking**
 
All programs should be statically linked.  
No [dependency hell](http://en.wikipedia.org/wiki/Dependency_hell), no searching through the filesystem.  
Minimize moving parts. Simpler is better.

2. **Sandboxing**

Chroot sandboxes should be *dead simple* to 
setup just by copying the statically-linked binaries.  

3. **A Better C Library**

GNU's [glibc](http://www.gnu.org/software/libc) is massively bloated and a poor choice for static linking.  
[musl-libc](http://musl-libc.org) is a fresh lightweight alternative 
that was [designed from the ground up](https://www.musl-libc.org/intro.html) 
to be used with static linking. 

Just take a look at this [hello world](http://0x0.st/zpbd.png) comparison.

Applications statically-linked
with musl carefully avoid pulling in large amounts of code or 
data that the application will not use and have no runtime 
dependencies. Many programs need patching to compile
under musl-libc, however this *almost always* makes their code [better](http://wiki.musl-libc.org/bugs-found-by-musl.html).

4. **Simplicity**

No matter how great, a system is bottlenecked by its ability to be understood.

* Sane and optimal default flags
* A modular automated build system with parts that can overridden simply by defining the given function in the pkgfile
* Easy-to-understand "3-phase" `prebuild()`, `build()`, and `postbuild()`
* Automatic detection of required flags, configs, patches, and workarounds
* Ports can be written with *[just one line](http://ix.io/1QMb)*!
* Extensive documentation, with unclear or missing manuals considered a bug

5. **Sane File System Hierarchy**

Similar to [GoboLinux](https://gobolinux.org/), bonsai uses a custom directory scheme:

`/include`  
`/lib`  
`/share`  
`/local` <sub>(applications not installed via bonsai)</sub>  
`/src` <sub>(bonsai home)</sub>  
`/usr ` <sub>symlinked →   `/`</sub>  
`/sbin` <sub>symlinked → `/bin`</sub>  

*(directories left standard not shown)*

----

A tree of `/src` looks like this:

```
/src
    ├── /pkgs        ←  packages
    ├── /ports       ←  pkgfiles
    ├── /sources     ←  tarballs
    ├── bonsai.rc    ←  config file
    └── bonsai.db    ←  database file
```

Inside each package is its own prefix with given `/bin`, `/lib`, etc

As a side effect of this, each `$pkgdir` is its own chroot filesystem that can
be used at will. In the future, this process is planned to be automated.

Symlinks are created from the package to the outside root for seamless
integration and standards compatibility.

<sub>**Example:**</sub>

```sh
% readlink /bin/perl
/src/pkgs/perl/bin/perl
% readlink /share/man/man1/gcc.1
/src/pkgs/gcc/share/man1/gcc.1
```

With only symlinks, no actual data lives in 
`/bin`, `/lib`, `/include`, or `/share` on the root.

Thus removing data is as simple as removing a given `$pkgdir` from `/src/pkgs`.  
The symlinks are then tracked and removed once the program is uninstalled.

6. **Lightweight**

These are lightweight/embedded technologies incorporated into bonsai as to be more "suckless" alternatives to conventional GNU/Linux software.

**C Library**: [musl-libc](http://www.musl-libc.org/)  
**Libraries**: [libressl](http://www.libressl.org/) [libnl-tiny](http://openwrt.org/docs/techref/libnl#libnl-tiny) [netbsd-curses](http://github.com/sabotage-linux/netbsd-curses) [libedit](http://thrysoee.dk/editline)  
**Init System**: [sinit](http://core.suckless.org/sinit) [rc](http://github.com/mitchweaver/bonsai/tree/master/ports/@init)  
**Userland**: [sbase](http://core.suckless.org/sbase) [ubase](http://core.suckless.org/ubase) [hbase](http://github.com/mitchweaver/hbase)   
**Shell**: [dash](http://gondor.apana.org.au/~herbert/dash)  
**Build Automation**: [pkgconf](http://pkgconf.org/) [mk](http://9fans.github.io/plan9port/unix) [samurai](http://github.com/michaelforney/samurai)  
**Networking**: [sdhcp](http://core.suckless.org/sdhcp) [dropbear](http://matt.ucc.asn.au/dropbear/dropbear.html)  
**Compression**: [libarchive](http://libarchive.org/) [xz-embedded](http://tukaani.org/xz/embedded.html)  
**Device Management**: [smdev](http://core.suckless.org/smdev) [nldev](http://git.r-36.net/nldev/)  
**Misc Utilities**: [one-true-awk](http://github.com/onetrueawk/awk)

## Special thanks to

* [Alpine Linux](https://alpinelinux.org/)
* [Sabotage Linux](https://github.com/sabotage-linux/sabotage)
* [Morpheus Linux](https://morpheus.2f30.org/)
* [Stali Linux](http://sta.li)
* [KISS Linux](https://getkiss.org/)
* [CRUX Linux](http://crux.nu)
* [OpenBSD](http://openbsd.org)

Inspirations, technologies, and patches have all been taken
from these wonderful projects.

**Also**:

* Rich Felker's work on [musl-crossmake](https://github.com/richfelker/musl-cross-make) for ease of musl toolchain compilation
* The folks at [musl.cc](musl.cc) for providing statically-compiled toolchain binaries

----

### Achtung!
This is heavily still a WIP.  
There are bugs. There are snakes.  
Do not use in production.  

----

### Support

Star it! 🌟

It helps get it higher in GitHub's search results and motivates 
us to continue development.

If you would like to contribute, look into submitting a pull request.  
You can see our contributing guidelines [here](CONTRIBUTING.md).

### Community 

**discord server**: [discord.gg/qcjRGZv](http://discord.gg/qcjRGZv)  
**website**: [bonsai-linux.org](http://bonsai-linux.org) <sub>*(under construction)*</sub>  
**email**: dev@bonsai-linux.org  
**irc**: `coming soon`  
**mailing list**: `coming soon`
