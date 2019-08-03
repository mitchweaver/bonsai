# <img width="40" height="40" src="res/bonsai_square.png"> Contributing

### Overview

* Sync with master and squash commits before pull requesting.
* Don't try to do too much with each commit, limit scope, be reasonable.
* Use our code and commit [style](#style).
* Stick to the [porting-guidelines](#porting-guidelines).

# Style

### Use POSIX shell

I hoped this one would go without saying, but do not use "[bashisms](https://en.wiktionary.org/wiki/bashism)".

### Shellcheck

Every pull request must pass shellcheck to be accepted.

### Comments

Comment heavily. Our makefile strips comments from the executable so there is no excuse for being "lean".

For functions that aren't immediately obvious, use this heading format:

```bash
# downloads url and extracts to $work/$pkg
# params: none
# assumes: $name $version $source $pkgid $pkgfile in environment
get() {
...
}
```

### Safety

Any time a change to a user's folder or file is made, 
make sure that the variable is set.

<sub>**Example:**</sub>
```bash
rm -r "${dir:?}"
```

Here, `$dir` will expand to `?` if unset -- rendering the `rm` non-functional.

I have to state: **do not underestimate the importance of this**.

Imagine what what happen if both of these variables were unset here:  
`rm -rf "$bonsaihome"/"$tmp"`

### Clean up after yourself

Every function should `unset` any variable and `unset -f` any function it creates.

### If you can, prevent variables from being created (within reason)

Take this simple function for example:

```bash
# remove leading/trailing whitespace
trim() {
    set -- "${1#${1%%[! ]*}}"
    set -- "${1%${_##*[! ]}}"
    printf '%s\n' "$1"
}
```

Here, manipulating the `$1` variable in the argument array eliminates  
the need for us to create a variable and then unset it.

### Try to stay within 80 character line widths

This makes reading your code on a terminal much easier and is the standard convention.

For a line that shows this in vim use: `:set colorcolumn=80`

### Squash single-line ifs

Squash if statements if they can fit on one line, within the 80 char limit.

<sub>**DO:**</sub>
```bash
[ -f "$file" ] && echo 'File exists!'
```
<sub>**DON'T:**</sub>
```bash
if [ -f "$file" ] ; then
    echo 'File exists!'
fi
```

### Use single-quotes whenever possible

If you are not using a variable or subshell use single `'` quotes.  
This guarantees whatever it is will be interpreted as only a string and not any possible special characters.  
*Always* use this for URLs.

<sub>**DO:**</sub>
```bash
var='/bin/sh certainly^ won`t # hav$ a pr@blem (here)&'
```
<sub>**DON'T:**</sub>
```bash
var="/bin/sh certainly^ won`t hav$ a pr@blem (here)&"
# oh yes, it will --^
```

# Porting Guidelines

### Use http://

Always prefer `http://` over `https://` links.  
This is to not require `LibreSSL` as a hard build dependency for otherwise small programs.

### Use mirrors

The main download sites for software get the most traffic and are often down.  
With that said, make sure you use an official, trusted mirror.

### Do not use git in official ports

If you want to use `git` to get "bleeding edge" updates of your programs -- that's fine.  
However use tarballs for official ports. This is to not require `git` be in the core-system as a depedency.

Can't find a hosted tarball? Have no fear! GitHub can generate you one from any commit hash.

**<sub>Example:**</sub>

```bash
info='an awesome package'
version=6340629c52b16392fe2e0b4522860b832e7fae75
source=http://github.com/foobar/$name/archive/$version.tar.gz
sha256=58db744a9198327f185355c6c9b3ee2bc7e55af4f5b02bba7b2f7de12c4088ed
```

### List dependencies

Triple check to make sure you have all of the dependencies listed.  
It's wise to test your port in a new chroot with only `bonsai-core` installed to make sure that it compiles.

### Do not list sub-dependencies

Only list the top-most dependencies of a port.

<sub>**Example: bash**</sub>

`bash` requires both `libedit` and `netbsd-curses`,  
however `netbsd-curses` is required by `libedit`

The tree looks like this:
```
bash 
  └──libedit
        └──netbsd-curses
```
Therefore `bash`'s dependencies should look like:
```
deps=libedit
```

### Prefer sha256

`bonsai` will accept most checksum formats if given,
however for official ports `sha256` is preferred.  
Reasoning: `md5sum` and `sha1` are now considered insecure and `sha512` generates
obnoxiously long hashes.

### Prefer `xz` over `gz` or `bz2`

* smaller source tarball sizes
* roughly the same speed for small archives
* and for the love of unix try not to use `zip`

### DO and DON'T  --  a ports final review

* Write an `info=` description
* Use `sha256=`
* Use `$name` and `$version` in the `source=` if possible
* Use `http://` over `https://`
* Do not overwrite build functions if unnecessary

Example:

<sub>**DO:**</sub>

```bash
info='an awesome package'
version=0.4.8
source=http://github.com/foobar/$name/archive/v$version.tar.gz
deps=bash
sha256=58db744a9198327f185355c6c9b3ee2bc7e55af4f5b02bba7b2f7de12c4088ed
```

<sub>**DON'T:**</sub>

```bash
info='an awesome package'
version=0.4.8
source=https://github.com/foobar/an-awesome-package/archive/v0.4.8.tar.gz
deps='bash net-bsd-curses libedit'
md5=70d103eb8d196d188b516ee030bf3ab3
prebuild() { bonsai_patch ; }
build() { bonsai_make ; bonsai_make install ; }
postbuild { : ; }
```
