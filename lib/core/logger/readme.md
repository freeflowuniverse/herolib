# Logger Module

A simple logging system that provides structured logging with search capabilities. 

Logs are stored in hourly files with a consistent format that makes them both human-readable and machine-parseable.

## Features

- Structured logging with categories and error types
- Automatic timestamp management
- Multi-line message support
- Search functionality with filtering options
- Human-readable log format

## Usage

```v
import freeflowuniverse.herolib.core.logger
import freeflowuniverse.herolib.data.ourtime

// Create a new logger
mut l := logger.new(path: '/var/logs')!

// Log a message
l.log(
    cat: 'system',
    log: 'System started successfully',
    logtype: .stdout
)!

// Log an error
l.log(
    cat: 'system',
    log: 'Failed to connect\nRetrying in 5 seconds...',
    logtype: .error
)!

// Search logs
results := l.search(
    timestamp_from: ourtime.now().warp("-24h"), // Last 24 hours
    cat: 'system',                               // Filter by category
    log: 'failed',                              // Search in message content
    logtype: .error,                            // Only error messages
    maxitems: 100                               // Limit results
)!
```

## Log Format

```
$time
    $cat       - $msg
	   $cat       - first line of message
				    second line of message
				    third line ... 
E   $cat       - first line of message
E				second line of message
E 				third line ... 
```		 

- time is expressed in '1980-07-11 21:23:42' == time_to_test.format_ss()
- if cat has '-' inside it will be converted to '_'
- $cat max 10 chars, and always takes the 10 chars so that the logs are nicely formatted
- the first char is ' ' or 'E' , E means its the logtype error
