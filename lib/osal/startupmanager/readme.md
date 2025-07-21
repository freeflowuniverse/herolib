# startup manager

```go
import freeflowuniverse.herolib.osal.core.startupmanager
mut sm:=startupmanager.get()!


sm.start(
    name: 'myscreen'
    cmd: 'htop'
    description: '...'
)!

```


