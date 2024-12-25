# ${model.name}

${model.title}

To get started

```vlang

@if model.cat == .installer

import freeflowuniverse.herolib.installers.something.${model.name} as ${model.name}_installer

heroscript:="
!!${model.name}.configure name:'test'
	password: '1234'
	port: 7701

!!${model.name}.start name:'test' reset:1 
"

${model.name}_installer.play(heroscript=heroscript)!

//or we can call the default and do a start with reset
//mut installer:= ${model.name}_installer.get()!
//installer.start(reset:true)!

@else

import freeflowuniverse.herolib.clients. ${model.name}

mut client:= ${model.name}.get()!

client...

@end



```

## example heroscript

@if model.cat == .installer
```hero
!!${model.name}.configure
    homedir: '/home/user/${model.name}'
    username: 'admin'
    password: 'secretpassword'
    title: 'Some Title'
    host: 'localhost'
    port: 8888

```
@else
```hero
!!${model.name}.configure
    secret: '...'
    host: 'localhost'
    port: 8888
```
@end


