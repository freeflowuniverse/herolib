# screen



To get started

```v


import freeflowuniverse.herolib.installers.something.screen as screen_installer

heroscript:="
!!screen.configure name:'test'
    password: '1234'
    port: 7701

!!screen.start name:'test' reset:1 
"

screen_installer.play(heroscript=heroscript)!

//or we can call the default and do a start with reset
//mut installer:= screen_installer.get()!
//installer.start(reset:true)!




```

## example heroscript

```hero
!!screen.configure
    homedir: '/home/user/screen'
    username: 'admin'
    password: 'secretpassword'
    title: 'Some Title'
    host: 'localhost'
    port: 8888

```


