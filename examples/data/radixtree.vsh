#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.data.radixtree

mut rt := radixtree.new(path:'/tmp/radixtree_test',reset:true)!

// Show initial state
println('\nInitial state:')
rt.debug_db()!

// Test insert
println('\nInserting key "test" with value "value1"')
rt.insert('test', 'value1'.bytes())!

// Show state after insert
println('\nState after insert:')
rt.debug_db()!

// Print tree structure
rt.print_tree()!

// Test search
if value := rt.search('test') {
    println('\nFound value: ${value.bytestr()}')
} else {
    println('\nError: ${err}')
}
