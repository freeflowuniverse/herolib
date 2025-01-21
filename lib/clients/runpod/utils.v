module runpod

import freeflowuniverse.herolib.core.httpconnection
import json

fn get_field_name(field FieldData) string {
	mut field_name := ''
	// Process attributes to fetch the JSON field name or fallback to field name
	if field.attrs.len > 0 {
		for attr in field.attrs {
			attrs := attr.trim_space().split(':')
			if attrs.len == 2 && attrs[0] == 'json' {
				field_name = attrs[1].trim_space()
				continue
			}
		}
	} else {
		field_name = field.name
	}
	return field_name
}

fn get_request_fields[T](struct_ T) string {
	// Start the current level
	mut body_ := '{ '
	mut fields := []string{}

	$for field in T.fields {
		mut string_ := ''
		omit := 'omitempty' in field.attrs
		mut empty_string := false
		$if field.typ is string {
			empty_string = struct_.$(field.name) == ''
		}
		if !omit || !empty_string {
			string_ += get_field_name(field)
			string_ += ': '

			$if field.is_enum {
				string_ += struct_.$(field.name).to_string()
			} $else $if field.typ is string {
				item := struct_.$(field.name)
				string_ += "\"${item}\""
			} $else $if field.is_array {
				string_ += '['
				for i in struct_.$(field.name) {
					string_ += get_request_fields(i)
				}
				string_ += ']'
			} $else $if field.is_struct {
				string_ += get_request_fields(struct_.$(field.name))
			} $else {
				item := struct_.$(field.name)
				string_ += '${item}'
			}

			fields << string_
		}
	}
	body_ += fields.join(', ')
	body_ += ' }'
	return body_
}

fn get_response_fields[R](struct_ R) string {
	// Start the current level
	mut body_ := '{ '

	$for field in R.fields {
		$if field.is_struct {
			// Recursively process nested structs
			body_ += '${field.name} '
			body_ += get_response_fields(struct_.$(field.name))
		} $else {
			body_ += get_field_name(field)
			body_ += ' '
		}
	}
	body_ += ' }'
	return body_
}

pub enum QueryType {
	query
	mutation
}

@[params]
pub struct BuildQueryArgs[T, R] {
pub:
	query_type     QueryType // query or mutation
	method_name    string
	request_model  T @[required]
	response_model R @[required]
}

fn build_query[T, R](args BuildQueryArgs[T, R]) string {
	// Convert input to JSON
	// input_json := json.encode(request)

	// Build the GraphQL mutation string
	mut request_fields := get_request_fields(args.request_model)
	mut response_fields := get_response_fields(args.response_model)

	// Wrap the query correctly
	query := '${args.query_type.to_string()} { ${args.method_name}(input: ${request_fields}) ${response_fields} }'

	// Wrap in the final structure
	gql := GqlQuery{
		query: query
	}

	// Return the final GraphQL query as a JSON string
	return json.encode(gql)
}

fn (q QueryType) to_string() string {
	return match q {
		.query {
			'query'
		}
		.mutation {
			'mutation'
		}
	}
}

enum HTTPMethod {
	get
	post
	put
	delete
}

fn (mut rp RunPod) make_request[T](method HTTPMethod, path string, data string) !T {
	mut request := httpconnection.Request{
		prefix:     path
		data:       data
		debug:      true
		dataformat: .json
	}

	mut http := rp.httpclient()!
	mut response := T{}

	match method {
		.get {
			request.method = .get
			response = http.get_json_generic[T](request)!
		}
		.post {
			request.method = .post
			response = http.post_json_generic[T](request)!
		}
		.put {
			request.method = .put
			response = http.put_json_generic[T](request)!
		}
		.delete {
			request.method = .delete
			response = http.delete_json_generic[T](request)!
		}
	}

	if response.errors.len > 0 {
		return error('Error while sending the request due to: ${response.errors[0]['message']}')
	}

	return response
}
