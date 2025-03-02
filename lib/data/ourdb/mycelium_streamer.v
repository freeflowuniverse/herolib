module ourdb

import freeflowuniverse.herolib.clients.mycelium

struct MyceliumStreamer {
pub mut:
	master           &OurDB            @[skip; str: skip]
	workers          map[string]&OurDB @[skip; str: skip] // key is mycelium public key, value is ourdb
	incremental_mode bool = true // default is true
	mycelium_client  &mycelium.Mycelium
}

pub struct NewStreamerArgs {
pub mut:
	incremental_mode bool = true // default is true
	server_port      int  = 9000 // default is 9000
}

fn new_db_streamer(args NewStreamerArgs) !OurDB {
	return new(
		record_nr_max:    16777216 - 1
		record_size_max:  1024
		path:             '/tmp/ourdb1'
		reset:            true
		incremental_mode: args.incremental_mode
	)!
}

pub fn (mut s MyceliumStreamer) add_worker(public_key string) ! {
	mut db := new_db_streamer(incremental_mode: s.incremental_mode)!
	s.workers[public_key] = &db
}

pub fn new_streamer(args NewStreamerArgs) !MyceliumStreamer {
	mut db := new_db_streamer(args)!
	mut s := MyceliumStreamer{
		master:           &db
		workers:          {}
		incremental_mode: args.incremental_mode
		mycelium_client:  &mycelium.Mycelium{}
	}

	s.mycelium_client = mycelium.get()!
	s.mycelium_client.server_url = 'http://localhost:${args.server_port}'
	s.mycelium_client.name = 'master_node'

	// Get public keys for communication
	// inspect := mycelium.inspect(key_file_path: '/tmp/mycelium_server1/priv_key.bin')!
	// println('Server 2 (slave Node) public key: ${slave_inspect.public_key}')
	return s
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
		s.mycelium_client.send_msg(
			public_key: worker_key // destination public key
			payload:    data.str() // message payload
			topic:      'sync_db' // optional topic
		)!
	}
	return id
}

pub struct MyceliumReadArgs {
pub:
	id                u32 @[required]
	worker_public_key string
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
