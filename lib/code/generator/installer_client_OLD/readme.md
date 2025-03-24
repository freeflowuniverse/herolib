# generation framework for clients & installers

```bash
#generate all play commands
hero generate -playonly
#will ask questions if .heroscript is not there yet
hero generate -p thepath_is_optional
# to generate without questions
hero generate -p thepath_is_optional -t client
#if installer, default is a client
hero generate -p thepath_is_optional -t installer

#when you want to scan over multiple directories
hero generate -p thepath_is_optional -t installer -s 

```

there will be a ```.heroscript``` in the director you want to generate for, the format is as follows:

```hero
//for a server
!!hero_code.generate_installer
    name:'daguserver'
    classname:'DaguServer'
    singleton:1            //there can only be 1 object in the globals, is called 'default'
    templates:1            //are there templates for the installer
    title:''
    startupmanager:1      //managed by a startup manager, default true
    build:1                 //will we also build the component

//or for a client

!!hero_code.generate_client
  name:'mail'
  classname:'MailClient'
  singleton:0            //default is 0

```

needs to be put as .heroscript in the directories which we want to generate


## templates remarks

in templates:

- ^^ or @@ > gets replaced to @
- ?? > gets replaced to $

this is to make distinction between processing at compile time (pre-compile) or at runtime.

## call by code

to call in code

```v
#!/usr/bin/env -S v -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.code.generator.generic

generic.scan(path:"~/code/github/freeflowuniverse/herolib/herolib/installers",force:true)!


```

to run from bash

```bash
~/code/github/freeflowuniverse/herolib/scripts/fix_installers.vsh
```

