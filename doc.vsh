#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

import os

abs_dir_of_script := dir(@FILE)

// Format code
println('Formatting code...')
if os.system('v fmt -w ${abs_dir_of_script}/examples') != 0 {
    eprintln('Warning: Failed to format examples')
}

if os.system('v fmt -w ${abs_dir_of_script}/lib') != 0 {
    eprintln('Warning: Failed to format herolib')
}

// Clean existing docs
println('Cleaning existing documentation...')

os.rmdir_all('_docs') or {}
os.rmdir_all('docs') or {}
os.rmdir_all('vdocs') or {}

herolib_path := os.join_path(abs_dir_of_script, 'lib')
os.chdir(herolib_path) or {
    panic('Failed to change directory to herolib: ${err}')
}

os.rmdir_all('_docs') or {}
os.rmdir_all('docs') or {}
os.rmdir_all('vdocs') or {}

// Generate HTML documentation
println('Generating HTML documentation...')
if os.system('v doc -m -f html . -readme -comments -no-timestamp -o ../docs') != 0 {
    panic('Failed to generate HTML documentation')
}

os.chdir(abs_dir_of_script) or {
    panic('Failed to change directory to abs_dir_of_script: ${err}')
}

// Generate Markdown documentation
println('Generating Markdown documentation...')
os.rmdir_all('vdocs') or {}

// if os.system('v doc -m -no-color -f md -o ../vdocs/v/') != 0 {
//     panic('Failed to generate V markdown documentation')
// }

if os.system('v doc -m -no-color -f md -o vdocs/herolib/') != 0 {
    panic('Failed to generate Hero markdown documentation')
}

// Open documentation in browser on non-Linux systems
$if !linux {
    os.chdir(abs_dir_of_script) or {
        panic('Failed to change directory: ${err}')
    }
    if os.system('open docs/index.html') != 0 {
        eprintln('Warning: Failed to open documentation in browser')
    }
}

println('Documentation generation completed successfully!')
