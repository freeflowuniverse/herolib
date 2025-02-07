# module vweb


## Contents
- [Constants](#Constants)
- [controller](#controller)
- [controller_host](#controller_host)
- [database_pool](#database_pool)
- [not_found](#not_found)
- [run](#run)
- [run_at](#run_at)
- [DatabasePool](#DatabasePool)
- [Middleware](#Middleware)
- [RawHtml](#RawHtml)
- [Context](#Context)
  - [init_server](#init_server)
  - [before_accept_loop](#before_accept_loop)
  - [before_request](#before_request)
  - [send_response_to_client](#send_response_to_client)
  - [html](#html)
  - [text](#text)
  - [json](#json)
  - [json_pretty](#json_pretty)
  - [file](#file)
  - [ok](#ok)
  - [server_error](#server_error)
  - [redirect](#redirect)
  - [not_found](#not_found)
  - [set_cookie](#set_cookie)
  - [set_content_type](#set_content_type)
  - [set_cookie_with_expire_date](#set_cookie_with_expire_date)
  - [get_cookie](#get_cookie)
  - [set_status](#set_status)
  - [add_header](#add_header)
  - [get_header](#get_header)
  - [set_value](#set_value)
  - [get_value](#get_value)
  - [handle_static](#handle_static)
  - [host_handle_static](#host_handle_static)
  - [mount_static_folder_at](#mount_static_folder_at)
  - [host_mount_static_folder_at](#host_mount_static_folder_at)
  - [serve_static](#serve_static)
  - [host_serve_static](#host_serve_static)
  - [user_agent](#user_agent)
  - [ip](#ip)
  - [error](#error)
- [Controller](#Controller)
- [ControllerPath](#ControllerPath)
- [PoolParams](#PoolParams)
- [RedirectParams](#RedirectParams)
- [Result](#Result)
- [RunParams](#RunParams)

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

## controller
[[Return to contents]](#Contents)

## controller_host
[[Return to contents]](#Contents)

## database_pool
[[Return to contents]](#Contents)

## not_found
[[Return to contents]](#Contents)

## run
[[Return to contents]](#Contents)

## run_at
Example
```v

vweb.run_at(new_app(), vweb.RunParams{ host: 'localhost' port: 8099 family: .ip }) or { panic(err) }

```

[[Return to contents]](#Contents)

## DatabasePool
[[Return to contents]](#Contents)

## Middleware
[[Return to contents]](#Contents)

## RawHtml
[[Return to contents]](#Contents)

## Context
[[Return to contents]](#Contents)

## init_server
[[Return to contents]](#Contents)

## before_accept_loop
[[Return to contents]](#Contents)

## before_request
[[Return to contents]](#Contents)

## send_response_to_client
[[Return to contents]](#Contents)

## html
[[Return to contents]](#Contents)

## text
[[Return to contents]](#Contents)

## json
[[Return to contents]](#Contents)

## json_pretty
[[Return to contents]](#Contents)

## file
[[Return to contents]](#Contents)

## ok
[[Return to contents]](#Contents)

## server_error
[[Return to contents]](#Contents)

## redirect
[[Return to contents]](#Contents)

## not_found
[[Return to contents]](#Contents)

## set_cookie
[[Return to contents]](#Contents)

## set_content_type
[[Return to contents]](#Contents)

## set_cookie_with_expire_date
[[Return to contents]](#Contents)

## get_cookie
[[Return to contents]](#Contents)

## set_status
[[Return to contents]](#Contents)

## add_header
[[Return to contents]](#Contents)

## get_header
[[Return to contents]](#Contents)

## set_value
[[Return to contents]](#Contents)

## get_value
[[Return to contents]](#Contents)

## handle_static
[[Return to contents]](#Contents)

## host_handle_static
[[Return to contents]](#Contents)

## mount_static_folder_at
[[Return to contents]](#Contents)

## host_mount_static_folder_at
[[Return to contents]](#Contents)

## serve_static
[[Return to contents]](#Contents)

## host_serve_static
[[Return to contents]](#Contents)

## user_agent
[[Return to contents]](#Contents)

## ip
[[Return to contents]](#Contents)

## error
[[Return to contents]](#Contents)

## Controller
[[Return to contents]](#Contents)

## ControllerPath
[[Return to contents]](#Contents)

## PoolParams
[[Return to contents]](#Contents)

## RedirectParams
[[Return to contents]](#Contents)

## Result
[[Return to contents]](#Contents)

## RunParams
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:56
