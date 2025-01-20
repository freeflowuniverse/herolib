module runpod

import freeflowuniverse.herolib.core.httpconnection
import json

fn (mut rp RunPod) get_field_name(field FieldData) string {
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

fn (mut rp RunPod) get_request_fields[T](struct_ T) string {
	// Start the current level
	mut body_ := '{ '
	mut fields := []string{}

	$for field in T.fields {
		mut string_ := ''
		string_ += rp.get_field_name(field)
		string_ += ': '

		$if field.is_enum {
			string_ += struct_.$(field.name).to_string()
		}

		$if field.typ is string {
			item := struct_.$(field.name)
			string_ += "\"${item}\""
		}

		$if field.typ is int {
			item := struct_.$(field.name)
			string_ += '${item}'
		}

		// TODO: Loop only on the env map
		$if field.is_array {
			for i in struct_.$(field.name) {
				for k, v in i {
					string_ += '[{ '
					string_ += "key: \"${k}\", value: \"${v}\""
					string_ += ' }]'
				}
			}
		}

		$if field.is_struct {
			rp.get_request_fields(struct_.$(field.name))
		}

		fields << string_
	}
	body_ += fields.join(', ')
	body_ += ' }'
	return body_
}

fn (mut rp RunPod) get_response_fields[R](struct_ R) string {
	// Start the current level
	mut body_ := '{ '

	$for field in R.fields {
		$if field.is_struct {
			// Recursively process nested structs
			body_ += '${field.name} '
			body_ += rp.get_response_fields(struct_.$(field.name))
		} $else {
			body_ += rp.get_field_name(field)
			body_ += ' '
		}
	}
	body_ += ' }'
	return body_
}

fn (mut rp RunPod) build_query[T, R](request T, response R) string {
	// Convert input to JSON
	// input_json := json.encode(request)

	// Build the GraphQL mutation string
	mut request_fields := rp.get_request_fields(request)
	mut response_fields := rp.get_response_fields(response)

	// Wrap the query correctly
	query := 'mutation { podFindAndDeployOnDemand(input: ${request_fields}) ${response_fields} }'

	// Wrap in the final structure
	gql := GqlQuery{
		query: query
	}

	// Return the final GraphQL query as a JSON string
	return json.encode(gql)
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
	return response
}
