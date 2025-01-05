module gitea

import freeflowuniverse.herolib.data.paramsparser
import freeflowuniverse.herolib.osal.zinit
import freeflowuniverse.herolib.core.pathlib

const singleton = true
const default = false

// TODO: THIS IS EXAMPLE CODE AND NEEDS TO BE CHANGED IN LINE TO STRUCT BELOW, IS STRUCTURED AS HEROSCRIPT
pub fn heroscript_default() !string {
	heroscript := "
    !!gitea.configure 
        name:'gitea'
        path: '/data/gitea'
        passwd: '12345678'
        postgresql_name: 'default'
        mail_from: 'git@meet.tf'
        smtp_addr: 'smtp-relay.brevo.com'
        smtp_login: 'admin'
        smpt_port: 587
        smtp_passwd: '12345678'
        domain: 'meet.tf'
        jwt_secret: ''
        lfs_jwt_secret: ''
        internal_token: ''
        secret_key: ''
        "

	return heroscript
}

// THIS THE THE SOURCE OF THE INFORMATION OF THIS FILE, HERE WE HAVE THE CONFIG OBJECT CONFIGURED AND MODELLED

pub struct GiteaServer {
pub mut:
	name string = 'default'

	// reset           bool
	version         string = '1.22.4'
	path            string = '/data/gitea'
	passwd          string
	postgresql_name string = 'default'
	mail_from       string = 'git@meet.tf'
	smtp_addr       string = 'smtp-relay.brevo.com'
	smtp_login      string @[required]
	smtp_port       int = 587
	smtp_passwd     string
	domain          string @[required]
	jwt_secret      string
	lfs_jwt_secret  string
	internal_token  string
	secret_key      string

	process     ?zinit.ZProcess
	path_config pathlib.Path
}

fn cfg_play(p paramsparser.Params) !GiteaServer {
	// THIS IS EXAMPLE CODE AND NEEDS TO BE CHANGED IN LINE WITH struct above
	mut mycfg := GiteaServer{
		name:            p.get_default('name', 'default')!
		path:            p.get_default('path', '/data/gitea')!
		passwd:          p.get('passwd')!
		postgresql_name: p.get_default('postgresql_name', 'default')!
		mail_from:       p.get_default('mail_from', 'git@meet.tf')!
		smtp_addr:       p.get_default('smtp_addr', 'smtp-relay.brevo.com')!
		smtp_login:      p.get('smtp_login')!
		smpt_port:       p.get_int_default('smpt_port', 587)!
		smtp_passwd:     p.get('smtp_passwd')!
		domain:          p.get('domain')!
		jwt_secret:      p.get('jwt_secret')!
		lfs_jwt_secret:  p.get('lfs_jwt_secret')!
		internal_token:  p.get('internal_token')!
		secret_key:      p.get('secret_key')!
	}

	return mycfg
}

fn obj_init(obj_ GiteaServer) !GiteaServer {
	// never call get here, only thing we can do here is work on object itself
	mut obj := obj_
	return obj
}

// called before start if done
fn configure() ! {
	// mut installer := get()!

	// mut mycode := $tmpl('templates/atemplate.yaml')
	// mut path := pathlib.get_file(path: cfg.configpath, create: true)!
	// path.write(mycode)!
	// console.print_debug(mycode)
}
