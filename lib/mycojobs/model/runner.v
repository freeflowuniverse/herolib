module model

// a runner executes a job, this can be in VM, in a container or just some processes running somewhere
// the messages always come in over a topic
// stored in the context db at runner:<id> (runner is hset)
@[heap]
pub struct Runner {
pub mut:
	id         u32
	pubkey     string // from mycelium
	address    string // mycelium address
	topic      string // needs to be set by the runner but often runner<runnerid> e.g. runner20
	local      bool   // if local then goes on redis using the id
	created_at u32    // epoch
	updated_at u32    // epoch
}

pub enum RunnerType {
	v
	python
	osis
	rust
}

pub fn (self Runner) redis_key() string {
	return 'runner:${self.id}'
}
