# herolib

a smaller version of crystallib with only the items we need for hero

## automated install

```bash
curl 'https://raw.githubusercontent.com/freeflowuniverse/herolib/refs/heads/main/install_v.sh' > /tmp/install_v.sh
bash /tmp/install_v.sh --analyzer --herolib 
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

