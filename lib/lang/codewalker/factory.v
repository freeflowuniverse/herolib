module codewalker


@[params]
pub struct CodeWalkerArgs {
	source string
	content string
}

pub fn new(args CodeWalkerArgs) !CodeWalker {
	mut cw := CodeWalker{
		source: args.source
	}

	// Load default gitignore patterns
	cw.gitignore_patterns = cw.default_gitignore()
	
	return cw
}
