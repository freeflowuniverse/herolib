module dedupestor

import crypto.blake2b
import freeflowuniverse.herolib.data.radixtree
import freeflowuniverse.herolib.data.ourdb

pub const max_value_size = 1024 * 1024 // 1MB

// DedupeStore provides a key-value store with deduplication based on content hashing
pub struct DedupeStore {
mut:
	radix &radixtree.RadixTree // For storing hash -> id mappings
	data  &ourdb.OurDB         // For storing the actual data
}

@[params]
pub struct NewArgs {
pub mut:
	path  string // Base path for the store
	reset bool   // Whether to reset existing data
}

// new creates a new deduplication store
pub fn new(args NewArgs) !&DedupeStore {
	// Create the radixtree for hash -> id mapping
	mut rt := radixtree.new(
		path:  '${args.path}/radixtree'
		reset: args.reset
	)!

	// Create the ourdb for actual data storage
	mut db := ourdb.new(
		path:             '${args.path}/data'
		record_size_max:  max_value_size
		incremental_mode: true // We want auto-incrementing IDs
		reset:            args.reset
	)!

	return &DedupeStore{
		radix: &rt
		data:  &db
	}
}

// store stores data with its reference and returns its id
// If the data already exists (same hash), returns the existing id without storing again
// appends reference to the radix tree entry of the hash to track references
pub fn (mut ds DedupeStore) store(data []u8, ref Reference) !u32 {
	// Check size limit
	if data.len > max_value_size {
		return error('value size exceeds maximum allowed size of 1MB')
	}

	// Calculate blake160 hash of the value
	hash := blake2b.sum160(data).hex()

	// Check if this hash already exists
	if metadata_bytes := ds.radix.get(hash) {
		// Value already exists, add new ref & return the id
		mut metadata := bytes_to_metadata(metadata_bytes)
		metadata = metadata.add_reference(ref)!
		ds.radix.update(hash, metadata.to_bytes())!
		return metadata.id
	}

	// Store the actual data in ourdb
	id := ds.data.set(data: data)!
	metadata := Metadata{
		id:         id
		references: [ref]
	}

	// Store the mapping of hash -> id in radixtree
	ds.radix.set(hash, metadata.to_bytes())!

	return metadata.id
}

// get retrieves a value by its hash
pub fn (mut ds DedupeStore) get(id u32) ![]u8 {
	return ds.data.get(id)!
}

// get retrieves a value by its hash
pub fn (mut ds DedupeStore) get_from_hash(hash string) ![]u8 {
	// Get the ID from radixtree
	metadata_bytes := ds.radix.get(hash)!

	// Convert bytes back to metadata
	metadata := bytes_to_metadata(metadata_bytes)

	// Get the actual data from ourdb
	return ds.data.get(metadata.id)!
}

// exists checks if a value with the given hash exists
pub fn (mut ds DedupeStore) id_exists(id u32) bool {
	if _ := ds.data.get(id) {
		return true
	} else {
		return false
	}
}

// exists checks if a value with the given hash exists
pub fn (mut ds DedupeStore) hash_exists(hash string) bool {
	return if _ := ds.radix.get(hash) { true } else { false }
}

// delete removes a reference from the hash entry
// If it's the last reference, removes the hash entry and its data
pub fn (mut ds DedupeStore) delete(id u32, ref Reference) ! {
	// Calculate blake160 hash of the value
	data := ds.data.get(id)!
	hash := blake2b.sum160(data).hex()

	// Get the current entry from radixtree
	metadata_bytes := ds.radix.get(hash)!
	mut metadata := bytes_to_metadata(metadata_bytes)
	metadata = metadata.remove_reference(ref)!

	if metadata.references.len == 0 {
		// Delete from radixtree
		ds.radix.delete(hash)!
		// Delete from data db
		ds.data.delete(id)!
		return
	}

	// Update hash metadata
	ds.radix.update(hash, metadata.to_bytes())!
}
