module jina

import json

// BulkEmbeddingJobResponse represents the response from bulk embedding operations
pub struct BulkEmbeddingJobResponse {
pub mut:
	job_id        string
	status        string
	model         string
	created_at    string
	completed_at  string
	error_message string
}

// DownloadResultResponse represents the response for downloading bulk embedding results
pub struct DownloadResultResponse {
pub mut:
	download_url string
	expires_at   string
}

// MultiVectorUsage represents token usage information for multi-vector embeddings
pub struct MultiVectorUsage {
pub mut:
	total_tokens int
}

// MultiVectorEmbeddingData represents a single multi-vector embedding result
pub struct MultiVectorEmbeddingData {
pub mut:
	embeddings [][]f64
	index      int
}

// ColbertModelEmbeddingsOutput represents the response from multi-vector embedding requests
pub struct ColbertModelEmbeddingsOutput {
pub mut:
	model  string
	object string
	data   []MultiVectorEmbeddingData
	usage  MultiVectorUsage
}

// HTTPValidationError represents a validation error response
pub struct HTTPValidationError {
pub mut:
	detail []ValidationError
}

// ValidationError represents a single validation error
pub struct ValidationError {
pub mut:
	loc   []string
	msg   string
	type_ string @[json: 'type'] // 'type' is a keyword, so we need to specify the JSON name
}

// Serialize and deserialize functions for the main request/response types

// Serialize TextEmbeddingInput to JSON
pub fn (input TextEmbeddingInput) to_json() string {
	return json.encode(input)
}

// Parse JSON to TextEmbeddingInput
pub fn parse_text_embedding_input(json_str string) !TextEmbeddingInput {
	return json.decode(TextEmbeddingInput, json_str)
}

// Parse JSON to ModelEmbeddingOutput
pub fn parse_model_embedding_output(json_str string) !ModelEmbeddingOutput {
	return json.decode(ModelEmbeddingOutput, json_str)
}

// // Serialize RankAPIInput to JSON
// pub fn (input RankAPIInput) to_json() string {
// 	return json.encode(input)
// }

// Parse JSON to RankingOutput
pub fn parse_ranking_output(json_str string) !RankingOutput {
	return json.decode(RankingOutput, json_str)
}

// Parse JSON to BulkEmbeddingJobResponse
pub fn parse_bulk_embedding_job_response(json_str string) !BulkEmbeddingJobResponse {
	return json.decode(BulkEmbeddingJobResponse, json_str)
}

// Parse JSON to DownloadResultResponse
pub fn parse_download_result_response(json_str string) !DownloadResultResponse {
	return json.decode(DownloadResultResponse, json_str)
}

// Parse JSON to ColbertModelEmbeddingsOutput
pub fn parse_colbert_model_embeddings_output(json_str string) !ColbertModelEmbeddingsOutput {
	return json.decode(ColbertModelEmbeddingsOutput, json_str)
}

// Parse JSON to HTTPValidationError
pub fn parse_http_validation_error(json_str string) !HTTPValidationError {
	return json.decode(HTTPValidationError, json_str)
}
