module generator

import freeflowuniverse.herolib.core.code { Folder, IFile, VFile, CodeItem, File, Function, Import, Module, Struct, CustomCode }
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.schemas.openrpc
import freeflowuniverse.herolib.baobab.specification {ActorMethod, ActorSpecification}
import os
import json

fn generate_openrpc_interface_file() !VFile {
	return VFile {
		name: 'interface_openrpc'
		items: [CustomCode{$tmpl('./templates/interface_openrpc.v.template')}]
	}
}

fn generate_http_interface_file() !VFile {
	return VFile {
		name: 'interface_http'
		items: [CustomCode{$tmpl('./templates/interface_http.v.template')}]
	}
}
