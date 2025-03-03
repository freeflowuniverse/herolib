module ourdb

import freeflowuniverse.herolib.clients.mycelium
import rand
import time
import encoding.base64
import json
import x.json2

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
	id               string = rand.string(10)
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
		id:               args.id
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
		msg := s.mycelium_client.receive_msg(wait: true, peek: true) or {
			return error('Failed to receive message: ${err}')
		}
		println('Received message topic: ${msg.topic}')

		if msg.topic == 'db_sync' {
			if msg.payload.len > 0 {
				update_data := base64.decode(msg.payload)
				if mut worker := s.workers[msg.dst_pk] {
					worker.sync_updates(update_data) or {
						return error('Failed to sync worker: ${err}')
					}
				}
			}
		}

		if msg.topic == 'get_db' {
			// Send the entire database to the worker
			if mut worker := s.workers[msg.dst_pk] {
				// convert database to base64
				to_json := json2.encode(worker).bytes()
				to_base64 := base64.encode(to_json)
				s.mycelium_client.reply_msg(
					id:         msg.id
					public_key: msg.src_pk
					payload:    to_base64
					topic:      'get_db'
				)!
			}
		}
	}()
	time.sleep(time.second * 1)
	return s.listen()
}

pub fn (mut s MyceliumStreamer) read(args MyceliumReadArgs) ![]u8 {
	if args.worker_public_key.len > 0 {
		return s.read_from_worker(args)
	}
	return s.master.get(args.id)!
}

fn (mut s MyceliumStreamer) read_from_worker(args MyceliumReadArgs) ![]u8 {
	println('Reading from worker: ${args.worker_public_key}')
	if mut _ := s.workers[args.worker_public_key] {
		s.mycelium_client.send_msg(
			public_key: args.worker_public_key
			payload:    ''
			topic:      'get_db'
		)!
	}

	msg := s.mycelium_client.receive_msg(wait: true, peek: true, topic: 'get_db') or {
		return error('Failed to receive message: ${err}')
	}

	println('msg: ${msg}')

	if msg.payload.len > 0 {
		to_json := base64.decode(msg.payload)
		mut worker_db := json2.decode[OurDB](to_json.bytestr())!
		println('worker_db: ${worker_db}')
		value := worker_db.get(args.id) or {
			return error('Failed to get id ${args.id} from worker db: ${err}')
		}
		return value
	}

	return error('read_from_worker failed')
}
