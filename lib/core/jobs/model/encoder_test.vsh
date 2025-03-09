#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.data.encoder
import freeflowuniverse.herolib.data.ourtime

// In .vsh files, we don't need a main() function
println('Testing encoder functions...')

mut e := encoder.new()

// Test basic encoder functions
e.add_u16(100)
e.add_string('test')
e.add_int(42)
e.add_ourtime(ourtime.now())

// Test map functions
mut test_map := map[string]string{}
test_map['key1'] = 'value1'
test_map['key2'] = 'value2'
e.add_map_string(test_map)

println('Encoder test completed successfully!')
println('Data length: ${e.data.len} bytes')
