module osis

import json
import db.sqlite
import db.pg
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.clients.postgres
import orm

pub struct Indexer {
	db sqlite.DB
}

@[params]
pub struct IndexerConfig {
	db_path string
	reset   bool
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
	table_name := get_table_name(object)

	// create table for root object if it doesn't exist
	backend.create_root_object_table(object)!
	indices, values := object.sql_indices_values()
	insert_query := 'INSERT into ${table_name} (${indices.join(',')}) values (${values.join(',')})'
	backend.db.exec(insert_query) or {
		return error('Error inserting object ${object} into table ${table_name}\n${err}')
	}

	return 0
}

// save the session to redis & mem
pub fn (mut backend Indexer) set(obj RootObject) ! {
	table_name := get_table_name(obj)
	indices, values := obj.sql_indices_values()
	// todo: check table and entry exists

	mut sql_stmts := []string{}
	for i in 0 .. indices.len {
		sql_stmts << '${indices[i]}=${values[i]}'
	}
	backend.db.exec('update ${table_name} set ${sql_stmts.join(' ')} where id=${obj.id}')!
}

// save the session to redis & mem
pub fn (mut backend Indexer) delete(id string, obj RootObject) ! {
	table_name := get_table_name(obj)
	// todo: check table and entry exists
	backend.db.exec('delete from ${table_name} where id=${id}')!
}

pub fn (mut backend Indexer) get(id string, obj RootObject) !RootObject {
	json_value := backend.get_json(id, obj)!
	return root_object_from_json(json_value)
}

pub fn (mut backend Indexer) get_json(id string, obj RootObject) !string {
	table_name := get_table_name(obj)

	// check root object and table exists
	responses := backend.db.exec('select * from ${table_name} where id=${id}')!
	if responses.len == 0 {
		return error('Root object not found')
	} else if responses.len > 1 {
		panic('More than one result with same id found. This should never happen.')
	}

	return responses[0].vals[1]
}

pub fn (mut backend Indexer) list(obj RootObject) ![]u32 {
	table_name := get_table_name(obj)

	responses := backend.db.exec('select * from ${table_name}') or { panic(err) }
	ids := responses.map(it.vals[0].u32())
	return ids
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
	table_name := get_table_name(filter)

	if !backend.table_exists(table_name)! {
		return []string{}
	}
	table_indices := backend.get_table_indices(table_name) or { panic(err) }

	for field in filter.fields {
		if field.name !in table_indices {
			return error('Index ${field.name} not found for root struct ${filter.name}')
		}
	}
	mut select_stmt := 'select * from ${table_name}'

	// $if D.fields.len > 0 {
	select_stmt += ' where'

	mut matchers := []string{}
	for field in filter.fields {
		if field.typ == .text {
			matchers << "${field.name} == '${field.value}'"
		} else if field.typ == .number {
			matchers << '${field.name} == ${field.value}'
		}
	}
	matchers_str := if params.matches_all {
		matchers.join(' AND ')
	} else {
		matchers.join(' OR ')
	}
	select_stmt += ' ${matchers_str}'

	println(select_stmt)
	responses := backend.db.exec(select_stmt) or { panic(err) }
	ids := responses.map(it.vals[0])
	// objects := responses.map(json.decode(T, it.vals[1]) or { panic(err) })
	return if params.limit == 0 { ids.map(it.str()) } else { ids.map(it.str())[..params.limit] }
}

// create_root_struct_table creates a table for a root_struct with columns for each index field
fn (mut backend Indexer) create_root_object_table(object RootObject) ! {
	panic('implement')
}

// deletes an indexer table belonging to a root object
fn (mut backend Indexer) delete_table(object RootObject) ! {
	table_name := get_table_name(object)
	delete_query := 'delete table ${table_name}'
	backend.db.exec(delete_query)!
}

fn (mut backend Indexer) get_table_indices(table_name string) ![]string {
	table_info := backend.db.exec('pragma table_info(${table_name});')!
	if table_info.len == 0 {
		return error('table doesnt exist')
	}
	return table_info[1..].map(it.vals[1])
}

fn (mut backend Indexer) table_exists(table_name string) !bool {
	table_info := backend.db.exec('pragma table_info(${table_name});')!
	println('debugzore ${table_info} ${table_name}')
	if table_info.len == 0 {
		return false
	}
	return true
}

// get_table_name returns the name of the table belonging to a root struct
fn get_table_name(object RootObject) string {
	mut table_name := texttools.name_fix(object.name)
	table_name = table_name.replace('.', '_')
	return table_name
}
