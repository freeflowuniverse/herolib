module openai

import os

fn test_chat_completion() {
	mut client := get()!

	client.model_default = 'llama-3.3-70b-versatile'

	println(client.list_models()!)

	raise("sss")

	res := client.chat_completion( Messages{
		messages: [
			Message{
				role:    .user
				content: 'Say these words exactly as i write them with no punctuation: AI is getting out of hand'
			},
		]
	})!

	assert res.choices.len == 1

	assert res.choices[0].message.content == 'AI is getting out of hand'
}

// fn test_embeddings() {
// 	key := os.getenv('OPENAI_API_KEY')
// 	heroscript := '!!openai.configure api_key: "${key}"'

// 	play(heroscript: heroscript)!

// 	mut client := get()!

// 	res := client.create_embeddings(
// 		input: ['The food was delicious and the waiter..']
// 		model: .text_embedding_ada
// 	)!

// 	assert res.data.len == 1
// 	assert res.data[0].embedding.len == 1536
// }

// fn test_files() {
// 	key := os.getenv('OPENAI_API_KEY')
// 	heroscript := '!!openai.configure api_key: "${key}"'

// 	play(heroscript: heroscript)!

// 	mut client := get()!
// 	uploaded_file := client.upload_file(
// 		filepath: '${os.dir(@FILE) + '/testdata/testfile.txt'}'
// 		purpose:  .assistants
// 	)!

// 	assert uploaded_file.filename == 'testfile.txt'
// 	assert uploaded_file.purpose == 'assistants'

// 	got_file := client.get_file(uploaded_file.id)!
// 	assert got_file == uploaded_file

// 	uploaded_file2 := client.upload_file(
// 		filepath: '${os.dir(@FILE) + '/testdata/testfile2.txt'}'
// 		purpose:  .assistants
// 	)!

// 	assert uploaded_file2.filename == 'testfile2.txt'
// 	assert uploaded_file2.purpose == 'assistants'

// 	mut got_list := client.list_files()!

// 	assert got_list.data.len >= 2 // there could be other older files

// 	mut ids := []string{}
// 	for file in got_list.data {
// 		ids << file.id
// 	}

// 	assert uploaded_file.id in ids
// 	assert uploaded_file2.id in ids

// 	for file in got_list.data {
// 		client.delete_file(file.id)!
// 	}

// 	got_list = client.list_files()!
// 	assert got_list.data.len == 0
// }

// fn test_audio() {
// 	key := os.getenv('OPENAI_API_KEY')
// 	heroscript := '!!openai.configure api_key: "${key}"'

// 	play(heroscript: heroscript)!

// 	mut client := get()!

// 	// create speech
// 	client.create_speech(
// 		input:       'the quick brown fox jumps over the lazy dog'
// 		output_path: '/tmp/output.mp3'
// 	)!

// 	assert os.exists('/tmp/output.mp3')
// }
