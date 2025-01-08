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
        version:'1.22.6'
        path: '/data/gitea'
        passwd: '12345678'
        postgresql_name: 'default'
        mail_from: 'git@meet.tf'
        smtp_addr: 'smtp-relay.brevo.com'
        smtp_login: 'admin'
        smtp_port: 587
        smtp_passwd: '12345678'
        domain: 'meet.tf'
        jwt_secret: ''
        lfs_jwt_secret: ''
        internal_token: ''
        secret_key: ''
		database_passwd: 'postgres'
		database_name: 'postgres'
		database_user: 'postgres'
		database_host: 'localhost'
		database_port: 5432 
        "

	return heroscript
}

// THIS THE THE SOURCE OF THE INFORMATION OF THIS FILE, HERE WE HAVE THE CONFIG OBJECT CONFIGURED AND MODELLED

pub struct GiteaServer {
pub mut:
	name string = 'default'

	// reset           bool
	version        string = '1.22.6'
	path           string = '/data/gitea'
	passwd         string
	mail_from      string = 'git@meet.tf'
	smtp_addr      string = 'smtp-relay.brevo.com'
	smtp_login     string @[required]
	smtp_port      int = 587
	smtp_passwd    string
	domain         string @[required]
	jwt_secret     string
	lfs_jwt_secret string
	internal_token string
	secret_key     string

	// Database config
	database_passwd string = 'postgres'
	database_name   string = 'postgres'
	database_user   string = 'postgres'
	database_host   string = 'localhost'
	database_port   int    = 5432

	process     ?zinit.ZProcess
	path_config pathlib.Path
}

fn cfg_play(p paramsparser.Params) !GiteaServer {
	// THIS IS EXAMPLE CODE AND NEEDS TO BE CHANGED IN LINE WITH struct above
	mut mycfg := GiteaServer{
		name:           p.get_default('name', 'default')!
		version:        p.get_default('version', '1.22.6')!
		path:           p.get_default('path', '/data/gitea')!
		passwd:         p.get('passwd')!
		mail_from:      p.get_default('mail_from', 'git@meet.tf')!
		smtp_addr:      p.get_default('smtp_addr', 'smtp-relay.brevo.com')!
		smtp_login:     p.get('smtp_login')!
		smtp_port:      p.get_int_default('smtp_port', 587)!
		smtp_passwd:    p.get('smtp_passwd')!
		domain:         p.get('domain')!
		jwt_secret:     p.get('jwt_secret')!
		lfs_jwt_secret: p.get('lfs_jwt_secret')!
		internal_token: p.get('internal_token')!
		secret_key:     p.get('secret_key')!

		// Set database config
		database_passwd: p.get_default('database_passwd', 'postgres')!
		database_name:   p.get_default('database_name', 'postgres')!
		database_user:   p.get_default('database_user', 'postgres')!
		database_host:   p.get_default('database_host', 'localhost')!
		database_port:   p.get_int_default('database_port', 5432)!
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
