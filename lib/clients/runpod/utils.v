module runpod

import freeflowuniverse.herolib.core.httpconnection
import json

// Represents the main structure for interacting with the RunPod API.
// Provides utilities to manage HTTP connections and perform GraphQL queries.
fn (mut rp RunPod) httpclient() !&httpconnection.HTTPConnection {
	mut http_conn := httpconnection.new(
		name:  'runpod_vclient_${rp.name}'
		url:   rp.base_url
		cache: true
		retry: 3
	)!
	http_conn.default_header.add(.authorization, 'Bearer ${rp.api_key}')
	return http_conn
}

// Retrieves the field name from the `FieldData` struct, either from its attributes or its name.
fn get_field_name(field FieldData) string {
	mut field_name := ''
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

// Constructs JSON-like request fields from a struct.
fn get_request_fields[T](struct_ T) string {
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

// Constructs JSON-like response fields for a given struct.
fn get_response_fields[R](struct_ R) string {
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

// Enum representing the type of GraphQL operation.
pub enum QueryType {
	query
	mutation
}

// Struct for building GraphQL queries with request and response models.
@[params]
pub struct BuildQueryArgs[T, R] {
pub:
	query_type     QueryType // query or mutation
	method_name    string
	request_model  T @[required]
	response_model R @[required]
}

// Builds a GraphQL query or mutation string from provided arguments.
fn build_query[T, R](args BuildQueryArgs[T, R]) string {
	mut request_fields := T{}
	mut response_fields := R{}

	if args.request_model {
		request_fields = get_request_fields(args.request_model)
	}

	if args.response_model {
		response_fields = get_response_fields(args.response_model)
	}

	mut query := ''

	if args.request_model  && args.response_model{
		query := '${args.query_type.to_string()} { ${args.method_name}(input: ${request_fields}) ${response_fields} }'
	}

	if args.response_model && !args.request_model{
		query := '${args.query_type.to_string()} { ${response_fields} }'	
	}

	// Wrap in the final structure
	gql := GqlQuery{
		query: query
	}

	// Return the final GraphQL query as a JSON string
	return json.encode(gql)
}

// Converts the `QueryType` enum to its string representation.
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

// Enum representing HTTP methods.
enum HTTPMethod {
	get
	post
	put
	delete
}

// Sends an HTTP request to the RunPod API with the specified method, path, and data.
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
