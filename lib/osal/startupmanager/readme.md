# startup manager

```go
import freeflowuniverse.herolib.sysadmin.startupmanager
mut sm:=startupmanager.get()!


sm.start(
    name: 'myscreen'
    cmd: 'htop'
    description: '...'
)!

```


