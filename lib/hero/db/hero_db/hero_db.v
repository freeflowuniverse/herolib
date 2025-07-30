module hero_db

import json
import freeflowuniverse.herolib.clients.postgresql_client
import freeflowuniverse.herolib.core.texttools
import time

// Generic database interface for Hero root objects
pub struct HeroDB[T] {
	db_client &postgresql_client.PostgresClient
	table_name string
}

// Initialize a new HeroDB instance for a specific type
pub fn new[T](client &postgresql_client.PostgresClient) HeroDB[T] {
	mut table_name := '${texttools.snake_case(T.name)}s'
	// Map dirname from module path
	module_path := T.name.split('.')
	if module_path.len >= 2 {
		dirname := texttools.snake_case(module_path[module_path.len - 2])
		table_name = '${dirname}_${texttools.snake_case(T.name)}'
	}
	
	return HeroDB[T]{
		db_client: client
		table_name: table_name
	}
}

// Ensure table exists with proper schema
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
	
	self.db_client.exec(create_sql)!
	
	// Create indexes on index fields
	for field in index_fields {
		index_sql := 'CREATE INDEX IF NOT EXISTS idx_${self.table_name}_${field} ON ${self.table_name}(${field})'
		self.db_client.exec(index_sql)!
	}
}

// Get index fields marked with @[index] from struct
fn (self HeroDB[T]) get_index_fields() []string {
	mut fields := []string{}
	$for field in T.fields {
		$if field.attributes.len > 0 {
			$for attr in field.attributes {
				$if attr == 'index' {
					fields << texttools.snake_case(field.name)
				}
			}
		}
	}
	return fields
}

// Save object to database
pub fn (mut self HeroDB[T]) save(obj &T) ! {
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
	
	existing := self.db_client.exec(query)!
	
	if existing.len > 0 {
		// Update existing record
		id := existing[0].vals[0].int()
		update_sql := '
			UPDATE ${self.table_name} 
			SET data = \$1, updated_at = CURRENT_TIMESTAMP
			WHERE id = \$2
		'
		self.db_client.exec(update_sql.replace('\$1', "'${json_data}'").replace('\$2', id.str()))!
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
		self.db_client.exec(insert_sql)!
	}
}

// Get object by index values
pub fn (mut self HeroDB[T]) get_by_index(index_values map[string]string) !&T {
	mut query := 'SELECT data FROM ${self.table_name} WHERE '
	mut params := []string{}
	
	for key, value in index_values {
		params << '${key} = \'${value}\''
	}
	query += params.join(' AND ')
	
	rows := self.db_client.exec(query)!
	if rows.len == 0 {
		return error('${T.name} not found with index values: ${index_values}')
	}
	
	json_data := rows[0].vals[0].str()
	mut obj := json.decode(T, json_data) or {
		return error('Failed to decode JSON: ${err}')
	}
	
	return &obj
}

// Get all objects
pub fn (mut self HeroDB[T]) get_all() ![]&T {
	query := 'SELECT data FROM ${self.table_name} ORDER BY id DESC'
	rows := self.db_client.exec(query)!
	
	mut results := []&T{}
	for row in rows {
		json_data := row.vals[0].str()
		obj := json.decode(T, json_data) or {
			continue // Skip invalid JSON
		}
		results << &obj
	}
	
	return results
}

// Search by index field
pub fn (mut self HeroDB[T]) search_by_index(field_name string, value string) ![]&T {
	query := 'SELECT data FROM ${self.table_name} WHERE ${field_name} = \'${value}\' ORDER BY id DESC'
	rows := self.db_client.exec(query)!
	
	mut results := []&T{}
	for row in rows {
		json_data := row.vals[0].str()
		obj := json.decode(T, json_data) or {
			continue
		}
		results << &obj
	}
	
	return results
}

// Delete by index values
pub fn (mut self HeroDB[T]) delete_by_index(index_values map[string]string) ! {
	mut query := 'DELETE FROM ${self.table_name} WHERE '
	mut params := []string{}
	
	for key, value in index_values {
		params << '${key} = \'${value}\''
	}
	query += params.join(' AND ')
	
	self.db_client.exec(query)!
}

// Helper to extract index values from object
fn (self HeroDB[T]) extract_index_values(obj &T) map[string]string {
	mut index_data := map[string]string{}
	
	$for field in T.fields {
		$if field.attributes.len > 0 {
			$for attr in field.attributes {
				$if attr == 'index' {
					field_name := texttools.snake_case(field.name)
					$if field.typ is string {
						value := obj.$(field.name).str()
						index_data[field_name] = value
					} $else $if field.typ is u32 || field.typ is u64 {
						value := obj.$(field.name).str()
						index_data[field_name] = value
					} $else {
						// Convert other types to string
						value := obj.$(field.name).str()
						index_data[field_name] = value
					}
				}
			}
		}
	}
	
	return index_data
}
