module generator

import freeflowuniverse.herolib.core.code { Folder, File  }

// generates the folder with runnable scripts of the actor
pub fn generate_scripts_folder() Folder {
	return Folder {
		name: 'scripts'
		files: [
			generate_run_actor_script(),
			generate_run_example_actor_script(),
			generate_run_http_server_script(),
			generate_compile_script(),
			generate_generate_script()
		]
	}
}

// Function to generate a script for running an actor
fn generate_run_actor_script() File {
    return File{
        name: 'run_actor'
		extension:'vsh'
        content: $tmpl('./templates/run_actor.vsh.template')
    }
}

// Function to generate a script for running an example actor
fn generate_run_example_actor_script() File {
    return File{
        name: 'run_example_actor'
		extension:'vsh'
        content: $tmpl('./templates/run_example_actor.vsh.template')
    }
}

// Function to generate a script for running an HTTP server
fn generate_run_http_server_script() File {
    return File{
        name: 'run_http_server'
		extension:'vsh'
        content: $tmpl('./templates/run_http_server.vsh.template')
    }
}

// Function to generate a script for compiling the project
fn generate_compile_script() File {
    return File{
        name: 'compile'
		extension:'sh'
        content: $tmpl('./templates/run_http_server.vsh.template')
    }
}

// Function to generate a script for general generation tasks
fn generate_generate_script() File {
    return File{
        name: 'generate'
        extension: 'vsh'
        content: $tmpl('./templates/run_http_server.vsh.template')
    }
}