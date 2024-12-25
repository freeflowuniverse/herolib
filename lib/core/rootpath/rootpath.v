module rootpath

import os

// replace ~ to home dir in string as given
pub fn shell_expansion(s_ string) string {
	mut s := s_
	home := os.real_path(os.home_dir())
	for x in ['{HOME}', '~'] {
		if s.contains(x) {
			s = s.replace(x, home)
		}
	}
	return s
}

// ensure_hero_dirs creates all necessary hero directories
pub fn ensure_hero_dirs() string {
	path_ensure(herodir())
	path_ensure(bindir())
	path_ensure(vardir())
	path_ensure(cfgdir())
	return herodir()
}


// root dir for our hero environment
pub fn herodir() string {
	return shell_expansion('~/hero')
}

// bin dir
pub fn bindir() string {
	return '${herodir()}/bin'
}

// var dir
pub fn vardir() string {
	return '${herodir()}/var'
}

// cfg dir
pub fn cfgdir() string {
	return '${herodir()}/cfg'
}

// path_ensure ensures the given path exists and returns it
pub fn path_ensure(s string) string {
	path := shell_expansion(s)
	if !os.exists(path) {
		os.mkdir_all(path) or { panic('cannot create dir ${path}') }
	}
	return path
}


// get path underneath the hero root directory
pub fn hero_path(s string) string {
	path := shell_expansion(s).trim_left(' /')
	full_path := '${herodir()}/${path}/'
	return full_path
}


// return path and ensure it exists and return the path
pub fn hero_path_ensure(s string) string {
	path := hero_path(s)
	if !os.exists(path) {
		os.mkdir_all(path) or { panic('cannot create dir ${path}') }
	}
	return path
}
