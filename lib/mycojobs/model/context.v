module model

// each job is run in a context, this corresponds to a DB in redis and has specific rights to actors
// context is a redis db and also a locaction on a filesystem which can be used for e.g. logs, temporary files, etc.
// actors create contexts for others to work in
// stored in the context db at context:<id> (context is hset)
@[heap]
pub struct Context {
pub mut:
	id         u32   // corresponds with the redis db (in our ourdb or other redis)
	admins     []u32 // actors which have admin rights on this context (means can do everything)
	readers    []u32 // actors which can read the context info
	executors  []u32 // actors which can execute jobs in this context
	created_at u32   // epoch
	updated_at u32   // epoch
}

pub fn (self Context) redis_key() string {
	return 'context:${self.id}'
}
