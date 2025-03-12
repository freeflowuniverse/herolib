module webdav

import time
import rand

fn test_lock() {
	mut locker := Locker{locks: map[string]Lock{}}

	// Lock the resource
	result := locker.lock(
		resource: 'test-resource',
		owner: 'test-owner',
		depth: 0,
		timeout: 3600,
	) or { panic(err) }
	assert result.token != ''
	assert locker.is_locked('test-resource')
}

fn test_unlock() {
	mut locker := Locker{locks: map[string]Lock{}}

	// Lock the resource
	locker.lock(
		resource: 'test-resource',
		owner: 'test-owner',
		depth: 0,
		timeout: 3600,
	) or { panic(err) }
	
	// Unlock the resource
	is_unlocked := locker.unlock('test-resource')
	assert is_unlocked
	assert !locker.is_locked('test-resource')
}

fn test_lock_with_different_owner() {
	mut locker := Locker{locks: map[string]Lock{}}
	lock1 := Lock{
		resource: 'test-resource',
		owner: 'owner1',
		depth: 0,
		timeout: 3600,
	}
	lock2 := Lock{
		resource: 'test-resource',
		owner: 'owner2',
		depth: 0,
		timeout: 3600,
	}

	// Lock the resource with the first owner
	locker.lock(lock1) or { panic(err) }
	
	// Attempt to lock the resource with a different owner
	if result := locker.lock(lock2) {
		assert false, 'locking should fail'
	} else {
		assert err == error('Resource is already locked by a different owner')
	}
}

fn test_cleanup_expired_locks() {
	mut locker := Locker{locks: map[string]Lock{}}

	// Lock the resource
	locker.lock(
		resource: 'test-resource',
		owner: 'test-owner',
		depth: 0,
		timeout: 1,
	) or { panic(err) }
	
	// Wait for the lock to expire
	time.sleep(2 * time.second)
	
	// Cleanup expired locks
	locker.cleanup_expired_locks()
	assert !locker.is_locked('test-resource')
}
