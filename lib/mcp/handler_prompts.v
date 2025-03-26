module mcp

import time
import os
import log
import x.json2
import json
import freeflowuniverse.herolib.schemas.jsonrpc
import freeflowuniverse.herolib.mcp.logger

// Prompt related structs

pub struct Prompt {
pub:
	name        string
	description string
	arguments   []PromptArgument
}

pub struct PromptArgument {
pub:
	name        string
	description string
	required    bool
}

pub struct PromptMessage {
pub:
	role    string
	content PromptContent
}

pub struct PromptContent {
pub:
	typ      string @[json: 'type']
	text     string
	data     string
	mimetype string @[json: 'mimeType']
	resource ResourceContent
}

// Prompt List Handler

pub struct PromptListParams {
pub:
	cursor string
}

pub struct PromptListResult {
pub:
	prompts     []Prompt
	next_cursor string @[json: 'nextCursor']
}

// prompts_list_handler handles the prompts/list request
// This request is used to retrieve a list of available prompts
fn (mut s Server) prompts_list_handler(data string) !string {
	// Decode the request with cursor parameter
	request := jsonrpc.decode_request_generic[PromptListParams](data)!
	cursor := request.params.cursor

	// TODO: Implement pagination logic using the cursor
	// For now, return all prompts

	// Create a success response with the result
	response := jsonrpc.new_response_generic[PromptListResult](request.id, PromptListResult{
		prompts:     s.backend.prompt_list()!
		next_cursor: '' // Empty if no more pages
	})
	return response.encode()
}

// Prompt Get Handler

pub struct PromptGetParams {
pub:
	name      string
	arguments map[string]string
}

pub struct PromptGetResult {
pub:
	description string
	messages    []PromptMessage
}

// prompts_get_handler handles the prompts/get request
// This request is used to retrieve a specific prompt with arguments
fn (mut s Server) prompts_get_handler(data string) !string {
	// Decode the request with name and arguments parameters
	request := jsonrpc.decode_request_generic[PromptGetParams](data)!

	if !s.backend.prompt_exists(request.params.name)! {
		return jsonrpc.new_error_response(request.id, prompt_not_found(request.params.name)).encode()
	}

	// Get the prompt by name
	prompt := s.backend.prompt_get(request.params.name)!

	// Validate required arguments
	for arg in prompt.arguments {
		if arg.required && request.params.arguments[arg.name] == '' {
			return jsonrpc.new_error_response(request.id, missing_required_argument(arg.name)).encode()
		}
	}

	// Get the prompt messages with arguments applied
	messages := s.backend.prompt_messages_get(request.params.name, request.params.arguments)!

	// Create a success response with the result
	response := jsonrpc.new_response_generic[PromptGetResult](request.id, PromptGetResult{
		description: prompt.description
		messages:    messages
	})
	return response.encode()
}

// Prompt Notification Handlers

// send_prompts_list_changed_notification sends a notification when the list of prompts changes
pub fn (mut s Server) send_prompts_list_changed_notification() ! {
	// Check if the client supports this notification
	if !s.client_config.capabilities.roots.list_changed {
		return
	}

	// Create a notification
	notification := jsonrpc.new_blank_notification('notifications/prompts/list_changed')
	s.send(json.encode(notification))
	// Send the notification to all connected clients
	log.info('Sending prompts list changed notification: ${json.encode(notification)}')
}
