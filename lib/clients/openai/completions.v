module openai

import json

pub struct ChatCompletion {
pub mut:
	id      string
	object  string
	created u32
	choices []Choice
	usage   Usage
}

pub struct Choice {
pub mut:
	index         int
	message       MessageRaw
	finish_reason string
}

pub struct Message {
pub mut:
	role    RoleType
	content string
}

pub struct Usage {
pub mut:
	prompt_tokens     int
	completion_tokens int
	total_tokens      int
}

pub struct Messages {
pub mut:
	messages []Message
}

pub struct MessageRaw {
pub mut:
	role    string
	content string
}

struct ChatMessagesRaw {
mut:
	model    string
	messages []MessageRaw
	temperature f64 = 0.5
	max_completion_tokens int = 32000
}

@[params]
pub struct CompletionArgs{
pub mut:
	model string
	msgs Messages
	temperature f64 = 0.5
	max_completion_tokens int = 32000
}

// creates a new chat completion given a list of messages
// each message consists of message content and the role of the author
pub fn (mut f OpenAI) chat_completion(args_ CompletionArgs) !ChatCompletion {
	mut args:=args_
	if args.model==""{
		args.model = f.model_default
	}
	mut m := ChatMessagesRaw{
		model: args.model
		temperature: args.temperature
		max_completion_tokens: args.max_completion_tokens
	}
	for msg in args.msgs.messages {
		mr := MessageRaw{
			role:    roletype_str(msg.role)
			content: msg.content
		}
		m.messages << mr
	}
	data := json.encode(m)
	// println('data: ${data}')
	mut conn := f.connection()!
	r := conn.post_json_str(prefix: 'chat/completions', data: data)!
	// println('res: ${r}')

	res := json.decode(ChatCompletion, r)!
	return res
}
