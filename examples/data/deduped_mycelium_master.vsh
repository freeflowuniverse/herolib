#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.data.ourdb

worker_public_key := '46a9f9cee1ce98ef7478f3dea759589bbf6da9156533e63fed9f233640ac072c'

mut streamer := ourdb.new_streamer(incremental_mode: false)!
streamer.add_worker(worker_public_key)! // Mycelium public key

id := streamer.write(id: 1, value: 'Record 1')!

println('ID: ${id}')

master_data := streamer.read(id: id)!
master_data_str := master_data.bytestr()
println('Master data: ${master_data_str}')
