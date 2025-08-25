module buildah

import freeflowuniverse.herolib.installers.virt.podman as podman_installer
import freeflowuniverse.herolib.installers.lang.herolib
import freeflowuniverse.herolib.core
import freeflowuniverse.herolib.builder
import freeflowuniverse.herolib.osal.core as osal
import freeflowuniverse.herolib.ui.console
import json



@[params]
pub struct BuildAHNewArgs {
pub mut:
	herocompile bool
	reset       bool
	default_image     string = 'docker.io/ubuntu:latest' 
	install     bool = true //make sure buildah is installed
	node       string //normally empty then localhost, also support root@server.example.com:22
}

//TOD: this to allow crossplatform builds
pub enum BuildPlatformType {
	linux_arm64
	linux_amd64
}


pub struct BuildAHFactory {
pub mut:
	host_node &builder.Node
	default_image string
	platform      BuildPlatformType
}


pub fn new(args BuildAHNewArgs)!BuildAHFactory {

	mut b:= builder:builder.new()!

	mut n := self.builder.node_local()!

	if self.node !=""{
		// Create a node for remote execution, need to see if this is cached on builder, otherwise will be too slow
		n = b.node_new(ipaddr: args.node)!
	}

	mut bahf := BuildAHFactory{
		host_node: n
		default_image: args.default_image
	}
	if args.reset {
		//TODO
		panic("implement")
	}
	// if args.herocompile {
	// 	bahf.builder = builder.hero_compile()!
	// }
	return bahf
}


@[params]
pub struct BuildAhContainerNewArgs {
pub mut:
	name   string = 'default'
	from   string
	delete bool   = true
}


//TODO: implement, missing parts
//TODO: need to supprot a docker builder if we are on osx or windows, so we use the builders functionality as base for executing, not directly osal
pub fn (mut self BuildAHFactory) new(args_ BuilderNewArgs) !BuildahContainer {
	mut args := args_
	if args.delete {
		self.delete(args.name)!
	}
	if args.from != "" {
		args.from = self.default_image
	}
	mut c := BuildahContainer{
		name: args.name
		from: args.from
		factory: &self
		node_host: self.host_node
	}
	return c
}



fn (mut self BuildAHFactory) list() ![]string {
	panic(implement)
	cmd := 'buildah containers --json'
	out := self.host_exec(cmd:cmd)!
	mut r := json.decode([]BuildahContainer, out) or { return error('Failed to decode JSON: ${err}') }
	for mut item in r {
		item.engine = &e
	}
	e.builders = r
}

//delete all builders
pub fn (mut self BuildAHFactory) reset() ! {
	console.print_debug('remove all')
	osal.execute_stdout('buildah rm -a')!
	self.builders_load()!
}

pub fn (mut self BuildAHFactory) delete(name string) ! {
	if self.exists(name)! {
		console.print_debug('remove ${name}')
		osal.execute_stdout('buildah rm ${name}')!
	}
}

