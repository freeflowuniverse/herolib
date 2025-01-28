module collection

import freeflowuniverse.herolib.core.pathlib { Path }
import freeflowuniverse.herolib.data.doctree.collection.data
import freeflowuniverse.herolib.core.texttools

@[heap]
pub struct Collection {
pub mut:
	name          string @[required]
	path          Path   @[required]
	fail_on_error bool
	heal          bool = true
	pages         map[string]&data.Page
	files         map[string]&data.File
	images        map[string]&data.File
	errors        []CollectionError
}

@[params]
pub struct CollectionNewArgs {
pub mut:
	name          string @[required]
	path          string @[required]
	heal          bool = true // healing means we fix images, if selected will automatically load, remove stale links
	load          bool = true
	fail_on_error bool
}

// get a new collection
pub fn new(args_ CollectionNewArgs) !Collection {
	mut args := args_
	args.name = texttools.name_fix(args.name)

	mut pp := pathlib.get_dir(path: args.path)! // will raise error if path doesn't exist
	mut collection := Collection{
		name:          args.name
		path:          pp
		heal:          args.heal
		fail_on_error: args.fail_on_error
	}

	if args.load {
		collection.scan() or { return error('Error scanning collection ${args.name}:\n${err}') }
	}

	return collection
}
