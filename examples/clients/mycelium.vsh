#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.clients.mycelium
import freeflowuniverse.herolib.installers.net.mycelium as mycelium_installer
import freeflowuniverse.herolib.osal
import time
import os

// Check if not installed install it.
mut installer := mycelium_installer.get()!
installer.install()!

mycelium.delete()!

spawn fn () {
	res := os.execute('mkdir -p /tmp/mycelium_server1 && cd /tmp/mycelium_server1 && mycelium --peers tcp://188.40.132.242:9651 quic://[2a01:4f8:212:fa6::2]:9651 tcp://185.69.166.7:9651 quic://[2a02:1802:5e:0:ec4:7aff:fe51:e36b]:9651 tcp://65.21.231.58:9651 quic://[2a01:4f9:5a:1042::2]:9651 tcp://[2604:a00:50:17b:9e6b:ff:fe1f:e054]:9651 quic://5.78.122.16:9651 tcp://[2a01:4ff:2f0:3621::1]:9651 quic://142.93.217.194:9651 --tun-name tun2 --tcp-listen-port 9652 --quic-listen-port 9653 --api-addr 127.0.0.1:9001')
	println('res: ${res}')
}()

spawn fn () {
	os.execute('mkdir -p /tmp/mycelium_server2 && cd /tmp/mycelium_server2 && mycelium --peers tcp://188.40.132.242:9651 quic://[2a01:4f8:212:fa6::2]:9651 tcp://185.69.166.7:9651 quic://[2a02:1802:5e:0:ec4:7aff:fe51:e36b]:9651 tcp://65.21.231.58:9651 quic://[2a01:4f9:5a:1042::2]:9651 tcp://[2604:a00:50:17b:9e6b:ff:fe1f:e054]:9651 quic://5.78.122.16:9651 tcp://[2a01:4ff:2f0:3621::1]:9651 quic://142.93.217.194:9651 --tun-name tun3 --tcp-listen-port 9654 --quic-listen-port 9655 --api-addr 127.0.0.1:9002')
}()

time.sleep(2 * time.second)

mut client1 := mycelium.get()!
client1.server_url = 'http://localhost:9001'
client1.name = 'client1'
println(client1)

mut client2 := mycelium.get()!
client2.server_url = 'http://localhost:9002'
client2.name = 'client2'
println(client2)

inspect1 := mycelium.inspect(key_file_path: '/tmp/mycelium_server1/priv_key.bin')!
inspect2 := mycelium.inspect(key_file_path: '/tmp/mycelium_server2/priv_key.bin')!

println('Server 1 public key: ${inspect1.public_key}')
println('Server 2 public key: ${inspect2.public_key}')

// // Send a message to a node by public key
// // Parameters: public_key, payload, topic, wait_for_reply
// msg := client.send_msg(
// 	public_key: '0569a9c54da7a52b2ab3a2fb03f2b9be2c1c11d65d14a4888182bd12ed1dbf38' // destination public key
// 	payload:    'Hello World' // message payload
// 	topic:      'greetings'   // optional topic
// )!

// println('Sent message ID: ${msg.id}')
// println('send succeeded')

// // Receive messages
// // Parameters: wait_for_message, peek_only, topic_filter
// received := client.receive_msg(wait: true, peek: false, topic: 'greetings')!
// println('Received message from: ${received.src_pk}')
// println('Message payload: ${received.payload}')

// // Reply to a message
// client.reply_msg(
// 	id:         received.id
// 	public_key: received.src_pk
// 	payload:    'Got your message!'
// 	topic:      'greetings'
// )!

// // Check message status
// status := client.get_msg_status(msg.id)!
// println('Message status: ${status.state}')
// println('Created at: ${status.created}')
// println('Expires at: ${status.deadline}')
