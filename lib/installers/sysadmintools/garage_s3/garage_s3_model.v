module garage_s3

import freeflowuniverse.herolib.data.paramsparser
import os

pub const version = '1.14.3'
const singleton = false
const default = true

// TODO: THIS IS EXAMPLE CODE AND NEEDS TO BE CHANGED IN LINE TO STRUCT BELOW, IS STRUCTURED AS HEROSCRIPT
pub fn heroscript_default() !string {
	heroscript := "
    !!garage_s3.configure 
        name:'garage_s3'
        homedir: '{HOME}/hero/var/garage_s3'
        configpath: '{HOME}/.config/garage_s3/admin.yaml'
        username: 'admin'
        password: 'secretpassword'
        secret: ''
        title: 'My Hero DAG'
        host: 'localhost'
        port: 8888

        "

	return heroscript
}

// THIS THE THE SOURCE OF THE INFORMATION OF THIS FILE, HERE WE HAVE THE CONFIG OBJECT CONFIGURED AND MODELLED

pub struct GarageS3 {
pub mut:
	name string = 'default'

	replication_mode    string = '3'
	metadata_dir        string = '/var/garage/meta'
	data_dir            string = '/var/garage/data'
	sled_cache_capacity u32    = 128 // in MB
	compression_level   u8     = 1

	rpc_secret        string //{GARAGE_RPCSECRET}
	rpc_bind_addr     string = '[::]:3901'
	rpc_bind_outgoing bool
	rpc_public_addr   string = '127.0.0.1:3901'

	bootstrap_peers []string

	api_bind_addr string = '[::]:3900'
	s3_region     string = 'garage'
	root_domain   string = '.s3.garage'

	web_bind_addr   string = '[::]:3902'
	web_root_domain string = '.web.garage'

	admin_api_bind_addr string = '[::]:3903'
	admin_metrics_token string //{GARAGE_METRICSTOKEN}
	admin_token         string //{GARAGE_ADMINTOKEN}
	admin_trace_sink    string = 'http://localhost:4317'

	reset        bool
	config_reset bool
	start        bool = true
	restart      bool = true
}

fn cfg_play(p paramsparser.Params) !GarageS3 {
	mut mycfg := GarageS3{
		name:                p.get_default('name', 'default')!
		replication_mode:    p.get_default('replication_mode', '3')!
		metadata_dir:        p.get_default('metadata_dir', '/var/garage/meta')!
		data_dir:            p.get_default('data_dir', '/var/garage/data')!
		sled_cache_capacity: p.get_u32_default('sled_cache_capacity', 128)!
		compression_level:   p.get_u8_default('compression_level', 1)!
		rpc_secret:          p.get_default('rpc_secret', '')!
		rpc_bind_addr:       p.get_default('rpc_bind_addr', '[::]:3901')!
		rpc_public_addr:     p.get_default('rpc_public_addr', '127.0.0.1:3901')!
		api_bind_addr:       p.get_default('api_bind_addr', '[::]:3900')!
		s3_region:           p.get_default('s3_region', 'garage')!
		root_domain:         p.get_default('root_domain', '.s3.garage')!
		web_bind_addr:       p.get_default('web_bind_addr', '[::]:3902')!
		web_root_domain:     p.get_default('web_root_domain', '.web.garage')!
		admin_api_bind_addr: p.get_default('admin_api_bind_addr', '[::]:3903')!
		admin_metrics_token: p.get_default('admin_metrics_token', '')!
		admin_token:         p.get_default('admin_token', '')!
		admin_trace_sink:    p.get_default('admin_trace_sink', 'http://localhost:4317')!
		bootstrap_peers:     p.get_list_default('bootstrap_peers', [])!
		rpc_bind_outgoing:   p.get_default_false('rpc_bind_outgoing')
		reset:               p.get_default_false('reset')
		config_reset:        p.get_default_false('config_reset')
		start:               p.get_default_true('start')
		restart:             p.get_default_true('restart')
	}

	return mycfg
}

fn obj_init(obj_ GarageS3) !GarageS3 {
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
