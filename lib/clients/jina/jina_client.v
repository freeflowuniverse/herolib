module jina

import freeflowuniverse.herolib.core.httpconnection
import os
import json

@[params]
pub struct CreateEmbeddingParams {
pub mut:
	input         []string  @[required] // Input texts
	model         JinaModel @[required] // Model name
	task          string    @[required] // Task type
	type_         ?EmbeddingType // embedding type
	truncate      ?TruncateType  // truncation type
	late_chunking ?bool          // Flag to determine if late chunking is applied
}

// Create embeddings for input texts
pub fn (mut j Jina) create_embeddings(params CreateEmbeddingParams) !ModelEmbeddingOutput {
	task := task_type_from_string(params.task)!

	mut embedding_input := TextEmbeddingInput{
		input: params.input
		model: params.model.to_string()
		task:  task
	}

	if v := params.type_ {
		embedding_input.type_ = v
	}

	if v := params.truncate {
		embedding_input.truncate = v
	}

	embedding_input.late_chunking = if _ := params.late_chunking { true } else { false }

	req := httpconnection.Request{
		method:     .post
		prefix:     'v1/embeddings'
		dataformat: .json
		data:       embedding_input.to_json()
	}

	mut httpclient := j.httpclient()!
	response := httpclient.post_json_str(req)!
	return parse_model_embedding_output(response)!
}

// // Create embeddings with a TextDoc input
// pub fn (mut j Jina) create_embeddings_with_docs(args TextEmbeddingInput) !ModelEmbeddingOutput {

// 	req := httpconnection.Request{
// 		method: .post
// 		prefix: 'v1/embeddings'
// 		dataformat: .json
// 		data: json.encode(args)
// 	}

// 	response := j.http.get(req)!
// 	return parse_model_embedding_output(response)!
// }

// // Rerank documents based on a query
// pub fn (mut j Jina) rerank(query string, documents []string, model string, top_n int) !RankingOutput {
// 	mut rank_input := RankAPIInput{
// 		model: model
// 		query: query
// 		documents: documents
// 		top_n: top_n
// 	}

// 	req := httpconnection.Request{
// 		method: .post
// 		prefix: 'v1/rerank'
// 		dataformat: .json
// 		data: rank_input.to_json()
// 	}

// 	response := j.http.get(req)!
// 	return parse_ranking_output(response)!
// }

// // Simplified rerank function with default top_n
// pub fn (mut j Jina) rerank_simple(query string, documents []string, model string) !RankingOutput {
// 	return j.rerank(query, documents, model, 0)!
// }

// // Classify input texts
// pub fn (mut j Jina) classify(input []string, model string, labels []string) !ClassificationOutput {
// 	mut classification_input := ClassificationAPIInput{
// 		model: model
// 		input: input
// 		labels: labels
// 	}

// 	req := httpconnection.Request{
// 		method: .post
// 		prefix: 'v1/classify'
// 		dataformat: .json
// 		data: classification_input.to_json()
// 	}

// 	response := j.http.get(req)!
// 	return parse_classification_output(response)!
// }

// // Train a classifier
// pub fn (mut j Jina) train(examples []TrainingExample, model string, access string) !TrainingOutput {
// 	mut training_input := TrainingAPIInput{
// 		model: model
// 		input: examples
// 		access: access
// 	}

// 	req := httpconnection.Request{
// 		method: .post
// 		prefix: 'v1/train'
// 		dataformat: .json
// 		data: training_input.to_json()
// 	}

// 	response := j.http.get(req)!
// 	return parse_training_output(response)!
// }

// // List classifiers
// pub fn (mut j Jina) list_classifiers() !string {
// 	req := httpconnection.Request{
// 		method: .get
// 		prefix: 'v1/classifiers'
// 	}

// 	return j.http.get(req)!
// }

// // Delete a classifier
// pub fn (mut j Jina) delete_classifier(classifier_id string) !bool {
// 	req := httpconnection.Request{
// 		method: .delete
// 		prefix: 'v1/classifiers/${classifier_id}'
// 	}

// 	j.http.get(req)!
// 	return true
// }

// // Create multi-vector embeddings
// pub fn (mut j Jina) create_multi_vector(input []string, model string) !ColbertModelEmbeddingsOutput {
// 	mut data := map[string]json.Any{}
// 	data['model'] = model
// 	data['input'] = input

// 	req := httpconnection.Request{
// 		method: .post
// 		prefix: 'v1/multi-embeddings'
// 		dataformat: .json
// 		data: json.encode(data)
// 	}

// 	response := j.http.get(req)!
// 	return parse_colbert_model_embeddings_output(response)!
// }

// // Start a bulk embedding job
// pub fn (mut j Jina) start_bulk_embedding(file_path string, model string, email string) !BulkEmbeddingJobResponse {
// 	// This endpoint requires multipart/form-data which is not directly supported by the current HTTPConnection
// 	// We need to implement a custom solution for this
// 	return error('Bulk embedding is not implemented yet')
// }

// // Check the status of a bulk embedding job
// pub fn (mut j Jina) check_bulk_embedding_status(job_id string) !BulkEmbeddingJobResponse {
// 	req := httpconnection.Request{
// 		method: .get
// 		prefix: 'v1/bulk-embeddings/${job_id}'
// 	}

// 	response := j.http.get(req)!
// 	return parse_bulk_embedding_job_response(response)!
// }

// // Download the result of a bulk embedding job
// pub fn (mut j Jina) download_bulk_embedding_result(job_id string) !DownloadResultResponse {
// 	req := httpconnection.Request{
// 		method: .post
// 		prefix: 'v1/bulk-embeddings/${job_id}/download-result'
// 	}

// 	response := j.http.get(req)!
// 	return parse_download_result_response(response)!
// }

// // Check if the API key is valid by making a simple request
// pub fn (mut j Jina) check_auth() !bool {
// 	req := httpconnection.Request{
// 		method: .get
// 		prefix: '/'
// 	}

// 	j.http.get(req) or {
// 		return error('Failed to connect to Jina API: ${err}')
// 	}

// 	// If we get a response, the API key is valid
// 	return true
// }
