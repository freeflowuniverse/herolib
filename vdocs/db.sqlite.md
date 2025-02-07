# module db.sqlite


## Contents
- [Constants](#Constants)
- [connect](#connect)
- [connect_full](#connect_full)
- [get_default_vfs](#get_default_vfs)
- [get_vfs](#get_vfs)
- [is_error](#is_error)
- [Sqlite3_file](#Sqlite3_file)
- [Sqlite3_io_methods](#Sqlite3_io_methods)
- [Sqlite3_vfs](#Sqlite3_vfs)
  - [register_as_nondefault](#register_as_nondefault)
  - [unregister](#unregister)
- [JournalMode](#JournalMode)
- [OpenModeFlag](#OpenModeFlag)
- [Result](#Result)
  - [is_error](#is_error)
- [SyncMode](#SyncMode)
- [C.sqlite3](#C.sqlite3)
- [C.sqlite3_file](#C.sqlite3_file)
- [C.sqlite3_io_methods](#C.sqlite3_io_methods)
- [C.sqlite3_stmt](#C.sqlite3_stmt)
- [C.sqlite3_vfs](#C.sqlite3_vfs)
- [DB](#DB)
  - [busy_timeout](#busy_timeout)
  - [close](#close)
  - [create](#create)
  - [create_table](#create_table)
  - [delete](#delete)
  - [drop](#drop)
  - [error_message](#error_message)
  - [exec](#exec)
  - [exec_map](#exec_map)
  - [exec_none](#exec_none)
  - [exec_one](#exec_one)
  - [exec_param](#exec_param)
  - [exec_param_many](#exec_param_many)
  - [get_affected_rows_count](#get_affected_rows_count)
  - [insert](#insert)
  - [journal_mode](#journal_mode)
  - [last_id](#last_id)
  - [last_insert_rowid](#last_insert_rowid)
  - [q_int](#q_int)
  - [q_string](#q_string)
  - [select](#select)
  - [str](#str)
  - [synchronization_mode](#synchronization_mode)
  - [update](#update)
- [Row](#Row)
- [Stmt](#Stmt)

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

## connect
[[Return to contents]](#Contents)

## connect_full
[[Return to contents]](#Contents)

## get_default_vfs
[[Return to contents]](#Contents)

## get_vfs
[[Return to contents]](#Contents)

## is_error
[[Return to contents]](#Contents)

## Sqlite3_file
[[Return to contents]](#Contents)

## Sqlite3_io_methods
[[Return to contents]](#Contents)

## Sqlite3_vfs
[[Return to contents]](#Contents)

## register_as_nondefault
[[Return to contents]](#Contents)

## unregister
[[Return to contents]](#Contents)

## JournalMode
[[Return to contents]](#Contents)

## OpenModeFlag
[[Return to contents]](#Contents)

## Result
[[Return to contents]](#Contents)

## is_error
[[Return to contents]](#Contents)

## SyncMode
[[Return to contents]](#Contents)

## C.sqlite3
[[Return to contents]](#Contents)

## C.sqlite3_file
[[Return to contents]](#Contents)

## C.sqlite3_io_methods
[[Return to contents]](#Contents)

## C.sqlite3_stmt
[[Return to contents]](#Contents)

## C.sqlite3_vfs
[[Return to contents]](#Contents)

## DB
[[Return to contents]](#Contents)

## busy_timeout
[[Return to contents]](#Contents)

## close
[[Return to contents]](#Contents)

## create
[[Return to contents]](#Contents)

## create_table
[[Return to contents]](#Contents)

## delete
[[Return to contents]](#Contents)

## drop
[[Return to contents]](#Contents)

## error_message
[[Return to contents]](#Contents)

## exec
[[Return to contents]](#Contents)

## exec_map
[[Return to contents]](#Contents)

## exec_none
[[Return to contents]](#Contents)

## exec_one
[[Return to contents]](#Contents)

## exec_param
[[Return to contents]](#Contents)

## exec_param_many
[[Return to contents]](#Contents)

## get_affected_rows_count
[[Return to contents]](#Contents)

## insert
[[Return to contents]](#Contents)

## journal_mode
[[Return to contents]](#Contents)

## last_id
[[Return to contents]](#Contents)

## last_insert_rowid
[[Return to contents]](#Contents)

## q_int
[[Return to contents]](#Contents)

## q_string
[[Return to contents]](#Contents)

## select
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## synchronization_mode
[[Return to contents]](#Contents)

## update
[[Return to contents]](#Contents)

## Row
[[Return to contents]](#Contents)

## Stmt
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:55
