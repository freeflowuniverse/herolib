module jina

import freeflowuniverse.herolib.core.httpconnection
import net.http
import x.json2

// Create embeddings for input texts
pub fn (mut j Jina) create_embeddings(input []string, model string, task string) !map[string]json2.Any {
	req := httpconnection.Request{
		method: .post
		prefix: 'v1/embeddings'
		dataformat: .json
		data: json.encode({
			'model': model
			'input': input
			'task': task
		})
	}
	
	return j.http.get_json_dict(req)!
}

// Create embeddings with a TextDoc input
pub struct TextDoc {
pub:
	id   string
	text string
}

pub fn (mut j Jina) create_embeddings_with_docs(input []TextDoc, model string, task string) !map[string]json2.Any {
	req := httpconnection.Request{
		method: .post
		prefix: 'v1/embeddings'
		dataformat: .json
		data: json.encode({
			'model': model
			'input': input
			'task': task
		})
	}
	
	return j.http.get_json_dict(req)!
}

// Rerank documents based on a query
pub fn (mut j Jina) rerank(query string, documents []string, model string) !map[string]json2.Any {
	req := httpconnection.Request{
		method: .post
		prefix: 'v1/rerank'
		dataformat: .json
		data: json.encode({
			'model': model
			'query': query
			'documents': documents
		})
	}
	
	return j.http.get_json_dict(req)!
}

// Classify input texts
pub fn (mut j Jina) classify(input []string, model string, labels []string) !map[string]json2.Any {
	req := httpconnection.Request{
		method: .post
		prefix: 'v1/classify'
		dataformat: .json
		data: json.encode({
			'model': model
			'input': input
			'labels': labels
		})
	}
	
	return j.http.get_json_dict(req)!
}

// Train a classifier
pub struct TrainingExample {
pub:
	text  string
	label string
}

pub fn (mut j Jina) train(examples []TrainingExample, model string, access string) !map[string]json2.Any {
	// Convert examples to the format expected by the API
	mut input := []map[string]string{}
	for example in examples {
		input << {
			'text': example.text
			'label': example.label
		}
	}

	req := httpconnection.Request{
		method: .post
		prefix: 'v1/train'
		dataformat: .json
		data: json.encode({
			'model': model
			'input': input
			'access': access
		})
	}
	
	return j.http.get_json_dict(req)!
}

// List classifiers
pub fn (mut j Jina) list_classifiers() !map[string]json2.Any {
	req := httpconnection.Request{
		method: .get
		prefix: 'v1/classifiers'
	}
	
	return j.http.get_json_dict(req)!
}

// Delete a classifier
pub fn (mut j Jina) delete_classifier(classifier_id string) !map[string]json2.Any {
	req := httpconnection.Request{
		method: .delete
		prefix: 'v1/classifiers/${classifier_id}'
	}
	
	return j.http.get_json_dict(req)!
}

// Create multi-vector embeddings
pub fn (mut j Jina) create_multi_vector(input []string, model string) !map[string]json2.Any {
	req := httpconnection.Request{
		method: .post
		prefix: 'v1/multi-vector'
		dataformat: .json
		data: json.encode({
			'model': model
			'input': input
		})
	}
	
	return j.http.get_json_dict(req)!
}

// Start a bulk embedding job
pub fn (mut j Jina) start_bulk_embedding(file_path string, model string, email string) !string {
	// This endpoint requires multipart/form-data which is not directly supported by the current HTTPConnection
	// We need to implement a custom solution for this
	return error('Bulk embedding is not implemented yet')
}

// Check if the API key is valid by making a simple request
pub fn (mut j Jina) check_auth() !bool {
	req := httpconnection.Request{
		method: .get
		prefix: '/'
	}
	
	response := j.http.get(req) or {
		return error('Failed to connect to Jina API: ${err}')
	}
	
	// If we get a response, the API key is valid
	return true
}

// Helper function to check if environment variable exists
pub fn env_exists(key string) bool {
	env := os.environ()
	return key in env
}
