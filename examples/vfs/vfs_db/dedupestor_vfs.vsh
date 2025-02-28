#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import os
import rand
import freeflowuniverse.herolib.vfs.vfs_db
import freeflowuniverse.herolib.data.dedupestor
import freeflowuniverse.herolib.data.ourdb

pub struct VFSDedupeDB {
	dedupestor.DedupeStore
}

pub fn (mut db VFSDedupeDB) set(args ourdb.OurDBSetArgs) !u32 {
	return db.store(args.data, 
		dedupestor.Reference{owner: u16(1), id: args.id or {panic('VFS Must provide id')}}
	)!
}

pub fn (mut db VFSDedupeDB) delete(id u32) ! {
	db.DedupeStore.delete(id, dedupestor.Reference{owner: u16(1), id: id})!
}

example_data_dir := os.join_path(os.dir(@FILE), 'example_db')
os.mkdir_all(example_data_dir)!

// Create separate databases for data and metadata
mut db_data := VFSDedupeDB{
	DedupeStore: dedupestor.new(
		path: os.join_path(example_data_dir, 'data')
	)!
}

mut db_metadata := ourdb.new(
	path: os.join_path(example_data_dir, 'metadata')
	incremental_mode: false
)!

// Create VFS with separate databases for data and metadata
mut vfs := vfs_db.new_with_separate_dbs(
	mut db_data, 
	mut db_metadata, 
	data_dir: os.join_path(example_data_dir, 'data'),
	metadata_dir: os.join_path(example_data_dir, 'metadata')
)!

println('\n---------BEGIN EXAMPLE')
println('---------WRITING FILES')
vfs.file_create('some_file.txt')!
vfs.file_create('another_file.txt')!

vfs.file_write('some_file.txt', 'gibberish'.bytes())!
vfs.file_write('another_file.txt', 'abcdefg'.bytes())!

println('\n---------READING FILES')
println(vfs.file_read('some_file.txt')!.bytestr())
println(vfs.file_read('another_file.txt')!.bytestr())

println("\n---------WRITING DUPLICATE FILE (DB SIZE: ${os.file_size(os.join_path(example_data_dir, 'data/0.db'))})")
vfs.file_create('duplicate.txt')!
vfs.file_write('duplicate.txt', 'gibberish'.bytes())!

println("\n---------WROTE DUPLICATE FILE (DB SIZE: ${os.file_size(os.join_path(example_data_dir, 'data/0.db'))})")
println('---------READING FILES')
println(vfs.file_read('some_file.txt')!.bytestr())
println(vfs.file_read('another_file.txt')!.bytestr())
println(vfs.file_read('duplicate.txt')!.bytestr())

println("\n---------DELETING DUPLICATE FILE (DB SIZE: ${os.file_size(os.join_path(example_data_dir, 'data/0.db'))})")
vfs.file_delete('duplicate.txt')!
println("---------READING FILES (DB SIZE: ${os.file_size(os.join_path(example_data_dir, 'data/0.db'))})")
println(vfs.file_read('some_file.txt')!.bytestr())
println(vfs.file_read('another_file.txt')!.bytestr())
// FAILS SUCCESSFULLY
// println(vfs.file_read('duplicate.txt')!.bytestr())