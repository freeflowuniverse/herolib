#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

import os
import flag

vroot := @VROOT
abs_dir_of_script := dir(@FILE)

// Reset symlinks if requested
println('Resetting all symlinks...')
os.rmdir_all('${os.home_dir()}/.vmodules/freeflowuniverse/herolib') or {}
os.rm('${os.home_dir()}/.vmodules/freeflowuniverse/herolib') or {}
os.rmdir_all('${os.home_dir()}/.vmodules/vlang/testing') or {}

// Create necessary directories
os.mkdir_all('${os.home_dir()}/.vmodules/freeflowuniverse') or { 
    panic('Failed to create directory ~/.vmodules/freeflowuniverse: ${err}')
}

// Create new symlinks
os.symlink('${abs_dir_of_script}/herolib', '${os.home_dir()}/.vmodules/freeflowuniverse/herolib') or {
    panic('Failed to create herolib symlink: ${err}')
}

println('Herolib installation completed successfully!')
