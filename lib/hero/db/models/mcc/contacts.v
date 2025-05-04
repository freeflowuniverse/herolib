module models

import freeflowuniverse.herolib.data.ourtime
import freeflowuniverse.herolib.hero.db.models.base

pub struct Contact {
	base.Base
pub mut:
	name string //name of the contact as we use in this circle
	first_name  string
	last_name   string
	email       []string
	tel []string
}



pub fn (self Contact) index_keys() map[string]string {
	return map[string]string{} //TODO: name
}

pub fn (self Contact) ftindex_keys() map[string]string {
	return {
		'first_name': self.first_name
		'last_name': self.last_name
		'email': self.email.join(', ')
		'tel': self.tel.join(', ')	
	}	
}
