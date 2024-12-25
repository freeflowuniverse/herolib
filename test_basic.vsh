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
    cmd := 'SET vtests.${key} 1 EX 600\r\n'  // 600 seconds = 10 minutes
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
"

tests_ignore := "
net_test.v
systemd_process_test.v
rpc_test.v
screen_test.v
tmux_session_test.v
tmux_window_test.v
tmux_test.v
startupmanager_test.v
"

// Split tests into array and remove empty lines
test_files := tests.split('\n').filter(it.trim_space() != '')
test_files_ignore := tests_ignore.split('\n').filter(it.trim_space() != '')

mut ignored_tests := []string{}


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
        // If directory, run tests for each .v file in it
        files := os.walk_ext(full_path, '.v')
        for file in files {
            base_file := os.base(file)
            if base_file in test_files_ignore {
                println('Ignoring test: ${file}')
                ignored_tests << file
                continue
            }
            dotest(file, redis_available)!
        }
    } else if os.is_file(full_path) {
        // If single file, run test if not in ignore list
        base_file := os.base(full_path)
        if base_file !in test_files_ignore {
            dotest(full_path, redis_available)!
        } else {
            println('Ignoring test: ${full_path}')
            ignored_tests << full_path
        }
    }
}

println('All (non skipped) tests ok')

if ignored_tests.len > 0 {
    println('\n\033[31mTests that need to be fixed (not executed):')
    for test in ignored_tests {
        println('  ${test}')
    }
    println('\033[0m')
}
