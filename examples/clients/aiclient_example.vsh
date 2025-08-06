#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.clients.openai
import freeflowuniverse.herolib.core.playcmds

playcmds.run(
	heroscript: '
		!!openai.configure name: "default" key: "" url: "https://openrouter.ai/api/v1" model_default: "gpt-oss-120b"
	'
)!

// name:'default' is the default, you can change it to whatever you want
mut client := openai.get()!

mut r := client.chat_completion(
	model:                 'gpt-3.5-turbo'
	message:               'Hello, world!'
	temperature:           0.5
	max_completion_tokens: 1024
)!
