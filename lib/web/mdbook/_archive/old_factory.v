// module mdbook

// import freeflowuniverse.herolib.core.base
// import os
// import crypto.md5

// @[params]
// pub struct Config {
// pub mut:
// 	path_build   string = '${os.home_dir()}/hero/var/mdbuild'
// 	path_publish string = '${os.home_dir()}/hero/www/info'
// }

// // @[heap]
// // pub struct MDBooks {
// // pub:
// // 	cfg Config
// // }

// @[params]
// pub struct InitParams{
// 	action string
// 	name string
// }

// fn (cfg MDBooks) init(args InitParams) {
// }

// pub fn get(cfg_ Config) !MDBooks {
// 	mut c := base.context()!
// 	// lets get a unique name based on the used build and publishpaths
// 	mut cfg := cfg_
// 	cfg.path_build = cfg.path_build.replace('~', os.home_dir())
// 	cfg.path_publish = cfg.path_publish.replace('~', os.home_dir())
// 	mut name := md5.hexhash('${cfg.path_build}${cfg.path_publish}')
// 	mut myparams := c.params()!
// 	mut self := MDBooks{
// 		cfg: cfg
// 	}

// 	if myparams.exists('mdbookname') {
// 		name = myparams.get('mdbookname')!
// 		self.init('mdbook', name: name, .get, cfg)!
// 	} else {
// 		self.init('mdbook', name, .set, cfg)!
// 		myparams.set('mdbookname', name)
// 	}
// 	return self
// }
