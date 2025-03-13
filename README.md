# herolib


> [documentation of the library](https://freeflowuniverse.github.io/herolib/)

## hero install  for users 

```bash
curl https://raw.githubusercontent.com/freeflowuniverse/herolib/refs/heads/development/install_hero.sh > /tmp/install_hero.sh
bash /tmp/install_hero.sh

```

this tool can be used to work with git, build books, play with hero AI, ...

## automated install for developers

```bash
curl 'https://raw.githubusercontent.com/freeflowuniverse/herolib/refs/heads/development/install_v.sh' > /tmp/install_v.sh
bash /tmp/install_v.sh --analyzer --herolib 
#DONT FORGET TO START A NEW SHELL (otherwise the paths will not be set)
```

### details

```bash

~/code/github/freeflowuniverse/herolib/install_v.sh --help

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


## Troubleshooting

### TCC Compiler Error on macOS

If you encounter the following error when using TCC compiler on macOS:

```
In file included from /Users/timurgordon/code/github/vlang/v/thirdparty/cJSON/cJSON.c:42:
/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/math.h:614: error: ';' expected (got "__fabsf16")
```

This is caused by incompatibility between TCC and the half precision math functions in the macOS SDK. To fix this issue:

1. Open the math.h file:
   ```bash
   sudo nano /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/math.h
   ```

2. Comment out the following lines (around line 612-626):
   ```c
   /* half precision math functions */
   // extern _Float16 __fabsf16(_Float16) __API_AVAILABLE(macos(15.0), ios(18.0), watchos(11.0), tvos(18.0));
   // extern _Float16 __hypotf16(_Float16, _Float16) __API_AVAILABLE(macos(15.0), ios(18.0), watchos(11.0), tvos(18.0));
   // extern _Float16 __sqrtf16(_Float16) __API_AVAILABLE(macos(15.0), ios(18.0), watchos(11.0), tvos(18.0));
   // extern _Float16 __ceilf16(_Float16) __API_AVAILABLE(macos(15.0), ios(18.0), watchos(11.0), tvos(18.0));
   // extern _Float16 __floorf16(_Float16) __API_AVAILABLE(macos(15.0), ios(18.0), watchos(11.0), tvos(18.0));
   // extern _Float16 __rintf16(_Float16) __API_AVAILABLE(macos(15.0), ios(18.0), watchos(11.0), tvos(18.0));
   // extern _Float16 __roundf16(_Float16) __API_AVAILABLE(macos(15.0), ios(18.0), watchos(11.0), tvos(18.0));
   // extern _Float16 __truncf16(_Float16) __API_AVAILABLE(macos(15.0), ios(18.0), watchos(11.0), tvos(18.0));
   // extern _Float16 __copysignf16(_Float16, _Float16) __API_AVAILABLE(macos(15.0), ios(18.0), watchos(11.0), tvos(18.0));
   // extern _Float16 __nextafterf16(_Float16, _Float16) __API_AVAILABLE(macos(15.0), ios(18.0), watchos(11.0), tvos(18.0));
   // extern _Float16 __fmaxf16(_Float16, _Float16) __API_AVAILABLE(macos(15.0), ios(18.0), watchos(11.0), tvos(18.0));
   // extern _Float16 __fminf16(_Float16, _Float16) __API_AVAILABLE(macos(15.0), ios(18.0), watchos(11.0), tvos(18.0));
   // extern _Float16 __fmaf16(_Float16, _Float16, _Float16) __API_AVAILABLE(macos(15.0), ios(18.0), watchos(11.0), tvos(18.0));
   ```

3. Save the file and try compiling again.

## important to read

- [aiprompts/starter/0_start_here.md](aiprompts/starter/0_start_here.md)
