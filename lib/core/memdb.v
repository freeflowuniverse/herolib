module core

__global (
	memdb shared map[string]string
)

pub fn memdb_set(key string, val string) {
	lock memdb {
		memdb[key] = val
	}
}

pub fn memdb_get(key string) string {
	lock memdb {
		return memdb[key] or { return '' }
	}
	return ''
}

pub fn memdb_exists(key string) bool {
	if memdb_get(key).len > 0 {
		return true
	}
	return false
}
