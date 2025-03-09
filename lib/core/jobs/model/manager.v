module model

import freeflowuniverse.herolib.data.radixtree
import freeflowuniverse.herolib.data.ourdb

// IndexKeyer is an interface for types that can provide index keys for storage in a radix tree
pub interface IndexKeyer {
	index_keys() map[string]string
}

// Manager is a generic manager for handling database operations with any type that implements IndexKeyer
pub struct Manager[T] {
pub mut:
	db_data &ourdb.OurDB
	db_meta &radixtree.RadixTree
	prefix  string
}

// new_manager creates a new generic manager instance
pub fn new_manager[T](db_data &ourdb.OurDB, db_meta &radixtree.RadixTree, prefix string) Manager[T] {
	return Manager[T]{
		db_data: db_data
		db_meta: db_meta
		prefix: prefix
	}
}

// get_index_keys is a generic function to get index keys for any type that implements IndexKeyer
pub fn get_index_keys[T](item T) map[string]string {
	// Use type assertion to check if T implements IndexKeyer
	if item is IndexKeyer {
		return item.index_keys()
	}
	return map[string]string{}
}

// store_index_keys stores the index keys in the radix tree
pub fn (mut m Manager[T]) store_index_keys(item T, id u32) ! {
	keys := get_index_keys[T](item)
	
	for key, value in keys {
		index_key := '${m.prefix}:${key}:${value}'
		m.db_meta.insert(index_key, id.str().bytes())!
	}
}

// delete_index_keys removes the index keys from the radix tree
pub fn (mut m Manager[T]) delete_index_keys(item T, id u32) ! {
	keys := get_index_keys[T](item)
	
	for key, value in keys {
		index_key := '${m.prefix}:${key}:${value}'
		m.db_meta.delete(index_key)!
	}
}

// find_by_index_key finds items by their index key
pub fn (mut m Manager[T]) find_by_index_key(key string, value string) ![]u32 {
	index_key := '${m.prefix}:${key}:${value}'
	
	// Search for all matching keys with this prefix
	matches := m.db_meta.search_prefix(index_key)
	
	mut ids := []u32{}
	for _, id_bytes in matches {
		id_str := id_bytes.bytestr()
		ids << id_str.u32()
	}
	
	return ids
}
