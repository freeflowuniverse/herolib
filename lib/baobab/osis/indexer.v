module osis

import json
import db.sqlite
import db.pg
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.core.pathlib
import orm

pub struct Indexer {
	db sqlite.DB
}

@[params]
pub struct IndexerConfig {
	db_path string
	reset bool
}

pub fn new_indexer(config IndexerConfig) !Indexer {
	return Indexer{}
}

// deletes an indexer table belonging to a base object
pub fn reset(path string) ! {
	mut db_file := pathlib.get_file(path: path)!
	db_file.delete()!
}

// new creates a new root object entry in the root_objects table,
// and the table belonging to the type of root object with columns for index fields
pub fn (mut backend Indexer) new(object RootObject) !u32 {
	panic('implement')
}

// save the session to redis & mem
pub fn (mut backend Indexer) set(obj RootObject) ! {
	panic('implement')
}

// save the session to redis & mem
pub fn (mut backend Indexer) delete(id string, obj RootObject) ! {
	panic('implement')
}

pub fn (mut backend Indexer) get(id string, obj RootObject) !RootObject {
	panic('implement')
}

pub fn (mut backend Indexer) get_json(id string, obj RootObject) !string {
	panic('implement')
}

pub fn (mut backend Indexer) list(obj RootObject) ![]u32 {
	panic('implement')
}

// from and to for int f64 time etc.
@[params]
pub struct FilterParams {
	// indices     map[string]string // map of index values that are being filtered by, in order of priority.
	limit       int  // limit to the number of values to be returned, in order of priority
	fuzzy       bool // if fuzzy matching is enabled in matching indices
	matches_all bool // if results should match all indices or any
}

// filter lists root objects of type T that match provided index parameters and params.
pub fn (mut backend Indexer) filter(filter RootObject, params FilterParams) ![]string {
	panic('implement')
}

// create_root_struct_table creates a table for a root_struct with columns for each index field
fn (mut backend Indexer) create_root_object_table(object RootObject) ! {
	panic('implement')
}

// deletes an indexer table belonging to a root object
fn (mut backend Indexer) delete_table(object RootObject)! {
	panic('implement')
}

fn (mut backend Indexer) get_table_indices(table_name string) ![]string {
	panic('implement')
}

fn (mut backend Indexer) table_exists(table_name string) !bool {
	panic('implement')
}

// get_table_name returns the name of the table belonging to a root struct
fn get_table_name(object RootObject) string {
	panic('implement')
}