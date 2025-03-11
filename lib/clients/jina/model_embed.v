module jina

import json

// JinaModelEnumerator represents the available models for Jina API
pub enum JinaModelEnumerator {
	clip_v1                  // jina-clip-v1, 223M, 768
	clip_v2                  // jina-clip-v2, 865M, 1024
	embeddings_v2_base_en    // jina-embeddings-v2-base-en, 137M, 768
	embeddings_v2_base_es    // jina-embeddings-v2-base-es, 161M, 768
	embeddings_v2_base_de    // jina-embeddings-v2-base-de, 161M, 768
	embeddings_v2_base_zh    // jina-embeddings-v2-base-zh, 161M, 768
	embeddings_v2_base_code  // jina-embeddings-v2-base-code, 137M, 768
	embeddings_v3            // jina-embeddings-v3, 570M, 1024
}

// to_string converts JinaModelEnumerator enum to its string representation
pub fn (m JinaModelEnumerator) to_string() string {
	return match m {
		.clip_v1 { 'jina-clip-v1' }
		.clip_v2 { 'jina-clip-v2' }
		.embeddings_v2_base_en { 'jina-embeddings-v2-base-en' }
		.embeddings_v2_base_es { 'jina-embeddings-v2-base-es' }
		.embeddings_v2_base_de { 'jina-embeddings-v2-base-de' }
		.embeddings_v2_base_zh { 'jina-embeddings-v2-base-zh' }
		.embeddings_v2_base_code { 'jina-embeddings-v2-base-code' }
		.embeddings_v3 { 'jina-embeddings-v3' }
	}
}

// from_string converts string to JinaModelEnumerator enum
pub fn jina_model_from_string(s string) ?JinaModelEnumerator {
	return match s {
		'jina-clip-v1' { JinaModelEnumerator.clip_v1 }
		'jina-clip-v2' { JinaModelEnumerator.clip_v2 }
		'jina-embeddings-v2-base-en' { JinaModelEnumerator.embeddings_v2_base_en }
		'jina-embeddings-v2-base-es' { JinaModelEnumerator.embeddings_v2_base_es }
		'jina-embeddings-v2-base-de' { JinaModelEnumerator.embeddings_v2_base_de }
		'jina-embeddings-v2-base-zh' { JinaModelEnumerator.embeddings_v2_base_zh }
		'jina-embeddings-v2-base-code' { JinaModelEnumerator.embeddings_v2_base_code }
		'jina-embeddings-v3' { JinaModelEnumerator.embeddings_v3 }
		else { error('Invalid model string: $s') }
	}
}

// EmbeddingType represents the available embedding types
pub enum EmbeddingType {
	float    // "float"
	base64   // "base64"
	binary   // "binary"
	ubinary  // "ubinary"
}

// to_string converts EmbeddingType enum to its string representation
pub fn (t EmbeddingType) to_string() string {
	return match t {
		.float { 'float' }
		.base64 { 'base64' }
		.binary { 'binary' }
		.ubinary { 'ubinary' }
	}
}

// from_string converts string to EmbeddingType enum
pub fn embedding_type_from_string(s string) !EmbeddingType {
	return match s {
		'float' { EmbeddingType.float }
		'base64' { EmbeddingType.base64 }
		'binary' { EmbeddingType.binary }
		'ubinary' { EmbeddingType.ubinary }
		else { error('Invalid embedding type string: $s') }
	}
}

// TaskType represents the available task types for embeddings
pub enum TaskType {
	retrieval_query     // "retrieval.query"
	retrieval_passage   // "retrieval.passage"
	text_matching       // "text-matching"
	classification      // "classification"
	separation          // "separation"
}

// to_string converts TaskType enum to its string representation
pub fn (t TaskType) to_string() string {
	return match t {
		.retrieval_query { 'retrieval.query' }
		.retrieval_passage { 'retrieval.passage' }
		.text_matching { 'text-matching' }
		.classification { 'classification' }
		.separation { 'separation' }
	}
}

