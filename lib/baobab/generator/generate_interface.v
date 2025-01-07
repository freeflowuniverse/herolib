module generator

import freeflowuniverse.herolib.core.code { Folder, IFile, VFile, CodeItem, File, Function, Import, Module, Struct, CustomCode }

fn generate_openrpc_interface_files() (VFile, VFile) {
	iface_file := VFile {
		name: 'interface_openrpc'
		items: [CustomCode{$tmpl('./templates/interface_openrpc.v.template')}]
	}
	iface_test_file := VFile {
		name: 'interface_openrpc_test'
		items: [CustomCode{$tmpl('./templates/interface_openrpc_test.v.template')}]
	}
	return iface_file, iface_test_file
}

fn generate_openapi_interface_files() (VFile, VFile) {
	iface_file := VFile {
		name: 'interface_openapi'
		items: [CustomCode{$tmpl('./templates/interface_openapi.v.template')}]
	}
	iface_test_file := VFile {
		name: 'interface_openapi_test'
		items: [CustomCode{$tmpl('./templates/interface_openapi_test.v.template')}]
	}
	return iface_file, iface_test_file
}

fn generate_http_interface_files() (VFile, VFile) {
	iface_file := VFile {
		name: 'interface_http'
		items: [CustomCode{$tmpl('./templates/interface_http.v.template')}]
	}
	iface_test_file := VFile {
		name: 'interface_http_test'
		items: [CustomCode{$tmpl('./templates/interface_http_test.v.template')}]
	}
	return iface_file, iface_test_file
}
