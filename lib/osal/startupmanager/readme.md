# startup manager

```go
import freeflowuniverse.herolib.osal.startupmanager
mut sm:=startupmanager.get()!


sm.start(
    name: 'myscreen'
    cmd: 'htop'
    description: '...'
)!

```


