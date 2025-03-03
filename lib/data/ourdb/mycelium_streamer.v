module ourdb

import freeflowuniverse.herolib.clients.mycelium
import rand
import time
import encoding.base64

struct MyceliumStreamer {
pub mut:
	master           &OurDB            @[skip; str: skip]
	workers          map[string]&OurDB @[skip; str: skip] // key is mycelium public key, value is ourdb
	incremental_mode bool = true // default is true
	mycelium_client  mycelium.Mycelium @[skip; str: skip] // not a reference since we own it
	id               string = rand.string(10)
}

struct MyceliumStreamerInstances {
pub mut:
	instances map[string]&MyceliumStreamer
}

pub struct NewStreamerArgs {
pub mut:
	incremental_mode bool = true // default is true
	server_port      int  = 9000 // default is 9000
	is_worker        bool // true if this is a worker node
}

fn new_db_streamer(args NewStreamerArgs) !OurDB {
	path := if args.is_worker {
		'/tmp/ourdb_worker_${rand.string(8)}'
	} else {
		'/tmp/ourdb_master'
	}
	return new(
		record_nr_max:    16777216 - 1
		record_size_max:  1024
		path:             path
		reset:            true
		incremental_mode: args.incremental_mode
	)!
}

pub fn (mut s MyceliumStreamer) add_worker(public_key string) ! {
	mut db := new_db_streamer(
		incremental_mode: s.incremental_mode
		is_worker:        true
	)!
	s.workers[public_key] = &db
}

pub fn new_streamer(args NewStreamerArgs) !MyceliumStreamer {
	mut db := new_db_streamer(args)!

	// Initialize mycelium client
	mut client := mycelium.get()!
	client.server_url = 'http://localhost:${args.server_port}'
	client.name = if args.is_worker { 'worker_node' } else { 'master_node' }

	mut s := MyceliumStreamer{
		master:           &db
		workers:          {}
		incremental_mode: args.incremental_mode
		mycelium_client:  client
	}

	mut instances_factory := MyceliumStreamerInstances{}
	instances_factory.instances[s.id] = &s

	println('Created ${if args.is_worker { 'worker' } else { 'master' }} node with ID: ${s.id}')
	return s
}

pub struct GetStreamerArgs {
pub mut:
	id string @[required]
}

pub fn get_streamer(args GetStreamerArgs) !MyceliumStreamer {
	mut instances_factory := MyceliumStreamerInstances{}

	for id, instamce in instances_factory.instances {
		if id == args.id {
			return *instamce
		}
	}

	return error('streamer with id ${args.id} not found')
}

@[params]
pub struct MyceliumRecordArgs {
pub:
	id    u32    @[required]
	value string @[required]
}

pub fn (mut s MyceliumStreamer) write(record MyceliumRecordArgs) !u32 {
	mut id := s.master.set(id: record.id, data: record.value.bytes()) or {
		return error('Failed to set id ${record.id} to value ${record.value} due to: ${err}')
	}

	// Get updates from the beginning (id 0) to ensure complete sync
	data := s.master.push_updates(id) or { return error('Failed to push updates due to: ${err}') }

	// Broadcast to all workers
	for worker_key, mut _ in s.workers {
		println('Sending message to worker: ${worker_key}')
		msg := s.mycelium_client.send_msg(
			public_key: worker_key // destination public key
			payload:    base64.encode(data) // message payload
			topic:      'db_sync' // optional topic
		)!
		println('Sent message ID: ${msg.id}')
	}
	return id
}

pub struct MyceliumReadArgs {
pub:
	id                u32 @[required]
	worker_public_key string
}

// listen continuously checks for messages from master and applies updates
pub fn (mut s MyceliumStreamer) listen() ! {
	spawn fn [mut s] () ! {
		println('Starting to listen for messages...')
		msg := s.mycelium_client.receive_msg(wait: true, peek: true, topic: 'db_sync')!

		update_data := base64.decode(msg.payload)
		println('Received update from worker: ${msg.src_pk}')
		println('Received update with payload: ${update_data.str()}')
		if mut worker := s.workers[msg.src_pk] {
			println('Worker with public key ${msg.src_pk} found')
			worker.sync_updates(update_data) or { return error('Failed to sync worker: ${err}') }
		}
	}()
	time.sleep(time.second * 1)
	return s.listen()
}

pub fn (mut s MyceliumStreamer) read(args MyceliumReadArgs) ![]u8 {
	if args.worker_public_key.len > 0 {
		if mut worker := s.workers[args.worker_public_key] {
			return worker.get(args.id)!
		}
		return error('Worker with public key ${args.worker_public_key} not found')
	}
	return s.master.get(args.id)!
}
