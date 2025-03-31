module openai

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
