# module db.mysql


## Contents
- [Constants](#Constants)
- [connect](#connect)
- [debug](#debug)
- [get_client_info](#get_client_info)
- [get_client_version](#get_client_version)
- [ConnectionFlag](#ConnectionFlag)
- [FieldType](#FieldType)
  - [str](#str)
  - [get_len](#get_len)
- [C.MYSQL](#C.MYSQL)
- [C.MYSQL_BIND](#C.MYSQL_BIND)
- [C.MYSQL_FIELD](#C.MYSQL_FIELD)
- [C.MYSQL_RES](#C.MYSQL_RES)
- [C.MYSQL_STMT](#C.MYSQL_STMT)
- [Config](#Config)
- [DB](#DB)
  - [affected_rows](#affected_rows)
  - [autocommit](#autocommit)
  - [change_user](#change_user)
  - [close](#close)
  - [commit](#commit)
  - [create](#create)
  - [delete](#delete)
  - [drop](#drop)
  - [dump_debug_info](#dump_debug_info)
  - [escape_string](#escape_string)
  - [exec](#exec)
  - [exec_none](#exec_none)
  - [exec_one](#exec_one)
  - [exec_param](#exec_param)
  - [exec_param_many](#exec_param_many)
  - [get_host_info](#get_host_info)
  - [get_option](#get_option)
  - [get_server_info](#get_server_info)
  - [get_server_version](#get_server_version)
  - [info](#info)
  - [init_stmt](#init_stmt)
  - [insert](#insert)
  - [last_id](#last_id)
  - [ping](#ping)
  - [prepare](#prepare)
  - [query](#query)
  - [real_query](#real_query)
  - [refresh](#refresh)
  - [reset](#reset)
  - [select](#select)
  - [select_db](#select_db)
  - [set_option](#set_option)
  - [tables](#tables)
  - [update](#update)
  - [use_result](#use_result)
- [Field](#Field)
  - [str](#str)
- [Result](#Result)
  - [fetch_row](#fetch_row)
  - [n_rows](#n_rows)
  - [n_fields](#n_fields)
  - [rows](#rows)
  - [maps](#maps)
  - [fields](#fields)
  - [free](#free)
- [Row](#Row)
- [Stmt](#Stmt)
  - [str](#str)
  - [prepare](#prepare)
  - [bind_params](#bind_params)
  - [execute](#execute)
  - [next](#next)
  - [gen_metadata](#gen_metadata)
  - [fetch_fields](#fetch_fields)
  - [fetch_stmt](#fetch_stmt)
  - [close](#close)
  - [error](#error)
  - [bind_bool](#bind_bool)
  - [bind_byte](#bind_byte)
  - [bind_u8](#bind_u8)
  - [bind_i8](#bind_i8)
  - [bind_i16](#bind_i16)
  - [bind_u16](#bind_u16)
  - [bind_int](#bind_int)
  - [bind_u32](#bind_u32)
  - [bind_i64](#bind_i64)
  - [bind_u64](#bind_u64)
  - [bind_f32](#bind_f32)
  - [bind_f64](#bind_f64)
  - [bind_text](#bind_text)
  - [bind_null](#bind_null)
  - [bind](#bind)
  - [bind_res](#bind_res)
  - [bind_result_buffer](#bind_result_buffer)
  - [store_result](#store_result)
  - [fetch_column](#fetch_column)
- [StmtHandle](#StmtHandle)
  - [execute](#execute)
  - [close](#close)

## Constants
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

## debug
[[Return to contents]](#Contents)

## get_client_info
[[Return to contents]](#Contents)

## get_client_version
[[Return to contents]](#Contents)

## ConnectionFlag
[[Return to contents]](#Contents)

## FieldType
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## get_len
[[Return to contents]](#Contents)

## C.MYSQL
[[Return to contents]](#Contents)

## C.MYSQL_BIND
[[Return to contents]](#Contents)

## C.MYSQL_FIELD
[[Return to contents]](#Contents)

## C.MYSQL_RES
[[Return to contents]](#Contents)

## C.MYSQL_STMT
[[Return to contents]](#Contents)

## Config
[[Return to contents]](#Contents)

## DB
[[Return to contents]](#Contents)

## affected_rows
[[Return to contents]](#Contents)

## autocommit
[[Return to contents]](#Contents)

## change_user
[[Return to contents]](#Contents)

## close
[[Return to contents]](#Contents)

## commit
[[Return to contents]](#Contents)

## create
[[Return to contents]](#Contents)

## delete
[[Return to contents]](#Contents)

## drop
[[Return to contents]](#Contents)

## dump_debug_info
[[Return to contents]](#Contents)

## escape_string
[[Return to contents]](#Contents)

## exec
[[Return to contents]](#Contents)

## exec_none
[[Return to contents]](#Contents)

## exec_one
[[Return to contents]](#Contents)

## exec_param
[[Return to contents]](#Contents)

## exec_param_many
[[Return to contents]](#Contents)

## get_host_info
[[Return to contents]](#Contents)

## get_option
[[Return to contents]](#Contents)

## get_server_info
[[Return to contents]](#Contents)

## get_server_version
[[Return to contents]](#Contents)

## info
[[Return to contents]](#Contents)

## init_stmt
[[Return to contents]](#Contents)

## insert
[[Return to contents]](#Contents)

## last_id
[[Return to contents]](#Contents)

## ping
[[Return to contents]](#Contents)

## prepare
[[Return to contents]](#Contents)

## query
[[Return to contents]](#Contents)

## real_query
[[Return to contents]](#Contents)

## refresh
[[Return to contents]](#Contents)

## reset
[[Return to contents]](#Contents)

## select
[[Return to contents]](#Contents)

## select_db
[[Return to contents]](#Contents)

## set_option
[[Return to contents]](#Contents)

## tables
[[Return to contents]](#Contents)

## update
[[Return to contents]](#Contents)

## use_result
[[Return to contents]](#Contents)

## Field
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## Result
[[Return to contents]](#Contents)

## fetch_row
[[Return to contents]](#Contents)

## n_rows
[[Return to contents]](#Contents)

## n_fields
[[Return to contents]](#Contents)

## rows
[[Return to contents]](#Contents)

## maps
[[Return to contents]](#Contents)

## fields
[[Return to contents]](#Contents)

## free
[[Return to contents]](#Contents)

## Row
[[Return to contents]](#Contents)

## Stmt
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## prepare
[[Return to contents]](#Contents)

## bind_params
[[Return to contents]](#Contents)

## execute
[[Return to contents]](#Contents)

## next
[[Return to contents]](#Contents)

## gen_metadata
[[Return to contents]](#Contents)

## fetch_fields
[[Return to contents]](#Contents)

## fetch_stmt
[[Return to contents]](#Contents)

## close
[[Return to contents]](#Contents)

## error
[[Return to contents]](#Contents)

## bind_bool
[[Return to contents]](#Contents)

## bind_byte
[[Return to contents]](#Contents)

## bind_u8
[[Return to contents]](#Contents)

## bind_i8
[[Return to contents]](#Contents)

## bind_i16
[[Return to contents]](#Contents)

## bind_u16
[[Return to contents]](#Contents)

## bind_int
[[Return to contents]](#Contents)

## bind_u32
[[Return to contents]](#Contents)

## bind_i64
[[Return to contents]](#Contents)

## bind_u64
[[Return to contents]](#Contents)

## bind_f32
[[Return to contents]](#Contents)

## bind_f64
[[Return to contents]](#Contents)

## bind_text
[[Return to contents]](#Contents)

## bind_null
[[Return to contents]](#Contents)

## bind
[[Return to contents]](#Contents)

## bind_res
[[Return to contents]](#Contents)

## bind_result_buffer
[[Return to contents]](#Contents)

## store_result
[[Return to contents]](#Contents)

## fetch_column
[[Return to contents]](#Contents)

## StmtHandle
[[Return to contents]](#Contents)

## execute
[[Return to contents]](#Contents)

## close
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:55
