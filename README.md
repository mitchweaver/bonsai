# bonsai
A truly minimal system that is *dumb easy* to setup, configure, and maintain.

A new way of thinking about software management.

# Core Philosophy

### *"Software shouldn't come with compromise."*

1. **Static Linking**
 
All programs should be statically linked.  
No [.dll hell](https://en.wikipedia.org/wiki/DLL_Hell), no searching through the filesystem.  
Minimize moving parts. Simpler is better.

2. **Sandboxing**

Chroot sandboxes should be ***dropdead simple*** to 
setup simply by copying the relevant statically-linked binaries.  

3. **A Better C Library**

GNU GLibc is massively bloated and a poor choice for static linking.  
[Musl-libc](http://musl-libc.org) is a fresh lightweight alternative 
that was [designed from the ground up](https://www.musl-libc.org/intro.html) 
to be used with static linking. 

Just take a look at this simple [hello world](http://0x0.st/zpbd.png) comparison.

Applications statically-linked
with musl carefully avoid pulling in large amounts of code or 
data that the application will not use and have no runtime 
dependencies. Many programs need patching to compile
under musl-libc, however this *almost always* makes their code better.

4. **Simplicity**

No matter how great, a system is bottlenecked by its ability to be understood.

* Sane and optimal default flags for both performance and security
* A modular automated build system with parts that can overriden simply be defining the given function in the pkgfile
* Easy-to-understand "3-phase" `prebuild()`, `build()`, and `postbuild()` functions
* Automatic detection of required flags, configs, patches, and workarounds
* Some ports can be written with *just one line*!
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
    ├── /pkgs      ←  packages
    ├── /ports     ←  pkgfiles
    ├── /sources   ←  tarballs
    ├── bonsai.rc    ←  config file
    └── bonsai.db    ←  database file
```

Inside each package is its own prefix with given `/bin`, `/lib`, etc

As a side effect of this, each `$pkgdir` is its own chroot filesystem that can
be used at will. In the future, this process is planned to be automated.

Symlinks are created from the package to the outsde root for seamless 
integration and standards compatibilty.

<sub>**Example:**</sub>

```bash
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

**C Library**: [musl-libc](https://www.musl-libc.org/)  
**Compiler**: [tcc](https://bellard.org/tcc) *(where possible)*  
**Libraries**: [LibreSSL](https://www.libressl.org/) [libnl-tiny](https://openwrt.org/docs/techref/libnl#libnl-tiny) [netbsd-curses](https://github.com/sabotage-linux/netbsd-curses) [libedit](http://thrysoee.dk/editline)  
**Init System**: [sinit](https://core.suckless.org/sinit)  
**Userland**: [sbase](http://core.suckless.org/sbase) [ubase](http://core.suckless.org/ubase) [hbase](http://github.com/mitchweaver/hbase)  
**Shell**: [dash](http://gondor.apana.org.au/~herbert/dash)  
**Build Automation**: [pkgconf](http://pkgconf.org/) [mk](https://9fans.github.io/plan9port/unix) [samurai](https://github.com/michaelforney/samurai)  
**Networking**: [sdhcp](http://core.suckless.org/sdhcp) [dropbear](https://matt.ucc.asn.au/dropbear/dropbear.html)  
**Compression**: [xz-embedded](http://tukaani.org/xz/embedded.html)  
**Device Management**: [smdev](http://core.suckless.org/smdev) [nldev](http://git.r-36.net/nldev/)  


## Special thanks to

* [Alpine Linux](https://alpinelinux.org/)
* [Sabotage Linux](https://github.com/sabotage-linux/sabotage)
* [Morpheus Linux](https://morpheus.2f30.org/)
* [Stali Linux](http://sta.li)
* [oasis](https://github.com/michaelforney/oasis)
* [KISS Linux](https://getkiss.org/)
* [CRUX Linux](http://crux.nu)
* [OpenBSD](http://openbsd.org)

Inspirations, technologies, and patches have all been taken
from these wonderful projects.

**Also**:

* Rich Felker's work on [musl-crossmake](https://github.com/richfelker/musl-cross-make) for ease of musl toolchain compilation
* The folks at [musl.cc](musl.cc) for providing statically-compiled toolchain binaries
* [suckless](http://suckless.org) and [cat-v](cat-v.org) projects for being a breath of fresh air in a world of insanity

----

### Achtung!
This is heavily still a WIP.  
There are bugs. There are snakes.  
Do not use in production.  

----

### Support

Star it! 🌟

It helps get it higher in GitHub's search results and motivates 
me to continue development.

If you would like to contribute, pull requests are __*always*__ encouraged!  

### Community 

**irc**: `moving hosts - TBA`  
**discord server** *(irc mirror)*: http://discord.gg/qcjRGZv  
**email**: `moving hosts - TBA`  
**mailing list**: `moving hosts - TBA`