// from_string converts string to TaskType enum
pub fn task_type_from_string(s string) !TaskType {
	return match s {
		'retrieval.query' { TaskType.retrieval_query }
		'retrieval.passage' { TaskType.retrieval_passage }
		'text-matching' { TaskType.text_matching }
		'classification' { TaskType.classification }
		'separation' { TaskType.separation }
		else { error('Invalid task type string: $s') }
	}
}

// TruncateType represents the available truncation options
pub enum TruncateType {
	none  // "NONE"
	start // "START"
	end   // "END"
}

// to_string converts TruncateType enum to its string representation
pub fn (t TruncateType) to_string() string {
	return match t {
		.none { 'NONE' }
		.start { 'START' }
		.end { 'END' }
	}
}

// from_string converts string to TruncateType enum
pub fn truncate_type_from_string(s string) !TruncateType {
	return match s {
		'NONE' { TruncateType.none }
		'START' { TruncateType.start }
		'END' { TruncateType.end }
		else { error('Invalid truncate type string: $s') }
	}
}

// TextEmbeddingInputRaw represents the raw input for text embedding requests as sent to the server
struct TextEmbeddingInputRaw {
mut:
	model          string   = 'jina-embeddings-v2-base-en'
	input          []string @[required]
	task           string   // Optional: task type as string
	type_          string   @[json: 'type'] // Optional: embedding type as string
	truncate       string   // Optional: "NONE", "START", "END"
	late_chunking  bool     // Optional: Flag to determine if late chunking is applied
}

// TextEmbeddingInput represents the input for text embedding requests with enum types
pub struct TextEmbeddingInput {
pub mut:
	model          JinaModelEnumerator      = JinaModelEnumerator.embeddings_v2_base_en
	input          []string       @[required]
	task           TaskType      // task type
	type_          EmbeddingType // embedding type
	truncate       TruncateType  // truncation type
	late_chunking  bool           //Flag to determine if late chunking is applied
}

// dumps converts TextEmbeddingInput to JSON string
pub fn (t TextEmbeddingInput) dumps() !string {
	mut raw := TextEmbeddingInputRaw{
		model: t.model.to_string()
		input: t.input
		late_chunking: t.late_chunking
	}
	
	raw.task = t.task.to_string()
	raw.type_ = t.type_.to_string()
	raw.truncate = t.truncate.to_string()	
	return json.encode(raw)
}

// from_raw converts TextEmbeddingInputRaw to TextEmbeddingInput
pub fn loads_text_embedding_input(text string	) !TextEmbeddingInput {
	// TODO: go from text to InputObject over json
	mut input := TextEmbeddingInput{
		model: jina_model_from_string(raw.model)?
		input: raw.input
		late_chunking: raw.late_chunking
	}
	
	if raw.task != '' {
		input.task = task_type_from_string(raw.task)!
	}
	
	if raw.type_ != '' {
		input.type_ = embedding_type_from_string(raw.type_)!
	}
	
	if raw.truncate != '' {
		input.truncate = truncate_type_from_string(raw.truncate)!
	}
	
	return input
}

// loads converts a JSON string to TextEmbeddingInput
pub fn loads(text string) !TextEmbeddingInput {
	// First decode the JSON string to the raw struct
	raw := json.decode(TextEmbeddingInputRaw, text) or {
		return error('Failed to decode JSON: $err')
	}
	
	// Then convert the raw struct to the typed struct
	return text_embedding_input_from_raw(raw)
}

// TextDoc represents a document with ID and text for embedding
pub struct TextDoc {
pub mut:
	id   string
	text string
}

// ModelEmbeddingOutput represents the response from embedding requests
pub struct ModelEmbeddingOutput {
pub mut:
	model     string
	data      []EmbeddingData
	usage     Usage
	object    string
	dimension int
}

// EmbeddingData represents a single embedding result
pub struct EmbeddingData {
pub mut:
	embedding []f64
	index     int
	object    string
}

// Usage represents token usage information
pub struct Usage {
pub mut:
	total_tokens int
	unit         string
}
