module jina

import json
import freeflowuniverse.herolib.core.httpconnection

// ClassificationTrainAccess represents the accessibility of the classifier
pub enum ClassificationTrainAccess {
	public  // Classifier is publicly accessible
	private // Classifier is private (default)
}

// TrainingExample represents a single training example (either text or image with a label)
pub struct TrainingExample {
pub mut:
	text  ?string // Optional text content
	image ?string // Optional image URL
	label string  // Required label
}

// ClassificationTrainOutput represents the response from the training endpoint
pub struct ClassificationTrainOutput {
pub mut:
	classifier_id string                   // Identifier of the trained classifier
	num_samples   int                      // Number of samples used in training
	usage         ClassificationTrainUsage // Token usage details
}

// ClassificationTrainUsage represents token usage for the training request
pub struct ClassificationTrainUsage {
pub mut:
	total_tokens int // Total tokens consumed
}

// ClassificationTrain represents parameters for the training request
@[params]
pub struct ClassificationTrain {
pub mut:
	model         ?JinaModel // Optional model identifier (e.g., jina-clip-v1)
	classifier_id ?string    // Optional existing classifier ID
	access        ?ClassificationTrainAccess = .private // Accessibility, defaults to private
	input         []TrainingExample // Array of training examples
	num_iters     ?int = 10 // Number of training iterations, defaults to 10
}

// TrainRequest represents the JSON request body for the /v1/train endpoint
struct TrainRequest {
mut:
	model         ?string
	classifier_id ?string
	access        ?string
	input         []TrainingExample
	num_iters     ?int
}

// Train a classifier by sending a POST request to /v1/train
pub fn (mut j Jina) train(params ClassificationTrain) !ClassificationTrainOutput {
	// Validate that only one of model or classifier_id is provided
	mut model_provided := false
	mut classifier_id_provided := false
	if _ := params.model {
		model_provided = true
	}

	if _ := params.classifier_id {
		classifier_id_provided = true
	}

	if model_provided && classifier_id_provided {
		return error('Provide either model or classifier_id, not both')
	}

	if model := params.model {
		if model == .jina_embeddings_v3 {
			return error('jina-embeddings-v3 is not a valid model for classification')
		}
	}

	// Validate each training example has exactly one of text or image
	for example in params.input {
		mut text_provided := false
		mut image_provided := false

		if _ := example.text {
			text_provided = true
		}

		if _ := example.image {
			image_provided = true
		}

		if text_provided && image_provided {
			return error('Each training example must have either text or image, not both')
		}

		if !text_provided && !image_provided {
			return error('Each training example must have either text or image')
		}
	}

	// Construct the request body
	mut request := TrainRequest{
		input: params.input
	}
	if v := params.model {
		request.model = v.to_string() // Convert JinaModel enum to string
	}
	if v := params.classifier_id {
		request.classifier_id = v
	}
	if v := params.access {
		request.access = match v {
			.public { 'public' }
			.private { 'private' }
		}
	}
	if v := params.num_iters {
		request.num_iters = v
	}

	// Create and send the HTTP request
	req := httpconnection.Request{
		method:     .post
		prefix:     'v1/train'
		dataformat: .json
		data:       json.encode(request)
	}

	mut httpclient := j.httpclient()!
	response := httpclient.post_json_str(req)!
	result := json.decode(ClassificationTrainOutput, response)!
	return result
}
