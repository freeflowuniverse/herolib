#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import os
import freeflowuniverse.herolib.core.pathlib

// Helper function to format file sizes
fn format_size(size i64) string {
    if size < 1024 {
        return '${size} B'
    } else if size < 1024 * 1024 {
        kb := f64(size) / 1024.0
        return '${kb:.1f} KB'
    } else if size < 1024 * 1024 * 1024 {
        mb := f64(size) / (1024.0 * 1024.0)
        return '${mb:.1f} MB'
    } else {
        gb := f64(size) / (1024.0 * 1024.0 * 1024.0)
        return '${gb:.1f} GB'
    }
}

// Set parameters directly in the script
// Change these values as needed
target_dir := '/tmp'  // Current directory by default
show_hidden := false  // Set to true to show hidden files
recursive := false    // Set to true for recursive listing

// Create a Path object for the target directory
mut path := pathlib.get(target_dir)

// Ensure the directory exists and is a directory
if path.exist == .no {
    eprintln('Error: Directory "${target_dir}" does not exist')
    exit(1)
}

if path.cat != .dir && path.cat != .linkdir {
    eprintln('Error: "${target_dir}" is not a directory')
    exit(1)
}

// Main execution
println('Listing contents of: ${path.absolute()}')
println('----------------------------')

// Define list arguments
mut list_args := pathlib.ListArgs{
    recursive: recursive,
    ignoredefault: !show_hidden
}

// Use pathlib to list the directory contents
mut list_result := path.list(list_args) or {
    eprintln('Error listing directory: ${err}')
    exit(1)
}

// Print each file/directory
for p in list_result.paths {
    // Skip the root directory itself
    if p.path == path.path {
        continue
    }
    
    // Calculate the level based on the path depth relative to the root
    rel_path := p.path.replace(list_result.root, '')
    level := rel_path.count('/') - if rel_path.starts_with('/') { 1 } else { 0 }
    
    // Print indentation based on level
    if level > 0 {
        print('  '.repeat(level))
    }
    
    // Print file/directory info
    name := p.name()
    if p.cat == .dir || p.cat == .linkdir {
        println('📁 ${name}/')
    } else {
        // Get file size
        file_size := os.file_size(p.path)
        println('📄 ${name} (${format_size(file_size)})')
    }
}

println('----------------------------')
println('Done!')
