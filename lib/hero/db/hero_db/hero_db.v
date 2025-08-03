module hero_db

import json
import freeflowuniverse.herolib.clients.postgresql_client
import db.pg
import freeflowuniverse.herolib.core.texttools

// Generic database interface for Hero root objects
pub struct HeroDB[T] {
pub mut:
	db pg.DB
	table_name string
}

// new creates a new HeroDB instance for a specific type T
pub fn new[T]() !HeroDB[T] {
	mut table_name := '${texttools.snake_case(T.name)}s'
	// Map dirname from module path
	module_path := T.name.split('.')
	if module_path.len >= 2 {
		dirname := texttools.snake_case(module_path[module_path.len - 2])
		table_name = '${dirname}_${texttools.snake_case(T.name)}'
	}

	mut dbclient:=postgresql_client.get()!

	mut dbcl:=dbclient.db() or {
			return error('Failed to connect to database')
		}
	
	return HeroDB[T]{
		db: dbcl
		table_name: table_name
	}
}

// ensure_table creates the database table with proper schema for type T
pub fn (mut self HeroDB[T]) ensure_table() ! {
	// Get index fields from struct reflection
	index_fields := self.get_index_fields()
	
	// Build index column definitions
	mut index_cols := []string{}
	for field in index_fields {
		index_cols << '${field} varchar(255)'
	}
	
	// Create table with JSON storage
	create_sql := '
		CREATE TABLE IF NOT EXISTS ${self.table_name} (
			id serial PRIMARY KEY,
			${index_cols.join(', ')},
			data jsonb NOT NULL,
			created_at timestamp DEFAULT CURRENT_TIMESTAMP,
			updated_at timestamp DEFAULT CURRENT_TIMESTAMP
		)
	'
	
	// self.db.exec(create_sql)!
	
	// Create indexes on index fields
	for field in index_fields {
		index_sql := 'CREATE INDEX IF NOT EXISTS idx_${self.table_name}_${field} ON ${self.table_name}(${field})'
		// self.db.exec(index_sql)!
	}
}

// Get index fields marked with @[index] from struct
fn (self HeroDB[T]) get_index_fields() []string {
	mut fields := []string{}
	$for field in T.fields {
		if field.attrs.contains('index') {
			fields << texttools.snake_case(field.name)
		}
	}
	return fields
}

// save stores the object T in the database, updating if it already exists
pub fn (mut self HeroDB[T]) save(obj T) ! {
	// Get index values from object
	index_data := self.extract_index_values(obj)
	
	// Serialize to JSON
	json_data := json.encode_pretty(obj)
	
	// Check if object already exists
	mut query := 'SELECT id FROM ${self.table_name} WHERE '
	mut params := []string{}
	
	// Build WHERE clause for unique lookup
	for key, value in index_data {
		params << '${key} = \'${value}\''
	}
	query += params.join(' AND ')
	
	existing :=self.db.exec(query)!
	
	if existing.len > 0 {
		// Update existing record
		id_val := existing[0].vals[0] or { return error('no id') }
		// id := id_val.int()
		println('Updating existing record with ID: ${id_val}')
		if true {
			panic('sd111')
		}
		// update_sql := '
		// 	UPDATE ${self.table_name}
		// 	SET data = \$1, updated_at = CURRENT_TIMESTAMP
		// 	WHERE id = \$2
		// '
		// self.db_client.db()!.exec_param(update_sql, [json_data, id.str()])!
	} else {
		// Insert new record
		mut columns := []string{}
		mut values := []string{}
		
		// Add index columns
		for key, value in index_data {
			columns << key
			values << "'${value}'"
		}
		
		// Add JSON data
		columns << 'data'
		values << "'${json_data}'"
		
		insert_sql := '
			INSERT INTO ${self.table_name} (${columns.join(', ')})
			VALUES (${values.join(', ')})
		'
		// self.db.exec(insert_sql)!
	}
}

// get_by_index retrieves an object T by its index values
pub fn (mut self HeroDB[T]) get_by_index(index_values map[string]string) !T {
	mut query := 'SELECT data FROM ${self.table_name} WHERE '
	mut params := []string{}
	
	for key, value in index_values {
		params << '${key} = \'${value}\''
	}
	query += params.join(' AND ')

	rows := self.db.exec(query)!
	if rows.len == 0 {
		return error('${T.name} not found with index values: ${index_values}')
	}
	
	json_data_val := rows[0].vals[0] or { return error('no data') }
	println('json_data_val: ${json_data_val}')
	if true{
		panic('sd2221')
	}
	// mut obj := json.decode(T, json_data_val) or {
	// 	return error('Failed to decode JSON: ${err}')
	// }
	
	// return &obj
	return T{}
}

// // get_all retrieves all objects T from the database
// pub fn (mut self HeroDB[T]) get_all() ![]T {
// 	query := 'SELECT data FROM ${self.table_name} ORDER BY id DESC'
// 	rows := self.db_client.db()!.exec(query)!
	
// 	mut results := []T{}
// 	for row in rows {
// 		json_data_val := row.vals[0] or { continue }
// 		json_data := json_data_val.str()
// 		mut obj := json.decode(T, json_data) or {
// 			// e.g. an error could be given here
// 			continue // Skip invalid JSON
// 		}
// 		results << &obj
// 	}
	
// 	return results
// }

// // search_by_index searches for objects T by a specific index field
// pub fn (mut self HeroDB[T]) search_by_index(field_name string, value string) ![]T {
// 	query := 'SELECT data FROM ${self.table_name} WHERE ${field_name} = \'${value}\' ORDER BY id DESC'
// 	rows := self.db_client.db()!.exec(query)!
	
// 	mut results := []T{}
// 	for row in rows {
// 		json_data_val := row.vals[0] or { continue }
// 		json_data := json_data_val.str()
// 		mut obj := json.decode(T, json_data) or {
// 			continue
// 		}
// 		results << &obj
// 	}
	
// 	return results
// }

// // delete_by_index removes objects T matching the given index values
// pub fn (mut self HeroDB[T]) delete_by_index(index_values map[string]string) ! {
// 	mut query := 'DELETE FROM ${self.table_name} WHERE '
// 	mut params := []string{}
	
// 	for key, value in index_values {
// 		params << '${key} = \'${value}\''
// 	}
// 	query += params.join(' AND ')
	
// 	self.db_client.db()!.exec(query)!
// }

// Helper to extract index values from object
fn (self HeroDB[T]) extract_index_values(obj T) map[string]string {
	mut index_data := map[string]string{}
	$for field in T.fields {
		// $if field.attrs.contains('index') {
		// 	field_name := texttools.snake_case(field.name)
		// 	$if field.typ is string {
		// 		value := obj.$(field.name)
		// 		index_data[field_name] = value
		// 	} $else $if field.typ is int {
		// 		value := obj.$(field.name).str()
		// 		index_data[field_name] = value
		// 	} $else {
		// 		value := obj.$(field.name).str()
		// 		index_data[field_name] = value
		// 	}
		// }
	}
	return index_data
}
