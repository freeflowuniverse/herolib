module openai

pub enum ModelType {
	gpt_4o_2024_08_06
	gpt_3_5_turbo
	gpt_4
	gpt_4_0613
	gpt_4_32k
	gpt_4_32k_0613
	gpt_3_5_turbo_0613
	gpt_3_5_turbo_16k
	gpt_3_5_turbo_16k_0613
	whisper_1
	tts_1
}

fn modelname_str(e ModelType) string {
	return match e {
		.tts_1 {
			'tts-1'
		}
		.gpt_4o_2024_08_06 {
			'gpt-4o-2024-08-06'
		}
		.gpt_4 {
			'gpt-4'
		}
		.gpt_3_5_turbo {
			'gpt-3.5-turbo'
		}
		.gpt_4_0613 {
			'gpt-4-0613'
		}
		.gpt_4_32k {
			'gpt-4-32k'
		}
		.gpt_4_32k_0613 {
			'gpt-4-32k-0613'
		}
		.gpt_3_5_turbo_0613 {
			'gpt-3.5-turbo-0613'
		}
		.gpt_3_5_turbo_16k {
			'gpt-3.5-turbo-16k'
		}
		.gpt_3_5_turbo_16k_0613 {
			'gpt-3.5-turbo-16k-0613'
		}
		.whisper_1 {
			'whisper-1'
		}
	}
}

pub enum RoleType {
	system
	user
	assistant
	function
}

fn roletype_str(x RoleType) string {
	return match x {
		.system {
			'system'
		}
		.user {
			'user'
		}
		.assistant {
			'assistant'
		}
		.function {
			'function'
		}
	}
}

pub enum Voice {
	alloy
	ash
	coral
	echo
	fable
	onyx
	nova
	sage
	shimmer
}

fn voice_str(x Voice) string {
	return match x {
		.alloy {
			'alloy'
		}
		.ash {
			'ash'
		}
		.coral {
			'coral'
		}
		.echo {
			'echo'
		}
		.fable {
			'fable'
		}
		.onyx {
			'onyx'
		}
		.nova {
			'nova'
		}
		.sage {
			'sage'
		}
		.shimmer {
			'shimmer'
		}
	}
}

pub enum AudioFormat {
	mp3
	opus
	aac
	flac
	wav
	pcm
}

fn audio_format_str(x AudioFormat) string {
	return match x {
		.mp3 {
			'mp3'
		}
		.opus {
			'opus'
		}
		.aac {
			'aac'
		}
		.flac {
			'flac'
		}
		.wav {
			'wav'
		}
		.pcm {
			'pcm'
		}
	}
}
