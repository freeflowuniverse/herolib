module codegen

import freeflowuniverse.herolib.core.code { Alias, Attribute, CodeItem, Struct, StructField, Type }
import freeflowuniverse.herolib.schemas.jsonschema { Schema, SchemaRef, Reference }

const vtypes = {
	'integer': 'int'
	'string':  'string'
}

pub fn schema_to_v(schema Schema) !string {
	module_name := 'schema.title.'
	structs := schema_to_structs(schema)!
	// todo: report bug: return $tmpl(...)
	encoded := $tmpl('templates/schema.vtemplate')
	return encoded
}

// schema_to_structs encodes a schema into V structs.
// if a schema has nested object type schemas or defines object type schemas,
// recursively encodes object type schemas and pushes to the array of structs.
// returns an array of schemas that have been encoded into V structs.
pub fn schema_to_structs(schema Schema) ![]string {
	mut schemas := []string{}
	mut properties := ''

	// loop over properties
	for name, property_ in schema.properties {
		mut property := Schema{}
		mut typesymbol := ''

		if property_ is Reference {
			// if reference, set typesymbol as reference name
			ref := property_ as Reference
			typesymbol = ref_to_symbol(ref)
		} else {
			property = property_ as Schema
			typesymbol = schema_to_type(property)!
			// recursively encode property if object
			// todo: handle duplicates
			if property.typ == 'object' {
				structs := schema_to_structs(property)!
				schemas << structs
			}
		}

		properties += '\n\t${name} ${typesymbol}'
		if name in schema.required {
			properties += ' @[required]'
		}
	}
	schemas << $tmpl('templates/struct.vtemplate')
	return schemas
}

// schema_to_type generates a typesymbol for the schema
pub fn schema_to_type(schema Schema) !string {
	mut property_str := ''
	if schema.typ == 'null' {
		return ''
	}
	if schema.typ == 'object' {
		if schema.title == '' {
			return error('Object schemas must define a title.')
		}
		// todo: enforce uppercase
		property_str = schema.title
	} else if schema.typ == 'array' {
		// todo: handle multiple item schemas
		if schema.items is SchemaRef {
			// items := schema.items as SchemaRef
			if schema.items is Schema {
				items_schema := schema.items as Schema
				property_str = '[]${items_schema.typ}'
			}
		}
	} else if schema.typ in vtypes.keys() {
		property_str = vtypes[schema.typ]
	} else if schema.title != '' {
		property_str = schema.title
	} else {
		return error('unknown type `${schema.typ}` ')
	}
	return property_str
}

pub fn schema_to_code(schema Schema) !CodeItem {
	if schema.typ == 'object' {
		return CodeItem(schema_to_struct(schema)!)
	}
	if schema.typ in vtypes {
		return Alias{
			name: schema.title
			typ: Type{
				symbol: vtypes[schema.typ]
			}
		}
	}
	if schema.typ == 'array' {
		if schema.items is SchemaRef {
			if schema.items is Schema {
				items_schema := schema.items as Schema
				return Alias{
					name: schema.title
					typ: Type{
						symbol: '[]${items_schema.typ}'
					}
				}
			} else if schema.items is Reference {
				items_ref := schema.items as Reference
				return Alias{
					name: schema.title
					typ: Type{
						symbol: '[]${ref_to_symbol(items_ref)}'
					}
				}
			}
		}
	}
	return error('Schema type ${schema.typ} not supported for code generation')
}

pub fn schema_to_struct(schema Schema) !Struct {
	mut fields := []StructField{}

	for key, val in schema.properties {
		mut field := ref_to_field(val, key)!
		if field.name in schema.required {
			field.attrs << Attribute{
				name: 'required'
			}
		}
		fields << field
	}

	return Struct{
		name: schema.title
		description: schema.description
		fields: fields
	}
}

pub fn ref_to_field(schema_ref SchemaRef, name string) !StructField {
	if schema_ref is Reference {
		return StructField{
			name: name
			typ: Type{
				symbol: ref_to_symbol(schema_ref)
			}
		}
	} else if schema_ref is Schema {
		mut field := StructField{
			name: name
			description: schema_ref.description
		}
		if schema_ref.typ == 'object' {
			// then it is an anonymous struct
			field.anon_struct = schema_to_struct(schema_ref as Schema)!
			return field
		} else if schema_ref.typ in vtypes {
			field.typ.symbol = vtypes[schema_ref.typ]
			return field
		}
		return error('Schema type ${schema_ref.typ} not supported for code generation')
	}
	return error('Schema type not supported for code generation')
}

pub fn schemaref_to_type(schema_ref SchemaRef) !Type {
	return if schema_ref is Reference {
		ref_to_type_from_reference(schema_ref as Reference)
	} else {
		Type{
			symbol: schema_to_type(schema_ref as Schema)!
		}
	}
}

pub fn ref_to_symbol(reference Reference) string {
	return reference.ref.all_after_last('/')
}

pub fn ref_to_type_from_reference(reference Reference) Type {
	return Type{
		symbol: ref_to_symbol(reference)
	}
}