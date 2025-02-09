#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.clients.mycelium 

mycelium.delete()!

mut r:=mycelium.inspect()!
println("My pub key: ${r.public_key}")

mut client := mycelium.get()!
println(client)

// Send a message to a node by public key
// Parameters: public_key, payload, topic, wait_for_reply
msg := client.send_msg(
    r.public_key, // destination public key
    'Hello World', // message payload
    'greetings', // optional topic
    false // wait for reply
)!

println('Sent message ID: ${msg.id}')
println("send succeeded")

// Receive messages
// Parameters: wait_for_message, peek_only, topic_filter
received := client.receive_msg(true, false, 'greetings')!
println('Received message from: ${received.src_pk}')
println('Message payload: ${received.payload}')

// // Reply to a message
// client.reply_msg(
//     received.id, // original message ID
//     received.src_pk, // sender's public key
//     'Got your message!', // reply payload
//     'greetings' // topic
// )!

// // Check message status
// status := client.get_msg_status(msg.id)!
// println('Message status: ${status.state}')
// println('Created at: ${status.created}')
// println('Expires at: ${status.deadline}')