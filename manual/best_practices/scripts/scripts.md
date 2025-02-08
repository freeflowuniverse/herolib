# Scripts

Lets stop using bash files and use v for everything

example would be


```go
#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

fn sh(cmd string) {
	println('❯ ${cmd}')
	print(execute_or_exit(cmd).output)
}

//super handy trick to go to where the file is
abs_dir_of_script := dir(@FILE)


sh('
set -ex
cd ${abs_dir_of_script}

')

//the $ shows its a compile time argument, will only put it compiled if linux
$if !linux {
	println('AM IN LINUX')
}

```

## argument parsing

```v
#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

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
