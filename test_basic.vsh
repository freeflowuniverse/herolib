#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

import os
import flag
import net
import time


// Check if Redis is available
fn check_redis() bool {
    mut redis_available := false
    mut sock := net.dial_tcp('127.0.0.1:6379') or { return false }
    sock.close() or {}
    return true
}

// Set Redis key with expiration
fn redis_set(key string) ! {
    mut sock := net.dial_tcp('127.0.0.1:6379')!
    defer { sock.close() or {} }
    
    // SET key value EX seconds
    cmd := 'SET vtests.${key} 1 EX 3600\r\n' 
    sock.write_string(cmd)!
}

// Check if key exists in Redis
fn redis_exists(key string) bool {
    mut sock := net.dial_tcp('127.0.0.1:6379') or { return false }
    defer { sock.close() or {} }
    
    // EXISTS key
    cmd := 'EXISTS vtests.${key}\r\n'
    sock.write_string(cmd) or { return false }
    
    response := sock.read_line() 
    return response.trim_space() == ':1'
}

// Delete Redis key
fn redis_del(key string) ! {
    mut sock := net.dial_tcp('127.0.0.1:6379')!
    defer { sock.close() or {} }
    
    // DEL key
    cmd := 'DEL vtests.${key}\r\n'
    sock.write_string(cmd)!
}

// Check if a file should be ignored or marked as error based on its path
fn process_test_file(path string, test_files_ignore []string, test_files_error []string, redis_available bool, mut tests_in_error []string)! {
    // Get relative path for more accurate pattern matching
    rel_path := path.replace(os.abs_path('.') + '/', '')
    
    mut should_ignore := false
    mut is_error := false
    
    // Check if any ignore pattern matches the path
    for pattern in test_files_ignore {
        if pattern.trim_space() != '' && rel_path.contains(pattern) {
            should_ignore = true
            break
        }
    }
    
    // Check if any error pattern matches the path
    for pattern in test_files_error {
        if pattern.trim_space() != '' && rel_path.contains(pattern) {
            is_error = true
            break
        }
    }
    
    if !should_ignore && !is_error {
        dotest(path, redis_available)!
    } else {
        println('Ignoring test: ${rel_path}')
        if !should_ignore {
            tests_in_error << rel_path
        }
    }
}

fn dotest(path string, use_redis bool)! {
    if use_redis {
        // Use absolute path as Redis key
        abs_path := os.abs_path(path)
        redis_key := abs_path.replace('/', '_')
        
        // Check if test result is cached
        if redis_exists(redis_key) {
            println('Test cached (passed): ${path}')
            return
        }
    }

    cmd := 'vtest ${path}'
    println(cmd)
    result := os.execute(cmd)
    
    if result.exit_code != 0 {
        eprintln('Test failed: ${path}')
        eprintln(result.output)
        exit(1)
    }
    
    if use_redis {
        // Cache successful test result
        abs_path := os.abs_path(path)
        redis_key := abs_path.replace('/', '_')
        redis_set(redis_key) or {
            eprintln('Failed to cache test result: ${err}')
        }
    }
    
    println('Test passed: ${path}')
}


/////////////////////////
/////////////////////////


abs_dir_of_script := dir(@FILE)
os.chdir(abs_dir_of_script) or { panic(err) }

tests := "
lib/osal
lib/lang
lib/data
lib/code
lib/clients
"

tests_ignore := "

"

tests_error := "
net_test.v
systemd_process_test.v
rpc_test.v
screen_test.v
tmux_session_test.v
tmux_window_test.v
tmux_test.v
startupmanager_test.v
python_test.v
flist_test.v
mnemonic_test.v
decode_test.v
codegen_test.v
generate_test.v
dbfs_test.v
namedb_test.v
timetools_test.v
markdownparser/link_test.v
markdownparser/link_def_test.v
markdownparser/char_parser_test.v
markdownparser/action_test.v
markdownparser/elements/char_parser_test.v
markdownparser/markdown_test.v
markdownparser/list_test.v
markdownparser/table_test.v
ourdb/lookup_test.v
ourdb/lookup_id_test.v
ourdb/db_test.v
ourdb/lookup_location_test.v
encoderhero/encoder_test.v
encoderhero/decoder_test.v
"


// Split tests into array and remove empty lines
test_files := tests.split('\n').filter(it.trim_space() != '')
test_files_ignore := tests_ignore.split('\n').filter(it.trim_space() != '')
test_files_error := tests_error.split('\n').filter(it.trim_space() != '')

mut tests_in_error := []string{}


// Check if Redis is available
redis_available := check_redis()
if redis_available {
    println('Redis cache enabled')
} else {
    println('Redis not available, running without cache')
}

// Run each test with proper v command flags
for test in test_files {
    if test.trim_space() == '' {
        continue
    }
    
    full_path := os.join_path(abs_dir_of_script, test)
    
    if !os.exists(full_path) {
        eprintln('Path does not exist: ${full_path}')
        exit(1)
    }
    
    if os.is_dir(full_path) {
        // If directory, run tests for each .v file in it recursively
        files := os.walk_ext(full_path, '.v')
        for file in files {
            process_test_file(file, test_files_ignore, test_files_error, redis_available, mut tests_in_error)!
        }
    } else if os.is_file(full_path) {
        process_test_file(full_path, test_files_ignore, test_files_error, redis_available, mut tests_in_error)!
    }
}

println('All (non skipped) tests ok')

if tests_in_error.len > 0 {
    println('\n\033[31mTests that need to be fixed (not executed):')
    for test in tests_in_error {
        println('  ${test}')
    }
    println('\033[0m')
}
