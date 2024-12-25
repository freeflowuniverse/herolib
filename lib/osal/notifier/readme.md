# Notifier Module

The Notifier module provides a simple and efficient way to monitor file system changes in V programs. It wraps the OS-level file system notification mechanisms and provides a clean API for watching files and directories.

## Features

- Watch multiple files/paths simultaneously
- Event-based callbacks for file changes
- Support for different types of events (create, modify, delete)
- Clean API for adding and removing watches

## Usage

### Basic Example

```v
import freeflowuniverse.herolib.osal.notifier

fn on_file_change(event notifier.NotifyEvent, path string) {
    match event {
        .create { println('File created: ${path}') }
        .modify { println('File modified: ${path}') }
        .delete { println('File deleted: ${path}') }
        .rename { println('File renamed: ${path}') }
    }
}

fn main() {
    // Create a new notifier
    mut n := notifier.new('my_watcher')!

    // Add a file to watch
    n.add_watch('path/to/file.txt', on_file_change)!

    // Start watching
    n.start()!

    // Keep the program running
    for {}
}
```

### Advanced Usage

```v
import freeflowuniverse.herolib.osal.notifier

fn main() {
    mut n := notifier.new('config_watcher')!
    
    // Watch multiple files
    n.add_watch('config.json', on_config_change)!
    n.add_watch('data.txt', on_data_change)!
    
    // Start watching
    n.start()!
    
    // ... do other work ...
    
    // Stop watching when done
    n.stop()
}

fn on_config_change(event notifier.NotifyEvent, path string) {
    if event == .modify {
        println('Config file changed, reloading...')
        // Reload configuration
    }
}

fn on_data_change(event notifier.NotifyEvent, path string) {
    println('Data file changed: ${event}')
}
```

## API Reference

### Structs

#### Notifier
```v
pub struct Notifier {
pub mut:
    name         string
    is_watching  bool
}
```

### Functions

#### new
```v
pub fn new(name string) !&Notifier
```
Creates a new Notifier instance with the given name.

#### add_watch
```v
pub fn (mut n Notifier) add_watch(path string, callback NotifyCallback) !
```
Adds a path to watch with an associated callback function.

#### remove_watch
```v
pub fn (mut n Notifier) remove_watch(path string) !
```
Removes a watched path.

#### start
```v
pub fn (mut n Notifier) start() !
```
Begins watching for file system events.

#### stop
```v
pub fn (mut n Notifier) stop()
```
Stops watching for events.

## Error Handling

The module uses V's error handling system. Most functions return a `!` type, indicating they can fail. Always handle potential errors appropriately:

```v
n := notifier.new('watcher') or {
    println('Failed to create notifier: ${err}')
    return
}
```

## Notes

- The notifier uses OS-level file system notification mechanisms for efficiency
- Callbacks are executed in a separate thread to avoid blocking
- Always call `stop()` when you're done watching to clean up resources
