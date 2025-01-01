# gitea



To get started

```vlang


import freeflowuniverse.herolib.installers.something.gitea as gitea_installer

heroscript:="
!!gitea.configure name:'test'
    password: '1234'
    port: 7701

!!gitea.start name:'test' reset:1 
"

gitea_installer.play(heroscript=heroscript)!

//or we can call the default and do a start with reset
//mut installer:= gitea_installer.get()!
//installer.start(reset:true)!




```

## example heroscript

```hero
!!gitea.configure
    homedir: '/home/user/gitea'
    username: 'admin'
    password: 'secretpassword'
    title: 'Some Title'
    host: 'localhost'
    port: 8888

```


