#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

module main

import freeflowuniverse.herolib.clients.openai
import os

fn main() {
	// Get API key from environment variable
	key := os.getenv('GROQ_API_KEY')
	if key == '' {
		println('Error: GROQ_API_KEY environment variable not set')
		println('Please set it by running: source .env')
		exit(1)
	}

	// Get the configured client
	mut client := openai.OpenAI {
		name: 'groq'
		api_key: key
		server_url: 'https://api.groq.com/openai/v1'
	}

	// Define the model and message for chat completion
	// Note: Use a model that Groq supports, like llama2-70b-4096 or mixtral-8x7b-32768
	model := 'qwen-2.5-coder-32b'

	// Create a chat completion request
	res := client.chat_completion(model, openai.Messages{
		messages: [
			openai.Message{
				role: .user
				content: 'What are the key differences between Groq and other AI inference providers?'
			}
		]
	})!

	// Print the response
	println('\nGroq AI Response:')
	println('==================')
	println(res.choices[0].message.content)
	println('\nUsage Statistics:')
	println('Prompt tokens: ${res.usage.prompt_tokens}')
	println('Completion tokens: ${res.usage.completion_tokens}')
	println('Total tokens: ${res.usage.total_tokens}')
}
