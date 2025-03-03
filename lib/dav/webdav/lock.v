module webdav

import time
import rand

struct Lock {
	resource   string
	owner      string
	token      string
	depth      int // 0 for a single resource, 1 for recursive
	timeout    int // in seconds
	created_at time.Time
}

struct LockManager {
mut:
	locks map[string]Lock
}

// LockResult represents the result of a lock operation
pub struct LockResult {
pub:
	token       string // The lock token
	is_new_lock bool   // Whether this is a new lock or an existing one
}

// lock attempts to lock a resource for a specific owner
// Returns a LockResult with the lock token and whether it's a new lock
// Returns an error if the resource is already locked by a different owner
pub fn (mut lm LockManager) lock(resource string, owner string, depth int, timeout int) !LockResult {
	if resource in lm.locks {
		// Check if the lock is still valid
		existing_lock := lm.locks[resource]
		if time.now().unix() - existing_lock.created_at.unix() < existing_lock.timeout {
			// Resource is already locked
			if existing_lock.owner == owner {
				// Same owner, refresh the lock
				lm.locks[resource] = Lock{
					resource:   resource
					owner:      owner
					token:      existing_lock.token
					depth:      depth
					timeout:    timeout
					created_at: time.now()
				}
				return LockResult{
					token: existing_lock.token
					is_new_lock: false
				}
			} else {
				// Different owner, return an error
				return error('Resource is already locked by a different owner')
			}
		}
		// Expired lock, remove it
		lm.unlock(resource)
	}

	// Generate a new lock token
	token := rand.uuid_v4()
	lm.locks[resource] = Lock{
		resource:   resource
		owner:      owner
		token:      token
		depth:      depth
		timeout:    timeout
		created_at: time.now()
	}
	return LockResult{
		token: token
		is_new_lock: true
	}
}

pub fn (mut lm LockManager) unlock(resource string) bool {
	if resource in lm.locks {
		lm.locks.delete(resource)
		return true
	}
	return false
}

// is_locked checks if a resource is currently locked
pub fn (lm LockManager) is_locked(resource string) bool {
	if resource in lm.locks {
		lock_ := lm.locks[resource]
		// Check if lock is expired
		if time.now().unix() - lock_.created_at.unix() >= lock_.timeout {
			return false
		}
		return true
	}
	return false
}

// get_lock returns the Lock object for a resource if it exists and is valid
pub fn (lm LockManager) get_lock(resource string) ?Lock {
	if resource in lm.locks {
		lock_ := lm.locks[resource]
		// Check if lock is expired
		if time.now().unix() - lock_.created_at.unix() >= lock_.timeout {
			return none
		}
		return lock_
	}
	return none
}

pub fn (mut lm LockManager) unlock_with_token(resource string, token string) bool {
	println('debugzoA ${resource} ${lm.locks}')
	if resource in lm.locks {
		println('debugzoB ${token} ${lm.locks[resource]}')
		lock_ := lm.locks[resource]
		if lock_.token == token {
			lm.locks.delete(resource)
			return true
		}
	}
	return false
}

fn (mut lm LockManager) lock_recursive(resource string, owner string, depth int, timeout int) !LockResult {
	if depth == 0 {
		return lm.lock(resource, owner, depth, timeout)
	}
	// Implement logic to lock child resources if depth == 1
	// For now, just lock the parent resource
	return lm.lock(resource, owner, depth, timeout)
}

pub fn (mut lm LockManager) cleanup_expired_locks() {
	// now := time.now().unix()
	// lm.locks
	// lm.locks = lm.locks.filter(it.value.created_at.unix() + it.value.timeout > now)
}
