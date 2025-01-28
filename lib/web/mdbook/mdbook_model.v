module mdbook

import freeflowuniverse.herolib.data.paramsparser
import os

pub const version = '1.14.3'
const singleton = false
const default = true

// TODO: THIS IS EXAMPLE CODE AND NEEDS TO BE CHANGED IN LINE TO STRUCT BELOW, IS STRUCTURED AS HEROSCRIPT
pub fn heroscript_default() !string {
	heroscript := "
    !!mdbook.configure 
        name:'mdbook'
        mail_from: 'info@example.com'
        mail_password: 'secretpassword'
        mail_port: 587
        mail_server: 'smtp-relay.brevo.com'
        mail_username: 'kristof@incubaid.com'

        "

	//     mail_from := os.getenv_opt('MAIL_FROM') or {'info@example.com'}
	//     mail_password := os.getenv_opt('MAIL_PASSWORD') or {'secretpassword'}
	//     mail_port := (os.getenv_opt('MAIL_PORT') or {"587"}).int()
	//     mail_server := os.getenv_opt('MAIL_SERVER') or {'smtp-relay.brevo.com'}
	//     mail_username := os.getenv_opt('MAIL_USERNAME') or {'kristof@incubaid.com'}
	//
	//     heroscript:="
	//     !!mailclient.configure name:'default'
	//         mail_from: '${mail_from}'
	//         mail_password: '${mail_password}'
	//         mail_port: ${mail_port}
	//         mail_server: '${mail_server}'
	//         mail_username: '${mail_username}'
	//
	//     "
	//

	return heroscript
}

// THIS THE THE SOURCE OF THE INFORMATION OF THIS FILE, HERE WE HAVE THE CONFIG OBJECT CONFIGURED AND MODELLED
@[heap]
pub struct MDBooks {
pub mut:
	name         string
	path_build   string
	path_publish string
}

fn cfg_play(p paramsparser.Params) ! {
	// THIS IS EXAMPLE CODE AND NEEDS TO BE CHANGED IN LINE WITH struct above
	mut mycfg := MDBooks{
		name:         p.get_default('name', 'default')!
		path_build:   p.get_default('path_build', '${os.home_dir()}/hero/var/mdbuild')!
		path_publish: p.get_default('path_publish', '${os.home_dir()}/hero/www/info')!
	}
	set(mycfg)!
}

fn obj_init(obj_ MDBooks) !MDBooks {
	// never call get here, only thing we can do here is work on object itself
	mut obj := obj_
	return obj
}
