module finance
import freeflowuniverse.herolib.hero.db.models.base

pub struct Account {
    base.Base   
pub mut:    
    name string //internal name of the account for the user
    user_id u32 //user id of the owner of the account
    description string //optional description of the account    
    ledger string //describes the ledger/blockchain where the account is located e.g. "ethereum", "bitcoin" or other institutions
    address string //address of the account on the blockchain
    pubkey string
    assets []Asset
}


pub fn (self Account) index_keys() map[string]string {
	return {
		'name': self.name
	}
}

pub fn (self Account) ftindex_keys() map[string]string {
	return map[string]string{}
}
