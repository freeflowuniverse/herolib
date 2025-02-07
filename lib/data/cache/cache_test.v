module cache

import time

@[heap]
struct TestData {
	value string
}

fn test_cache_creation() {
	config := CacheConfig{
		max_entries:    100
		max_size_mb:    1.0
		ttl_seconds:    60
		eviction_ratio: 0.1
	}
	mut cache := new_cache[TestData](config)
	assert cache.len() == 0
	assert cache.config.max_entries == 100
	assert cache.config.max_size_mb == 1.0
	assert cache.config.ttl_seconds == 60
	assert cache.config.eviction_ratio == 0.1
}

fn test_cache_set_get() {
	mut cache := new_cache[TestData](CacheConfig{})
	data := &TestData{
		value: 'test'
	}

	cache.set(1, data)
	assert cache.len() == 1

	if cached := cache.get(1) {
		assert cached.value == 'test'
	} else {
		assert false, 'Failed to get cached item'
	}

	if _ := cache.get(2) {
		assert false, 'Should not find non-existent item'
	}
}

fn test_cache_ttl() {
	$if debug {
		eprintln('> test_cache_ttl')
	}
	mut cache := new_cache[TestData](CacheConfig{
		ttl_seconds: 1
	})
	data := &TestData{
		value: 'test'
	}

	cache.set(1, data)
	assert cache.len() == 1

	if cached := cache.get(1) {
		assert cached.value == 'test'
	}

	time.sleep(2 * time.second)
	$if debug {
		eprintln('> waited 2 seconds')
	}

	if _ := cache.get(1) {
		assert false, 'Item should have expired'
	}
	assert cache.len() == 0
}

fn test_cache_eviction() {
	mut cache := new_cache[TestData](CacheConfig{
		max_entries:    2
		eviction_ratio: 0.5
	})

	data1 := &TestData{
		value: 'one'
	}
	data2 := &TestData{
		value: 'two'
	}
	data3 := &TestData{
		value: 'three'
	}

	cache.set(1, data1)
	cache.set(2, data2)
	assert cache.len() == 2

	// Access data1 to make it more recently used
	cache.get(1)

	// Adding data3 should trigger eviction of data2 (least recently used)
	cache.set(3, data3)
	assert cache.len() == 2

	if _ := cache.get(2) {
		assert false, 'Item 2 should have been evicted'
	}

	if cached := cache.get(1) {
		assert cached.value == 'one'
	} else {
		assert false, 'Item 1 should still be cached'
	}

	if cached := cache.get(3) {
		assert cached.value == 'three'
	} else {
		assert false, 'Item 3 should be cached'
	}
}

fn test_cache_clear() {
	mut cache := new_cache[TestData](CacheConfig{})
	data := &TestData{
		value: 'test'
	}

	cache.set(1, data)
	assert cache.len() == 1

	cache.clear()
	assert cache.len() == 0

	if _ := cache.get(1) {
		assert false, 'Cache should be empty after clear'
	}
}

fn test_cache_size_limit() {
	// Set a very small size limit to force eviction
	mut cache := new_cache[TestData](CacheConfig{
		max_size_mb:    0.0001 // ~100 bytes
		eviction_ratio: 0.5
	})

	// Add multiple entries to exceed size limit
	for i := u32(0); i < 10; i++ {
		data := &TestData{
			value: 'test${i}'
		}
		cache.set(i, data)
	}

	// Cache should have evicted some entries to stay under size limit
	assert cache.len() < 10
}
