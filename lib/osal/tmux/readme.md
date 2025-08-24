# TMUX


TMUX is a very capable process manager.

### Concepts

- tmux = is the factory, it represents the tmux process manager, linked to a node
- session = is a set of windows, it has a name and groups windows
- window = is typically one process running (you can have panes but in our implementation we skip this)


## structure

tmux library provides functions for managing tmux sessions

- session is the top one
- then windows (is where you see the app running)
- then panes in windows (we don't support yet)


## to attach to a tmux session

> TODO:
## HeroScript Usage Examples

```heroscript
!!tmux.session_create 
    name:'mysession'
    reset:true

!!tmux.session_delete 
    name:'mysession'

!!tmux.window_create 
    name:"mysession|mywindow"
    cmd:'htop'
    env:'VAR1=value1,VAR2=value2'
    reset:true

!!tmux.window_delete 
    name:"mysession|mywindow"

!!tmux.pane_execute 
    name:"mysession|mywindow|mypane" 
    cmd:'ls -la'

!!tmux.pane_kill 
    name:"mysession|mywindow|mypane"
```