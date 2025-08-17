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

	if args.content {
		cw.filemap.content = args.content
		
	}else{
		cw.walk()!
	}

	// Load default gitignore patterns
	cw.gitignore_patterns = cw.default_gitignore()
	return cw
}
