module circle
import freeflowuniverse.herolib.hero.db.models.base

// Define the RecordType enum
pub enum RecordType {
    a
    aaa
    cname
    mx
    ns
    ptr
    soa
    srv
    txt
}

// Define the DomainNamespace struct, represents a full domain with all its records
pub struct DomainNameSpace {
    base.Base
pub mut:
    id u32
    domain string
    description string
    records []Record
    admins []u32 // IDs of the admins they need to exist as user in the circle
}

// Define the Record struct
pub struct Record {
pub mut:
    name string
    text string
    category RecordType
    addr []string
}

pub fn (self DomainNameSpace) index_keys() map[string]string {
	return {
		'domain': self.domain
	}
}

pub fn (self DomainNameSpace) ftindex_keys() map[string]string {
	return {
		'description': self.description,
	}
}
