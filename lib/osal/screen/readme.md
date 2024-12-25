# Screen

The Screen module provides a V interface to manage GNU Screen sessions.

## Example Script

Create a file `screen_example.vsh`:

```v
#!/usr/bin/env -S v run

import freeflowuniverse.herolib.osal.screen

// Create a new screen session with hardcoded parameters
mut s := screen.Screen{
    name: 'test_session'
    cmd: '/bin/bash'  // Default shell
}

// Check if screen is running
is_running := s.is_running() or { 
    println('Error checking screen status: ${err}')
    return 
}

// Get session status
status := s.status() or {
    println('Error getting status: ${err}')
    return
}

// Send a command to the screen session
s.cmd_send('ls -la') or {
    println('Error sending command: ${err}')
    return
}

// Attach to the session
s.attach() or {
    println('Error attaching: ${err}')
    return
}
```

## Basic Screen Commands

```bash
#to see sessions which have been created
screen -ls

There is a screen on:
    3230.test    (Detached)

#now to attach to this screen
screen -r test
```

## Testing

```bash
vtest ~/code/github/freeflowuniverse/herolib/lib/osal/screen/screen_test.v
