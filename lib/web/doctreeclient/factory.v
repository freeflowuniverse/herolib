module doctreeclient
import freeflowuniverse.herolib.core.base

// new creates a new DocTreeClient instance
// path: The base path where doctree collections are exported (not used internally but kept for API consistency)
pub fn new(path string) !&DocTreeClient {
	mut context := base.context()!
	mut redis := context.redis()!

	return &DocTreeClient{
		redis: redis
	}
}

