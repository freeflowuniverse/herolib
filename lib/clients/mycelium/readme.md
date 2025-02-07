# Mycelium Client

A V client library for interacting with the Mycelium messaging system. This client provides functionality for sending, receiving, and managing messages through a Mycelium server.

## Configuration

The client can be configured either through V code or using heroscript.

### V Code Configuration

```v
import freeflowuniverse.herolib.clients.mycelium

mut client := mycelium.get()!

// By default connects to http://localhost:8989/api/v1/messages
// To use a different server:
mut client := mycelium.get(name: "custom", server_url: "http://myserver:8989/api/v1/messages")!
```

### Heroscript Configuration

```hero
!!mycelium.configure
    name:'custom'                                           # optional, defaults to 'default'
    server_url:'http://myserver:8989/api/v1/messages'      # optional, defaults to localhost:8989
```

Note: Configuration is not needed if using a locally running Mycelium server with default settings.

## Example Script

Save as `mycelium_example.vsh`:

```v
#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.clients.mycelium

// Initialize client
mut client := mycelium.get()!

// Send a message and wait for reply
msg := client.send_msg(
    pk: "recipient_public_key"
    payload: "Hello!"
    wait: true  // wait for reply (timeout 120s)
)!
println('Message sent with ID: ${msg.id}')

// Check message status
status := client.get_msg_status(msg.id)!
println('Message status: ${status.state}')

// Receive messages with timeout
if incoming := client.receive_msg_opt(wait: true) {
    println('Received message: ${incoming.payload}')
    println('From: ${incoming.src_pk}')
    
    // Reply to the message
    client.reply_msg(
        id: incoming.id
        pk: incoming.src_pk
        payload: "Got your message!"
    )!
}
```

## API Reference

### Sending Messages

```v
// Send a message to a specific public key
// wait=true means wait for reply (timeout 120s)
msg := client.send_msg(pk: "recipient_public_key", payload: "Hello!", wait: true)!

// Get status of a sent message
status := client.get_msg_status(id: "message_id")!
```

### Receiving Messages

```v
// Receive a message (non-blocking)
msg := client.receive_msg(wait: false)!

// Receive a message with timeout (blocking for 60s)
msg := client.receive_msg(wait: true)!

// Receive a message (returns none if no message available)
if msg := client.receive_msg_opt(wait: false) {
    println('Received: ${msg.payload}')
}
```

### Replying to Messages

```v
// Reply to a specific message
client.reply_msg(
    id: "original_message_id",
    pk: "sender_public_key",
    payload: "Reply message"
)!
```

## Message Types

### InboundMessage
```v
struct InboundMessage {
    id      string
    src_ip  string
    src_pk  string
    dst_ip  string
    dst_pk  string
    payload string
}
```

### MessageStatusResponse
```v
struct MessageStatusResponse {
    id       string
    dst      string
    state    string
    created  string
    deadline string
    msg_len  string
}
```

## Heroscript Complete Example

```hero
!!mycelium.configure
    name:'mycelium'
    server_url:'http://localhost:8989/api/v1/messages'

# More heroscript commands can be added here as the API expands
