module dedupestor

import crypto.blake2b
import freeflowuniverse.herolib.data.radixtree
import freeflowuniverse.herolib.data.ourdb

pub const max_value_size = 1024 * 1024 // 1MB

// DedupeStore provides a key-value store with deduplication based on content hashing
pub struct DedupeStore {
mut:
	radix &radixtree.RadixTree // For storing hash -> id mappings
	data  &ourdb.OurDB        // For storing the actual data
}

@[params]
pub struct NewArgs {
pub mut:
	path  string    // Base path for the store
	reset bool      // Whether to reset existing data
}

// new creates a new deduplication store
pub fn new(args NewArgs) !&DedupeStore {
	// Create the radixtree for hash -> id mapping
	mut rt := radixtree.new(
		path: '${args.path}/radixtree'
		reset: args.reset
	)!

	// Create the ourdb for actual data storage
	mut db := ourdb.new(
		path: '${args.path}/data'
		record_size_max: max_value_size
		incremental_mode: true // We want auto-incrementing IDs
		reset: args.reset
	)!

	return &DedupeStore{
		radix: rt
		data: db
	}
}

// store stores a value and returns its hash
// If the value already exists (same hash), returns the existing hash without storing again
pub fn (mut ds DedupeStore) store(value []u8) !string {
	// Check size limit
	if value.len > max_value_size {
		return error('value size exceeds maximum allowed size of 1MB')
	}

	// Calculate blake160 hash of the value
	hash := blake2b.sum160(value).hex()

	// Check if this hash already exists
	if _ := ds.radix.search(hash) {
		// Value already exists, return the hash
		return hash
	}

	// Store the actual data in ourdb
	id := ds.data.set(data: value)!

	// Convert id to bytes for storage in radixtree
	id_bytes := u32_to_bytes(id)

	// Store the mapping of hash -> id in radixtree
	ds.radix.insert(hash, id_bytes)!

	return hash
}

// get retrieves a value by its hash
pub fn (mut ds DedupeStore) get(hash string) ![]u8 {
	// Get the ID from radixtree
	id_bytes := ds.radix.search(hash)!
	
	// Convert bytes back to u32 id
	id := bytes_to_u32(id_bytes)

	// Get the actual data from ourdb
	return ds.data.get(id)!
}

// exists checks if a value with the given hash exists
pub fn (mut ds DedupeStore) exists(hash string) bool {
	return if _ := ds.radix.search(hash) { true } else { false }
}

// Helper function to convert u32 to []u8
fn u32_to_bytes(n u32) []u8 {
	return [u8(n), u8(n >> 8), u8(n >> 16), u8(n >> 24)]
}

// Helper function to convert []u8 to u32
fn bytes_to_u32(b []u8) u32 {
	return u32(b[0]) | (u32(b[1]) << 8) | (u32(b[2]) << 16) | (u32(b[3]) << 24)
}
