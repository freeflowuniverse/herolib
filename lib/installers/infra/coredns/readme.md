# coredns

coredns

To get started

```vlang


import freeflowuniverse.herolib.installers.infra.coredns as coredns_installer

heroscript:="
!!coredns.configure name:'test'
    config_path: '/etc/coredns/Corefile'
    dnszones_path: '/etc/coredns/zones'
    plugins: 'forward,cache'
    example: true

!!coredns.start name:'test' reset:1 
"

coredns_installer.play(heroscript=heroscript)!

//or we can call the default and do a start with reset
//mut installer:= coredns_installer.get()!
//installer.start(reset:true)!



```

## example heroscript

```hero
!!coredns.configure
    name: 'custom'
    config_path: '/etc/coredns/Corefile'
    config_url: 'https://github.com/example/coredns-config'
    dnszones_path: '/etc/coredns/zones'
    dnszones_url: 'https://github.com/example/dns-zones'
    plugins: 'forward,cache'
    example: false
```