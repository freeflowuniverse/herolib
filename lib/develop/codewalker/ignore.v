module codewalker


const default_gitignore := '
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
.env
.venv
venv/
.tox/
.nox/
.coverage
.coveragerc
coverage.xml
*.cover
*.gem
*.pyc
.cache
.pytest_cache/
.mypy_cache/
.hypothesis/
'

//responsible to help us to find if a file matches or not
pub struct IgnoreMatcher {
pub mut:
	items map[string]Ignore //the key is the path where the gitignore plays
}

pub struct Ignore {
pub mut:
	patterns map[string]string
}


pub fn (mut self Ignore) add(content string) ! {
	for line in content.split_into_lines() {
		line = line.trim_space()
		if line.len == 0 {
			continue
		}
		self.patterns[line] = line
	}
}

pub fn (mut self Ignore) check(path string) !bool {
	return false //TODO
}



pub fn gitignore_matcher_new() !IgnoreMatcher {
	mut matcher := IgnoreMatcher{}
	gitignore.add(default_gitignore)!
	matcher.patterns['.gitignore'] = gitignore
	return matcher

}

//add content to path of gitignore
pub fn (mut self IgnoreMatcher) add(path string, content string) ! {
	self.items[path] = Ignore{}
	self.items[path].add(content)!
}



pub fn (mut self IgnoreMatcher) check(path string) !bool {
	return false //TODO here figure out which gitignores apply to the given path and check them all
}
