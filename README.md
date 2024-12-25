# herolib

a smaller version of herolib with only the items we need for hero

> [documentation here](https://freeflowuniverse.github.io/herolib/)

## automated install

```bash
curl 'https://raw.githubusercontent.com/freeflowuniverse/herolib/refs/heads/main/install_v.sh' > /tmp/install_v.sh
bash /tmp/install_v.sh --analyzer --herolib 
#DONT FORGET TO START A NEW SHELL (otherwise the paths will not be set)
```

### details

```bash

#~/code/github/freeflowuniverse/herolib/install_v.sh --help

V & HeroLib Installer Script

Usage: ~/code/github/freeflowuniverse/herolib/install_v.sh [options]

Options:
  -h, --help     Show this help message
  --reset        Force reinstallation of V
  --remove       Remove V installation and exit
  --analyzer     Install/update v-analyzer
  --herolib      Install our herolib

Examples:
  ~/code/github/freeflowuniverse/herolib/install_v.sh
  ~/code/github/freeflowuniverse/herolib/install_v.sh --reset
  ~/code/github/freeflowuniverse/herolib/install_v.sh --remove
  ~/code/github/freeflowuniverse/herolib/install_v.sh --analyzer
  ~/code/github/freeflowuniverse/herolib/install_v.sh --herolib
  ~/code/github/freeflowuniverse/herolib/install_v.sh --reset --analyzer # Fresh install of both

```

### to test

to run the basic tests, important !!!

```bash
~/code/github/freeflowuniverse/herolib/test_basic.vsh
```

```bash
vtest ~/code/github/freeflowuniverse/herolib/lib/osal/package_test.v
#for a full dir
vtest ~/code/github/freeflowuniverse/herolib/lib/osal

#to do al basic tests
~/code/github/freeflowuniverse/herolib/test_basic.vsh

```
vtest is an alias to test functionality


## important to read

- [aiprompts/starter/0_start_here.md](aiprompts/starter/0_start_here.md)
