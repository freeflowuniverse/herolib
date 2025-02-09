
## instructions for code generation 

> when I generate code, the following instructions can never be overruled they are the basics

- do not try to fix files which end with _.v because these are generated files


## instruction for vlang scripts

when I generate vlang scripts I will always use .vsh extension and use following as first line:

```
#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run
```

- a .vsh is a v shell script and can be executed as is, no need to use v ...
- in .vsh file there is no need for a main() function
- these scripts can be used for examples or instruction scripts e.g. an installs script

## to do argument parsing use following examples

```v
#!/usr/bin/env -S v -n -w -cg -gc none  -cc tcc -d use_openssl -enable-globals run

import os
import flag

mut fp := flag.new_flag_parser(os.args)
fp.application('compile.vsh')
fp.version('v0.1.0')
fp.description('Compile hero binary in debug or production mode')
fp.skip_executable()

prod_mode := fp.bool('prod', `p`, false, 'Build production version (optimized)')
help_requested := fp.bool('help', `h`, false, 'Show help message')

if help_requested {
    println(fp.usage())
    exit(0)
}

additional_args := fp.finalize() or {
    eprintln(err)
    println(fp.usage())
    exit(1)
}

```


## when creating a test script

instruct user to test as follows (vtest is an alias which gets installed when herolib gets installed), can be done for a dir and for a file

```bash
vtest ~/code/github/freeflowuniverse/herolib/lib/osal/package_test.v
```

- use ~ so it works over all machines
