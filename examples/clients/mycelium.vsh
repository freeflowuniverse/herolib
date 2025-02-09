#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.clients.mycelium

mycelium.delete()!

mut r := mycelium.inspect()!
println('My pub key: ${r.public_key}')

mut client := mycelium.get()!
println(client)

// Send a message to a node by public key
// Parameters: public_key, payload, topic, wait_for_reply
msg := client.send_msg(
	public_key: '0569a9c54da7a52b2ab3a2fb03f2b9be2c1c11d65d14a4888182bd12ed1dbf38' // destination public key
	payload:    'Hello World' // message payload
	topic:      'greetings'   // optional topic
)!

println('Sent message ID: ${msg.id}')
println('send succeeded')

// Receive messages
// Parameters: wait_for_message, peek_only, topic_filter
received := client.receive_msg(wait: true, peek: false, topic: 'greetings')!
println('Received message from: ${received.src_pk}')
println('Message payload: ${received.payload}')

// Reply to a message
client.reply_msg(
	id:         received.id
	public_key: received.src_pk
	payload:    'Got your message!'
	topic:      'greetings'
)!

// Check message status
status := client.get_msg_status(msg.id)!
println('Message status: ${status.state}')
println('Created at: ${status.created}')
println('Expires at: ${status.deadline}')
