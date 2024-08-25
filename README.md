# bonsai

```
# -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/- #
#                                                         #
#                   ,####,                                #
#                   #######,  ,#####,                     #
#                   #####',#  '######                     #
#                   ''###'';,,,'###'                      #
#                          ,;  ''''                       #
#                         ;;;   ,#####,                   #
#                        ;;;'  ,,;;;###                   #
#                        ';;;;'''####'                    #
#                         ;;;                             #
#                      ,.;;';'',,,                        #
#               #     '     '                             #
#               #                        O                #
#               ##, ,##,',##, ,##  ,#,   ,                #
#               # # #  # #''# #,,  # #   #                #
#               '#' '##' #  #  ,,# '##;, #                #
#                                                         #
#                                                         #
#          http://github.com/mitchweaver/bonsai           #
#                                                         #
#                      * NOTICE *                         #
#                                                         #
#       In early development. Not intended for use.       #
#                                                         #
# -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/- #
```

## Bonsai

Originally the package manager of a now extinct hobby Linux distribution,
`bonsai` is small package manager meant to be cross-platform and extremely
simple to use. Written in POSIX shell with only basic UNIX utilities
as dependencies, it's meant to be able to be pulled down on any machine
to quickly get access to the programs you need, root access not required.

Nowadays I personally use it for miscellaneous things not commonly
found in distros. Not meant for public use.

Maybe it will be helpful to you too.  
Feel free to open github issues/PR as needed.

\- Mitch

---

## Installation

```
git clone https://github.com/mitchweaver/bonsai
cd bonsai
make
make install
```

## Environment

```
cat >> ~/.profile <<EOF
if [ -d ~/.bonsai ] ; then
    export PATH="${HOME}/.bonsai/bin:$PATH"
    export MANPATH="${HOME}/.bonsai/share/man:$MANPATH"
fi
EOF
```

```
# generate skeleton config files
bs a @cfg
```

## Usage

```
bs -h
```

## Notice

Currently only targeting amd64.

