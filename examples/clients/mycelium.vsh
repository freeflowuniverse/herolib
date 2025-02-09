#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.clients.mycelium
import freeflowuniverse.herolib.installers.net.mycelium as mycelium_installer
import freeflowuniverse.herolib.osal
import time
import os
import encoding.base64

const server1_port = 9001
const server2_port = 9002

fn terminate(port int) ! {
	// Step 1: Run lsof to get process details
	res := os.execute('lsof -i:${port}')
	if res.exit_code != 0 {
		return error('no service running at port ${port} due to: ${res.output}')
	}

	// Step 2: Parse the output to extract the PID
	lines := res.output.split('\n')
	if lines.len < 2 {
		return error('no process found running on port ${port}')
	}

	// The PID is the second column in the output
	fields := lines[1].split(' ')
	if fields.len < 2 {
		return error('failed to parse lsof output')
	}
	pid := fields[1]

	// Step 3: Kill the process using the PID
	kill_res := os.execute('kill ${pid}')
	if kill_res.exit_code != 0 {
		return error('failed to kill process ${pid}: ${kill_res.output}')
	}

	println('Successfully terminated process ${pid} running on port ${port}')
}

// Check if not installed install it.
mut installer := mycelium_installer.get()!
installer.install()!

mycelium.delete()!

spawn fn () {
	os.execute('mkdir -p /tmp/mycelium_server1 && cd /tmp/mycelium_server1 && mycelium --peers tcp://188.40.132.242:9651 quic://[2a01:4f8:212:fa6::2]:9651 tcp://185.69.166.7:9651 quic://[2a02:1802:5e:0:ec4:7aff:fe51:e36b]:9651 tcp://65.21.231.58:9651 quic://[2a01:4f9:5a:1042::2]:9651 tcp://[2604:a00:50:17b:9e6b:ff:fe1f:e054]:9651 quic://5.78.122.16:9651 tcp://[2a01:4ff:2f0:3621::1]:9651 quic://142.93.217.194:9651 --tun-name tun2 --tcp-listen-port 9652 --quic-listen-port 9653 --api-addr 127.0.0.1:${server1_port}')
}()

spawn fn () {
	os.execute('mkdir -p /tmp/mycelium_server2 && cd /tmp/mycelium_server2 && mycelium --peers tcp://188.40.132.242:9651 quic://[2a01:4f8:212:fa6::2]:9651 tcp://185.69.166.7:9651 quic://[2a02:1802:5e:0:ec4:7aff:fe51:e36b]:9651 tcp://65.21.231.58:9651 quic://[2a01:4f9:5a:1042::2]:9651 tcp://[2604:a00:50:17b:9e6b:ff:fe1f:e054]:9651 quic://5.78.122.16:9651 tcp://[2a01:4ff:2f0:3621::1]:9651 quic://142.93.217.194:9651 --tun-name tun3 --tcp-listen-port 9654 --quic-listen-port 9655 --api-addr 127.0.0.1:${server2_port}')
}()

defer {
	terminate(server1_port) or {}
	terminate(server2_port) or {}
}

time.sleep(2 * time.second)

mut client1 := mycelium.get()!
client1.server_url = 'http://localhost:${server1_port}'
client1.name = 'client1'
println(client1)

mut client2 := mycelium.get()!
client2.server_url = 'http://localhost:${server2_port}'
client2.name = 'client2'
println(client2)

inspect1 := mycelium.inspect(key_file_path: '/tmp/mycelium_server1/priv_key.bin')!
inspect2 := mycelium.inspect(key_file_path: '/tmp/mycelium_server2/priv_key.bin')!

println('Server 1 public key: ${inspect1.public_key}')
println('Server 2 public key: ${inspect2.public_key}')

// Send a message to a node by public key
// Parameters: public_key, payload, topic, wait_for_reply
msg := client1.send_msg(
	public_key: inspect2.public_key // destination public key
	payload:    'Sending a message from the client 1 to the client 2' // message payload
	topic:      'testing' // optional topic
)!

println('Sent message ID: ${msg.id}')
println('send succeeded')

// Receive messages
// Parameters: wait_for_message, peek_only, topic_filter
received := client2.receive_msg(wait: true, peek: false, topic: 'testing')!
println('Received message from: ${received.src_pk}')
println('Message payload: ${base64.decode_str(received.payload)}')

// Reply to a message
// client1.reply_msg(
// 	id:         received.id
// 	public_key: received.src_pk
// 	payload:    'Got your message!'
// 	topic:      'greetings'
// )!

// // // Check message status
// // status := client.get_msg_status(msg.id)!
// // println('Message status: ${status.state}')
// // println('Created at: ${status.created}')
// // println('Expires at: ${status.deadline}')
