# <img width="40" height="40" src="res/bonsai_square.png"> FAQ

### 01. Why am I seeing paths in compiler messages prefixed with `//`?

This is because throughout `bonsai` we use a `"$root"` variable so
it can function seamlessly either inside or outside of a chroot.  

When outside the chroot, `"$root"` is how it is set in your `bonsai.rc`.  
<sub>**Example:**</sub>  
`root="~/.local/bonsai"`

However when inside the chroot, `"$root"` gets equated to `/`, so now paths listed
as `"$root"/some/path` become `//some/path`.

But have no worries! Multiple leading slashes are [collapsed down](http://www.opengroup.org/onlinepubs/009695399/basedefs/xbd_chap03.html#tag_03_266) as per POSIX standards.

### 02. My favorite GNU program isn't installed!

Yes. We do not use GNU `coreutils` or `util-linux`.  
Instead our userland consists of `sbase`, `ubase`, and `hbase`.

If something is missing, it's probably a package -- usually prefixed with `gnu-`.

If a port isn't available, you're welcome to [port it yourself](http://github.com/mitchweaver/bonsai/wiki/Porting-Guidelines).

### 03. Why not use `busybox`?

Busybox is a suite of minimal, unfortunately [GPL](http://busybox.net/license.html),
programs with the same goals as our `sbase`, `ubase`, and `hbase`.

While it is a good collection, our userland is *much smaller*.  
Our `sbase` and `ubase` are also built *"box-style"* as popularized by `busybox`.

If you would like to use busybox instead however, you can!

Perhaps in the future we will add a `bs-core-busybox` alternative to `bs-core`.

### 04. I'm getting tons of errors when chrooting in

Make sure your `root=` variable is set correctly in your `bonsai.rc`.

If you don't care about saving your config, you can just grab a 
new skeleton with `bonsai skel`.

<sub>**Explanation:**</sub>  
When unchrooted, `$root` it should be where the chroot lives.  
<sub>*(default)*: `root="~/.local/bonsai"` </sub>

Then, when chrooting, `$root` will get changed to `root=/`.  
Upon exiting the original value gets restored.

### Something else? Come ask us!

See the **#community** section in the README.md
