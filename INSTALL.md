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

2. **set chroot location**

```sh
export root=/path/to/chroot
```

Decide where you want your chroot to be built. `bonsai` and its makefile reads this variable from the environment.

By default, this will be `./build`. If you wish to use this, use `root="$PWD"/build`.

3. **build and install**

```sh
make
make install
```

The above will compile all the scripts into one executable, strip it of 
comments/blank lines, then install it to your `$root` location.

5. **bootstrap**

```sh
./bonsai --bootstrap
```

This will create dirs, assign permissions, and install the base system.

6. **relink**

```sh
./bonsai --relink-world --chroot
```

This relinks all package symlinks to `/src/pkgs` instead of `$root/src/pkgs`.

It is necessary as if you had not, when you chroot in all the symlinks will be broken
as they do not point to files on the correct root.

7. **chroot**

You have two options: 1. do this manually or 2. use the `chroot.sh` tool from the [tools](http://github.com/bonsai-linux/tools) repo.

The tools script comes highly recommended, however if you wish do so manually:

```sh
mount -o bind -t devtmpfs /dev  $root/dev
mount -o bind -t proc     /proc $root/proc
mount -o bind -t sysfs    /sys  $root/sys
root= chroot $root /bin/sh
```

Notice that we unset the `$root` here for the `chroot` command.  
This is because when inside the chroot, we want root to be `/` not `$root`.

8. **exit**

Exit the chroot. If you used the `chroot.sh` script, drives will be unmounted automatically.

----

<img width="8%" height="8%" align="right" src="res/bonsai.png">

If the above all completed successfully, **congratulations**!  
You have just installed your `bonsai` chroot!

----

### Post-Install

Many key programs will be missing from your chroot with only `@stage0` installed.  
Once chrooted in, you should then `bonsai @stage1` to finish your installation. 
