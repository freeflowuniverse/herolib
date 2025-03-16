module base

import freeflowuniverse.herolib.data.ourdb
import freeflowuniverse.herolib.data.radixtree
import freeflowuniverse.herolib.core.texttools
import os

// SessionState holds the state of a session which is linked to someone calling it as well as the DB's we use
pub struct SessionState {
pub mut:
	name string
	pubkey        string   // pubkey of user who called this
	addr string //mycelium address
	dbs Databases
}

pub struct Databases{
pub mut:
	db_data_core &ourdb.OurDB
	db_meta_core &radixtree.RadixTree
	db_data_mcc &ourdb.OurDB
	db_meta_mcc &radixtree.RadixTree
}

@[params]
pub struct StateArgs {
pub mut:
	name string
	pubkey        string   // pubkey of user who called this
	addr string //mycelium address
	path string
}


pub fn new_session(args_ StateArgs) !SessionState {
	mut args:=args_

	args.name = texttools.name_fix(args.name)

	if args.path.len == 0 {
		args.path = os.join_path(os.home_dir(), 'hero', 'dbs')
	}

	mypath:=os.join_path(args.path, args.name)

		mut db_data_core := ourdb.new(
			path: os.join_path(mypath, 'data_core')
			incremental_mode: true
		)!
		mut db_meta_core := radixtree.new(
			path: os.join_path(mypath, 'meta_core')
		)!
		mut db_data_mcc := ourdb.new(
			path: os.join_path(mypath, 'data_mcc')
			incremental_mode: false
		)!
		mut db_meta_mcc := radixtree.new(
			path: os.join_path(mypath, 'meta_mcc')
		)!

		mut dbs := Databases{
			db_data_core: &db_data_core
			db_meta_core: &db_meta_core
			db_data_mcc: &db_data_mcc
			db_meta_mcc: &db_meta_mcc
		}

	mut s := SessionState{
		name: args.name
		dbs: dbs
		pubkey: args.pubkey
		addr: args.addr
	}

	return s
}
