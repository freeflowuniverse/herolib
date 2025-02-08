module cache

import time
import math

// CacheConfig holds cache configuration parameters
pub struct CacheConfig {
pub mut:
	max_entries    u32 = 1000  // Maximum number of entries
	max_size_mb    f64 = 100.0 // Maximum cache size in MB
	ttl_seconds    i64 = 3600  // Time-to-live in seconds (0 = no TTL)
	eviction_ratio f64 = 0.05  // Percentage of entries to evict when full (5%)
}

// CacheEntry represents a cached object with its metadata
@[heap]
struct CacheEntry[T] {
mut:
	obj         T   // Reference to the cached object
	last_access i64 // Unix timestamp of last access
	created_at  i64 // Unix timestamp of creation
	size        u32 // Approximate size in bytes
}

// Cache manages the in-memory caching of objects
pub struct Cache[T] {
mut:
	entries    map[u32]&CacheEntry[T] // Map of object ID to cache entry
	config     CacheConfig            // Cache configuration
	access_log []u32                  // Ordered list of object IDs by access time
	total_size u64                    // Total size of cached entries in bytes
}

// new_cache creates a new cache instance with the given configuration
pub fn new_cache[T](config CacheConfig) &Cache[T] {
	return &Cache[T]{
		entries:    map[u32]&CacheEntry[T]{}
		config:     config
		access_log: []u32{cap: int(config.max_entries)}
		total_size: 0
	}
}

// get retrieves an object from the cache if it exists
pub fn (mut c Cache[T]) get(id u32) ?&T {
	if entry := c.entries[id] {
		now := time.now().unix()

		// Check TTL
		if c.config.ttl_seconds > 0 {
			if (now - entry.created_at) > c.config.ttl_seconds {
				c.remove(id)
				return none
			}
		}

		// Update access time
		unsafe {
			entry.last_access = now
		}
		// Move ID to end of access log
		idx := c.access_log.index(id)
		if idx >= 0 {
			c.access_log.delete(idx)
		}
		c.access_log << id

		return &entry.obj
	}
	return none
}

// set adds or updates an object in the cache
pub fn (mut c Cache[T]) set(id u32, obj &T) {
	now := time.now().unix()

	// Calculate entry size (approximate)
	entry_size := sizeof(T) + sizeof(CacheEntry[T])

	// Check memory and entry count limits
	new_total := c.total_size + u64(entry_size)
	max_bytes := u64(c.config.max_size_mb * 1024 * 1024)

	// Always evict if we're at or above max_entries
	if c.entries.len >= int(c.config.max_entries) {
		c.evict()
	} else if new_total > max_bytes {
		// Otherwise evict only if we're over memory limit
		c.evict()
	}

	// Create new entry
	entry := &CacheEntry[T]{
		obj:         *obj
		last_access: now
		created_at:  now
		size:        u32(entry_size)
	}

	// Update total size
	if old := c.entries[id] {
		c.total_size -= u64(old.size)
	}
	c.total_size += u64(entry_size)

	// Add to entries map
	c.entries[id] = entry

	// Update access log
	idx := c.access_log.index(id)
	if idx >= 0 {
		c.access_log.delete(idx)
	}
	c.access_log << id

	// Ensure access_log stays in sync with entries
	if c.access_log.len > c.entries.len {
		c.access_log = c.access_log[c.access_log.len - c.entries.len..]
	}
}

// evict removes entries based on configured eviction ratio
fn (mut c Cache[T]) evict() {
	// If we're at max entries, remove enough to get to 80% capacity
	target_size := int(c.config.max_entries) * 8 / 10 // 80%
	num_to_evict := if c.entries.len >= int(c.config.max_entries) {
		c.entries.len - target_size
	} else {
		math.max(1, int(c.entries.len * c.config.eviction_ratio))
	}

	if num_to_evict > 0 {
		// Remove oldest entries
		mut evicted_size := u64(0)
		for i := 0; i < num_to_evict && i < c.access_log.len; i++ {
			id := c.access_log[i]
			if entry := c.entries[id] {
				evicted_size += u64(entry.size)
				c.entries.delete(id)
			}
		}

		// Update total size and access log
		c.total_size -= evicted_size
		c.access_log = c.access_log[num_to_evict..]
	}
}

// remove deletes a single entry from the cache
pub fn (mut c Cache[T]) remove(id u32) {
	if entry := c.entries[id] {
		c.total_size -= u64(entry.size)
	}
	c.entries.delete(id)
}

// clear empties the cache
pub fn (mut c Cache[T]) clear() {
	c.entries.clear()
	c.access_log.clear()
	c.total_size = 0
}

// len returns the number of entries in the cache
pub fn (c &Cache[T]) len() int {
	return c.entries.len
}
