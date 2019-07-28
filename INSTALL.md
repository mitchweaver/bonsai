# install

#### Preface

This is a quick and dirty guide.  
Expect this to be fleshed out over many pages 
with lengthy explanations in the actual handbook.

----

1. **clone**

```bash
git clone http://github.com/mitchweaver/bonsai
cd bonsai
```

2. **build and install**

```bash
make
make install
```

The above will compile all the scripts into one executable, then strip it of 
comments/blank lines.

Next, it will install to the (default) directory of `~/.local/bonsai/src/bonsai`.

3. **config**

```bash
./bonsai skel
```

This will copy a default skeleton config to `~/.local/bonsai/src/bonsai.rc`.

4. **bootstrap**

```bash
./bonsai core-system
```

This will create dirs, permissions, etc -- and install the base system.

5. **relink**

```bash
./bonsai --relink-world --pkgs=/src/pkgs
```

This relinks all the symlinks to `root=/src/pkgs` instead of `root=~/.local/bonsai/src/pkgs`.

It is necessary as if you had not, when you chroot in all the symlinks will be broken
as they do not point to files on the correct root.

7. **chroot**

```bash
./bonsai chroot
```

Assuming `core-system` installed correctly and `--relink-world` succeeded,
this will chroot inside, mounting drives automatically.

8. **exit**

Exit the chroot, unmounting drives automatically.

----

If the above all completed successfully, **congratulations**!  
You have just installed your `bonsai` chroot!

![image](res/bonsai.png)
