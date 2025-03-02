#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.clients.mycelium
import freeflowuniverse.herolib.installers.net.mycelium_installer
import freeflowuniverse.herolib.data.ourdb
import freeflowuniverse.herolib.osal
import time
import os
import encoding.base64
import json

// NOTE: Before running this script, ensure that the mycelium binary is installed and in the PATH

const slave_port = 9001
const master_public_key = '89c2eeb24bcdfaaac78c0023a166d88f760c097c1a57748770e432ba10757179'
const master_address = '458:90d4:a3ef:b285:6d32:a22d:9e73:697f'

// Struct to hold data for syncing
struct SyncData {
	id    u32
	data  string
	topic string = 'db_sync'
}

mycelium.delete()!

// Initialize mycelium clients
mut slave := mycelium.get()!
slave.server_url = 'http://localhost:${slave_port}'
slave.name = 'slave_node'

// Get public keys for communication
slave_inspect := mycelium.inspect(key_file_path: '/tmp/mycelium_server1/priv_key.bin')!

println('Server 2 (slave Node) public key: ${slave_inspect.public_key}')

// Initialize ourdb instances
mut db := ourdb.new(
	record_nr_max:   16777216 - 1
	record_size_max: 1024
	path:            '/tmp/ourdb1'
	reset:           true
)!

defer {
	db.destroy() or { panic('failed to destroy db1: ${err}') }
}

// Send the last inserted record id to the master
// data := 'Test data for sync - ' + time.now().str()
id := db.get_last_index()!
println('Last inserted record id: ${id}')

// Send sync message to slave
println('\nSending sync message to slave...')
msg := slave.send_msg(
	public_key: master_public_key
	payload:    'last_inserted_record_id,${id}'
	topic:      'db_sync'
)!

// Receive messages
// Parameters: wait_for_message, peek_only, topic_filter
received := slave.receive_msg(wait: true, peek: false, topic: 'db_sync')!
println('Received message from: ${received.src_pk}')
println('Message payload: ${base64.decode_str(received.payload)}')

slave.reply_msg(
	id:         received.id
	public_key: received.src_pk
	payload:    'Got your message!'
	topic:      'db_sync'
)!

println('Message sent to master with ID: ${msg.id}')
