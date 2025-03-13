# qdrant



To get started

```vlang


import freeflowuniverse.herolib.installers.something.qdrant as qdrant_installer

heroscript:="
!!qdrant.configure name:'test'
    password: '1234'
    port: 7701

!!qdrant.start name:'test' reset:1 
"

qdrant_installer.play(heroscript=heroscript)!

//or we can call the default and do a start with reset
//mut installer:= qdrant_installer.get()!
//installer.start(reset:true)!




```

## example heroscript

```hero
!!qdrant.configure
    homedir: '/home/user/qdrant'
    username: 'admin'
    password: 'secretpassword'
    title: 'Some Title'
    host: 'localhost'
    port: 8888

```


