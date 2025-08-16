module model

// a actor is a participant in the new internet, the one who can ask for work
// user can have more than one actor operating for them, an actor always operates in a context which is hosted by the hero of the user
// stored in the context db at actor:<id> (actor is hset)
@[heap]
pub struct Actor {
pub mut:
	id         u32
	pubkey     string
	address    []Address // address (is to reach the actor back), normally mycelium but doesn't have to be
	created_at u32       // epoch
	updated_at u32       // epoch
}

pub fn (self Actor) redis_key() string {
	return 'actor:${self.id}'
}
