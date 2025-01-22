module runpod

pub const version = '1.14.3'
const singleton = false
const default = true

// heroscript_default returns the default heroscript configuration for RunPod
pub fn heroscript_default() !string {
	return "
    !!runpod.configure
        name:'default'
        api_key:''
        base_url:'https://api.runpod.io/'
    "
}

// RunPod represents a RunPod client instance
@[heap]
pub struct RunPod {
pub mut:
	name     string = 'default'
	api_key  string
	base_url string = 'https://api.runpod.io/'
}

pub enum CloudType {
	all
	secure
	community
}

fn (ct CloudType) str() string {
	return match ct {
		.all {
			'ALL'
		}
		.secure {
			'SECURE'
		}
		.community {
			'COMMUNITY'
		}
	}
}

pub struct EnvironmentVariableInput {
pub mut:
	key   string
	value string
}

// new creates a new RunPod client
pub fn new(api_key string) !&RunPod {
	if api_key == '' {
		return error('API key is required')
	}
	return &RunPod{
		api_key: api_key
	}
}

// GraphQL query structs
struct GqlQuery {
	query string
}

// GraphQL response wrapper
struct GqlResponse[T] {
pub mut:
	data   map[string]T
	errors []map[string]string
}
