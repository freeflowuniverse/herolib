# module os


## Contents
- [Constants](#Constants)
- [abs_path](#abs_path)
- [args_after](#args_after)
- [args_before](#args_before)
- [base](#base)
- [cache_dir](#cache_dir)
- [chdir](#chdir)
- [chmod](#chmod)
- [chown](#chown)
- [config_dir](#config_dir)
- [cp](#cp)
- [cp_all](#cp_all)
- [create](#create)
- [data_dir](#data_dir)
- [debugger_present](#debugger_present)
- [dir](#dir)
- [disk_usage](#disk_usage)
- [ensure_folder_is_writable](#ensure_folder_is_writable)
- [environ](#environ)
- [error_posix](#error_posix)
- [error_win32](#error_win32)
- [executable](#executable)
- [execute](#execute)
- [execute_opt](#execute_opt)
- [execute_or_exit](#execute_or_exit)
- [execute_or_panic](#execute_or_panic)
- [execve](#execve)
- [execvp](#execvp)
- [existing_path](#existing_path)
- [exists](#exists)
- [exists_in_system_path](#exists_in_system_path)
- [expand_tilde_to_home](#expand_tilde_to_home)
- [fd_close](#fd_close)
- [fd_is_pending](#fd_is_pending)
- [fd_read](#fd_read)
- [fd_slurp](#fd_slurp)
- [fd_write](#fd_write)
- [file_ext](#file_ext)
- [file_last_mod_unix](#file_last_mod_unix)
- [file_name](#file_name)
- [file_size](#file_size)
- [fileno](#fileno)
- [find_abs_path_of_executable](#find_abs_path_of_executable)
- [flush](#flush)
- [fork](#fork)
- [from_slash](#from_slash)
- [get_error_msg](#get_error_msg)
- [get_line](#get_line)
- [get_lines](#get_lines)
- [get_lines_joined](#get_lines_joined)
- [get_raw_line](#get_raw_line)
- [get_raw_lines](#get_raw_lines)
- [get_raw_lines_joined](#get_raw_lines_joined)
- [get_raw_stdin](#get_raw_stdin)
- [get_trimmed_lines](#get_trimmed_lines)
- [getegid](#getegid)
- [getenv](#getenv)
- [getenv_opt](#getenv_opt)
- [geteuid](#geteuid)
- [getgid](#getgid)
- [getpid](#getpid)
- [getppid](#getppid)
- [getuid](#getuid)
- [getwd](#getwd)
- [glob](#glob)
- [home_dir](#home_dir)
- [hostname](#hostname)
- [inode](#inode)
- [input](#input)
- [input_opt](#input_opt)
- [input_password](#input_password)
- [is_abs_path](#is_abs_path)
- [is_atty](#is_atty)
- [is_dir](#is_dir)
- [is_dir_empty](#is_dir_empty)
- [is_executable](#is_executable)
- [is_file](#is_file)
- [is_link](#is_link)
- [is_main_thread](#is_main_thread)
- [is_readable](#is_readable)
- [is_writable](#is_writable)
- [join_path](#join_path)
- [join_path_single](#join_path_single)
- [last_error](#last_error)
- [link](#link)
- [local_bin_dir](#local_bin_dir)
- [log](#log)
- [loginname](#loginname)
- [ls](#ls)
- [lstat](#lstat)
- [mkdir](#mkdir)
- [mkdir_all](#mkdir_all)
- [mv](#mv)
- [mv_by_cp](#mv_by_cp)
- [new_process](#new_process)
- [norm_path](#norm_path)
- [open](#open)
- [open_append](#open_append)
- [open_file](#open_file)
- [open_uri](#open_uri)
- [page_size](#page_size)
- [posix_get_error_msg](#posix_get_error_msg)
- [posix_set_permission_bit](#posix_set_permission_bit)
- [quoted_path](#quoted_path)
- [raw_execute](#raw_execute)
- [read_bytes](#read_bytes)
- [read_file](#read_file)
- [read_file_array](#read_file_array)
- [read_lines](#read_lines)
- [real_path](#real_path)
- [rename](#rename)
- [rename_dir](#rename_dir)
- [resource_abs_path](#resource_abs_path)
- [rm](#rm)
- [rmdir](#rmdir)
- [rmdir_all](#rmdir_all)
- [setenv](#setenv)
- [sigint_to_signal_name](#sigint_to_signal_name)
- [signal_ignore](#signal_ignore)
- [signal_opt](#signal_opt)
- [split_path](#split_path)
- [stat](#stat)
- [state_dir](#state_dir)
- [stderr](#stderr)
- [stdin](#stdin)
- [stdout](#stdout)
- [symlink](#symlink)
- [system](#system)
- [temp_dir](#temp_dir)
- [to_slash](#to_slash)
- [truncate](#truncate)
- [uname](#uname)
- [unsetenv](#unsetenv)
- [user_names](#user_names)
- [user_os](#user_os)
- [utime](#utime)
- [vfopen](#vfopen)
- [vmodules_dir](#vmodules_dir)
- [vmodules_paths](#vmodules_paths)
- [vtmp_dir](#vtmp_dir)
- [wait](#wait)
- [walk](#walk)
- [walk_ext](#walk_ext)
- [walk_with_context](#walk_with_context)
- [write_file](#write_file)
- [write_file_array](#write_file_array)
- [write_lines](#write_lines)
- [FN_SA_Handler](#FN_SA_Handler)
- [FnWalkContextCB](#FnWalkContextCB)
- [SignalHandler](#SignalHandler)
- [ChildProcessPipeKind](#ChildProcessPipeKind)
- [FileBufferMode](#FileBufferMode)
- [FileType](#FileType)
- [ProcessState](#ProcessState)
- [SeekMode](#SeekMode)
- [Signal](#Signal)
- [C.__stat64](#C.__stat64)
- [C.dirent](#C.dirent)
- [C.fd_set](#C.fd_set)
- [C.sigaction](#C.sigaction)
- [C.stat](#C.stat)
- [C.timespec](#C.timespec)
- [C.timeval](#C.timeval)
- [C.utimbuf](#C.utimbuf)
- [C.utsname](#C.utsname)
- [Command](#Command)
  - [close](#close)
  - [read_line](#read_line)
  - [start](#start)
- [DiskUsage](#DiskUsage)
- [Eof](#Eof)
- [ExecutableNotFoundError](#ExecutableNotFoundError)
  - [msg](#msg)
- [File](#File)
  - [close](#close)
  - [eof](#eof)
  - [flush](#flush)
  - [read](#read)
  - [read_be](#read_be)
  - [read_bytes](#read_bytes)
  - [read_bytes_at](#read_bytes_at)
  - [read_bytes_into](#read_bytes_into)
  - [read_bytes_with_newline](#read_bytes_with_newline)
  - [read_from](#read_from)
  - [read_into_ptr](#read_into_ptr)
  - [read_le](#read_le)
  - [read_raw](#read_raw)
  - [read_raw_at](#read_raw_at)
  - [read_struct](#read_struct)
  - [read_struct_at](#read_struct_at)
  - [reopen](#reopen)
  - [seek](#seek)
  - [set_buffer](#set_buffer)
  - [set_line_buffered](#set_line_buffered)
  - [set_unbuffered](#set_unbuffered)
  - [setvbuf](#setvbuf)
  - [tell](#tell)
  - [write](#write)
  - [write_be](#write_be)
  - [write_full_buffer](#write_full_buffer)
  - [write_le](#write_le)
  - [write_ptr](#write_ptr)
  - [write_ptr_at](#write_ptr_at)
  - [write_raw](#write_raw)
  - [write_raw_at](#write_raw_at)
  - [write_string](#write_string)
  - [write_struct](#write_struct)
  - [write_struct_at](#write_struct_at)
  - [write_to](#write_to)
  - [writeln](#writeln)
- [FileInfo](#FileInfo)
- [FileMode](#FileMode)
  - [bitmask](#bitmask)
- [FileNotOpenedError](#FileNotOpenedError)
  - [msg](#msg)
- [FilePermission](#FilePermission)
  - [bitmask](#bitmask)
- [MkdirParams](#MkdirParams)
- [MvParams](#MvParams)
- [NotExpected](#NotExpected)
- [Process](#Process)
  - [close](#close)
  - [free](#free)
  - [is_alive](#is_alive)
  - [is_pending](#is_pending)
  - [pipe_read](#pipe_read)
  - [run](#run)
  - [set_args](#set_args)
  - [set_environment](#set_environment)
  - [set_redirect_stdio](#set_redirect_stdio)
  - [set_work_folder](#set_work_folder)
  - [signal_continue](#signal_continue)
  - [signal_kill](#signal_kill)
  - [signal_pgkill](#signal_pgkill)
  - [signal_stop](#signal_stop)
  - [signal_term](#signal_term)
  - [stderr_read](#stderr_read)
  - [stderr_slurp](#stderr_slurp)
  - [stdin_write](#stdin_write)
  - [stdout_read](#stdout_read)
  - [stdout_slurp](#stdout_slurp)
  - [wait](#wait)
- [Result](#Result)
  - [free](#free)
- [SizeOfTypeIs0Error](#SizeOfTypeIs0Error)
  - [msg](#msg)
- [Stat](#Stat)
  - [get_filetype](#get_filetype)
  - [get_mode](#get_mode)
- [SystemError](#SystemError)
- [Uname](#Uname)

## Constants
[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

## abs_path
[[Return to contents]](#Contents)

## args_after
[[Return to contents]](#Contents)

## args_before
[[Return to contents]](#Contents)

## base
[[Return to contents]](#Contents)

## cache_dir
[[Return to contents]](#Contents)

## chdir
[[Return to contents]](#Contents)

## chmod
[[Return to contents]](#Contents)

## chown
[[Return to contents]](#Contents)

## config_dir
[[Return to contents]](#Contents)

## cp
[[Return to contents]](#Contents)

## cp_all
[[Return to contents]](#Contents)

## create
[[Return to contents]](#Contents)

## data_dir
[[Return to contents]](#Contents)

## debugger_present
[[Return to contents]](#Contents)

## dir
[[Return to contents]](#Contents)

## disk_usage
[[Return to contents]](#Contents)

## ensure_folder_is_writable
[[Return to contents]](#Contents)

## environ
[[Return to contents]](#Contents)

## error_posix
[[Return to contents]](#Contents)

## error_win32
[[Return to contents]](#Contents)

## executable
[[Return to contents]](#Contents)

## execute
[[Return to contents]](#Contents)

## execute_opt
[[Return to contents]](#Contents)

## execute_or_exit
[[Return to contents]](#Contents)

## execute_or_panic
[[Return to contents]](#Contents)

## execve
[[Return to contents]](#Contents)

## execvp
[[Return to contents]](#Contents)

## existing_path
[[Return to contents]](#Contents)

## exists
[[Return to contents]](#Contents)

## exists_in_system_path
[[Return to contents]](#Contents)

## expand_tilde_to_home
[[Return to contents]](#Contents)

## fd_close
[[Return to contents]](#Contents)

## fd_is_pending
[[Return to contents]](#Contents)

## fd_read
[[Return to contents]](#Contents)

## fd_slurp
[[Return to contents]](#Contents)

## fd_write
[[Return to contents]](#Contents)

## file_ext
[[Return to contents]](#Contents)

## file_last_mod_unix
[[Return to contents]](#Contents)

## file_name
[[Return to contents]](#Contents)

## file_size
[[Return to contents]](#Contents)

## fileno
[[Return to contents]](#Contents)

## find_abs_path_of_executable
[[Return to contents]](#Contents)

## flush
[[Return to contents]](#Contents)

## fork
[[Return to contents]](#Contents)

## from_slash
[[Return to contents]](#Contents)

## get_error_msg
[[Return to contents]](#Contents)

## get_line
[[Return to contents]](#Contents)

## get_lines
[[Return to contents]](#Contents)

## get_lines_joined
[[Return to contents]](#Contents)

## get_raw_line
[[Return to contents]](#Contents)

## get_raw_lines
[[Return to contents]](#Contents)

## get_raw_lines_joined
[[Return to contents]](#Contents)

## get_raw_stdin
[[Return to contents]](#Contents)

## get_trimmed_lines
[[Return to contents]](#Contents)

## getegid
[[Return to contents]](#Contents)

## getenv
[[Return to contents]](#Contents)

## getenv_opt
[[Return to contents]](#Contents)

## geteuid
[[Return to contents]](#Contents)

## getgid
[[Return to contents]](#Contents)

## getpid
[[Return to contents]](#Contents)

## getppid
[[Return to contents]](#Contents)

## getuid
[[Return to contents]](#Contents)

## getwd
[[Return to contents]](#Contents)

## glob
[[Return to contents]](#Contents)

## home_dir
[[Return to contents]](#Contents)

## hostname
[[Return to contents]](#Contents)

## inode
[[Return to contents]](#Contents)

## input
[[Return to contents]](#Contents)

## input_opt
[[Return to contents]](#Contents)

## input_password
[[Return to contents]](#Contents)

## is_abs_path
[[Return to contents]](#Contents)

## is_atty
[[Return to contents]](#Contents)

## is_dir
[[Return to contents]](#Contents)

## is_dir_empty
[[Return to contents]](#Contents)

## is_executable
[[Return to contents]](#Contents)

## is_file
[[Return to contents]](#Contents)

## is_link
[[Return to contents]](#Contents)

## is_main_thread
[[Return to contents]](#Contents)

## is_readable
[[Return to contents]](#Contents)

## is_writable
[[Return to contents]](#Contents)

## join_path
[[Return to contents]](#Contents)

## join_path_single
[[Return to contents]](#Contents)

## last_error
[[Return to contents]](#Contents)

## link
[[Return to contents]](#Contents)

## local_bin_dir
[[Return to contents]](#Contents)

## log
[[Return to contents]](#Contents)

## loginname
[[Return to contents]](#Contents)

## ls
Example
```v

https://github.com/vlang/v/blob/master/examples/readdir.v

```

[[Return to contents]](#Contents)

## lstat
[[Return to contents]](#Contents)

## mkdir
[[Return to contents]](#Contents)

## mkdir_all
[[Return to contents]](#Contents)

## mv
[[Return to contents]](#Contents)

## mv_by_cp
[[Return to contents]](#Contents)

## new_process
[[Return to contents]](#Contents)

## norm_path
[[Return to contents]](#Contents)

## open
[[Return to contents]](#Contents)

## open_append
[[Return to contents]](#Contents)

## open_file
[[Return to contents]](#Contents)

## open_uri
[[Return to contents]](#Contents)

## page_size
[[Return to contents]](#Contents)

## posix_get_error_msg
[[Return to contents]](#Contents)

## posix_set_permission_bit
[[Return to contents]](#Contents)

## quoted_path
[[Return to contents]](#Contents)

## raw_execute
[[Return to contents]](#Contents)

## read_bytes
[[Return to contents]](#Contents)

## read_file
[[Return to contents]](#Contents)

## read_file_array
[[Return to contents]](#Contents)

## read_lines
[[Return to contents]](#Contents)

## real_path
[[Return to contents]](#Contents)

## rename
[[Return to contents]](#Contents)

## rename_dir
[[Return to contents]](#Contents)

## resource_abs_path
[[Return to contents]](#Contents)

## rm
[[Return to contents]](#Contents)

## rmdir
[[Return to contents]](#Contents)

## rmdir_all
[[Return to contents]](#Contents)

## setenv
[[Return to contents]](#Contents)

## sigint_to_signal_name
[[Return to contents]](#Contents)

## signal_ignore
[[Return to contents]](#Contents)

## signal_opt
[[Return to contents]](#Contents)

## split_path
[[Return to contents]](#Contents)

## stat
[[Return to contents]](#Contents)

## state_dir
[[Return to contents]](#Contents)

## stderr
[[Return to contents]](#Contents)

## stdin
[[Return to contents]](#Contents)

## stdout
[[Return to contents]](#Contents)

## symlink
[[Return to contents]](#Contents)

## system
[[Return to contents]](#Contents)

## temp_dir
[[Return to contents]](#Contents)

## to_slash
[[Return to contents]](#Contents)

## truncate
[[Return to contents]](#Contents)

## uname
[[Return to contents]](#Contents)

## unsetenv
[[Return to contents]](#Contents)

## user_names
[[Return to contents]](#Contents)

## user_os
[[Return to contents]](#Contents)

## utime
[[Return to contents]](#Contents)

## vfopen
[[Return to contents]](#Contents)

## vmodules_dir
[[Return to contents]](#Contents)

## vmodules_paths
[[Return to contents]](#Contents)

## vtmp_dir
[[Return to contents]](#Contents)

## wait
[[Return to contents]](#Contents)

## walk
[[Return to contents]](#Contents)

## walk_ext
[[Return to contents]](#Contents)

## walk_with_context
[[Return to contents]](#Contents)

## write_file
[[Return to contents]](#Contents)

## write_file_array
[[Return to contents]](#Contents)

## write_lines
[[Return to contents]](#Contents)

## FN_SA_Handler
[[Return to contents]](#Contents)

## FnWalkContextCB
[[Return to contents]](#Contents)

## SignalHandler
[[Return to contents]](#Contents)

## ChildProcessPipeKind
[[Return to contents]](#Contents)

## FileBufferMode
[[Return to contents]](#Contents)

## FileType
[[Return to contents]](#Contents)

## ProcessState
[[Return to contents]](#Contents)

## SeekMode
[[Return to contents]](#Contents)

## Signal
[[Return to contents]](#Contents)

## C.__stat64
[[Return to contents]](#Contents)

## C.dirent
[[Return to contents]](#Contents)

## C.fd_set
[[Return to contents]](#Contents)

## C.sigaction
[[Return to contents]](#Contents)

## C.stat
[[Return to contents]](#Contents)

## C.timespec
[[Return to contents]](#Contents)

## C.timeval
[[Return to contents]](#Contents)

## C.utimbuf
[[Return to contents]](#Contents)

## C.utsname
[[Return to contents]](#Contents)

## Command
[[Return to contents]](#Contents)

## close
[[Return to contents]](#Contents)

## read_line
[[Return to contents]](#Contents)

## start
[[Return to contents]](#Contents)

## DiskUsage
[[Return to contents]](#Contents)

## Eof
[[Return to contents]](#Contents)

## ExecutableNotFoundError
[[Return to contents]](#Contents)

## msg
[[Return to contents]](#Contents)

## File
[[Return to contents]](#Contents)

## close
[[Return to contents]](#Contents)

## eof
[[Return to contents]](#Contents)

## flush
[[Return to contents]](#Contents)

## read
[[Return to contents]](#Contents)

## read_be
[[Return to contents]](#Contents)

## read_bytes
[[Return to contents]](#Contents)

## read_bytes_at
[[Return to contents]](#Contents)

## read_bytes_into
[[Return to contents]](#Contents)

## read_bytes_with_newline
[[Return to contents]](#Contents)

## read_from
[[Return to contents]](#Contents)

## read_into_ptr
[[Return to contents]](#Contents)

## read_le
[[Return to contents]](#Contents)

## read_raw
[[Return to contents]](#Contents)

## read_raw_at
[[Return to contents]](#Contents)

## read_struct
[[Return to contents]](#Contents)

## read_struct_at
[[Return to contents]](#Contents)

## reopen
[[Return to contents]](#Contents)

## seek
[[Return to contents]](#Contents)

## set_buffer
[[Return to contents]](#Contents)

## set_line_buffered
[[Return to contents]](#Contents)

## set_unbuffered
[[Return to contents]](#Contents)

## setvbuf
[[Return to contents]](#Contents)

## tell
[[Return to contents]](#Contents)

## write
[[Return to contents]](#Contents)

## write_be
[[Return to contents]](#Contents)

## write_full_buffer
[[Return to contents]](#Contents)

## write_le
[[Return to contents]](#Contents)

## write_ptr
[[Return to contents]](#Contents)

## write_ptr_at
[[Return to contents]](#Contents)

## write_raw
[[Return to contents]](#Contents)

## write_raw_at
[[Return to contents]](#Contents)

## write_string
[[Return to contents]](#Contents)

## write_struct
[[Return to contents]](#Contents)

## write_struct_at
[[Return to contents]](#Contents)

## write_to
[[Return to contents]](#Contents)

## writeln
[[Return to contents]](#Contents)

## FileInfo
[[Return to contents]](#Contents)

## FileMode
[[Return to contents]](#Contents)

## bitmask
[[Return to contents]](#Contents)

## FileNotOpenedError
[[Return to contents]](#Contents)

## msg
[[Return to contents]](#Contents)

## FilePermission
[[Return to contents]](#Contents)

## bitmask
[[Return to contents]](#Contents)

## MkdirParams
[[Return to contents]](#Contents)

## MvParams
[[Return to contents]](#Contents)

## NotExpected
[[Return to contents]](#Contents)

## Process
[[Return to contents]](#Contents)

## close
[[Return to contents]](#Contents)

## free
[[Return to contents]](#Contents)

## is_alive
[[Return to contents]](#Contents)

## is_pending
[[Return to contents]](#Contents)

## pipe_read
[[Return to contents]](#Contents)

## run
[[Return to contents]](#Contents)

## set_args
[[Return to contents]](#Contents)

## set_environment
[[Return to contents]](#Contents)

## set_redirect_stdio
[[Return to contents]](#Contents)

## set_work_folder
[[Return to contents]](#Contents)

## signal_continue
[[Return to contents]](#Contents)

## signal_kill
[[Return to contents]](#Contents)

## signal_pgkill
[[Return to contents]](#Contents)

## signal_stop
[[Return to contents]](#Contents)

## signal_term
[[Return to contents]](#Contents)

## stderr_read
[[Return to contents]](#Contents)

## stderr_slurp
[[Return to contents]](#Contents)

## stdin_write
[[Return to contents]](#Contents)

## stdout_read
[[Return to contents]](#Contents)

## stdout_slurp
[[Return to contents]](#Contents)

## wait
[[Return to contents]](#Contents)

## Result
[[Return to contents]](#Contents)

## free
[[Return to contents]](#Contents)

## SizeOfTypeIs0Error
[[Return to contents]](#Contents)

## msg
[[Return to contents]](#Contents)

## Stat
[[Return to contents]](#Contents)

## get_filetype
[[Return to contents]](#Contents)

## get_mode
[[Return to contents]](#Contents)

## SystemError
[[Return to contents]](#Contents)

## Uname
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:55
