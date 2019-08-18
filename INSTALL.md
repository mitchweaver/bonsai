# <img width="40" height="40" src="res/bonsai_square.png"> Install

#### Preface

This is a quick and dirty guide.  
Expect this to be fleshed out over many pages 
with lengthy explanations in the actual handbook.

----

1. **clone**

```sh
git clone http://github.com/bonsai-linux/bonsai
cd bonsai
```

2. **build and install**

```sh
make
make PREFIX="$PREFIX" install
```

The above will compile all the scripts into one executable, then strip it of 
comments/blank lines.

`"$PREFIX"` here is wherever you would like your chroot to be located.  
If you are planning to install to hardware, then this will be where your drive is mounted.

Omitting `PREFIX=` will install to the (default) directory of `~/.local/bonsai`.

3. **bootstrap**

```sh
./bonsai --bootstrap
```

This will create dirs, assign permissions, and install the base system.

----

**Note:** If you are planning to install bonsai either to bare metal or QEMU instead 
using it as a chrootfs, you will also need to add `@init`.

4. **relink**

```sh
./bonsai --relink-world --pkgs=/src/pkgs
```

This relinks all the symlinks to `root=/src/pkgs` instead of `root=~/.local/bonsai/src/pkgs`.

It is necessary as if you had not, when you chroot in all the symlinks will be broken
as they do not point to files on the correct root.

5. **chroot**

You have two options: 1. do this manually or 2. use the `chroot.sh` tool from the [tools](http://github.com/bonsai-linux/tools) repo.

The tools script comes highly recommended, however if you wish do so manually:

```sh
mount -o bind -t devtmpfs /dev     $chroot/dev
mount -o bind -t proc     /proc    $chroot/proc
mount -o bind -t sysfs    /sys     $chroot/sys
```

6. **exit**

Exit the chroot, unmounting drives automatically.

----

If the above all completed successfully, **congratulations**!  
You have just installed your `bonsai` chroot!

![image](res/bonsai.png)
