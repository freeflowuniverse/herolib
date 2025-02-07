# module veb


## Contents
- [Constants](#Constants)
- [controller](#controller)
- [controller_host](#controller_host)
- [cors](#cors)
- [decode_gzip](#decode_gzip)
- [encode_gzip](#encode_gzip)
- [no_result](#no_result)
- [raw](#raw)
- [run](#run)
- [run_at](#run_at)
- [tr](#tr)
- [tr_plural](#tr_plural)
- [StaticApp](#StaticApp)
- [FileResponse](#FileResponse)
  - [done](#done)
- [MiddlewareHandler](#MiddlewareHandler)
- [Middleware[T]](#Middleware[T])
  - [str](#str)
  - [use](#use)
  - [route_use](#route_use)
- [RawHtml](#RawHtml)
- [RequestParams](#RequestParams)
  - [request_done](#request_done)
- [StringResponse](#StringResponse)
  - [done](#done)
- [RedirectType](#RedirectType)
- [Context](#Context)
  - [before_request](#before_request)
  - [error](#error)
  - [file](#file)
  - [get_cookie](#get_cookie)
  - [get_custom_header](#get_custom_header)
  - [get_header](#get_header)
  - [html](#html)
  - [ip](#ip)
  - [json](#json)
  - [json_pretty](#json_pretty)
  - [no_content](#no_content)
  - [not_found](#not_found)
  - [ok](#ok)
  - [redirect](#redirect)
  - [request_error](#request_error)
  - [send_response_to_client](#send_response_to_client)
  - [server_error](#server_error)
  - [set_content_type](#set_content_type)
  - [set_cookie](#set_cookie)
  - [set_custom_header](#set_custom_header)
  - [set_header](#set_header)
  - [takeover_conn](#takeover_conn)
  - [text](#text)
  - [user_agent](#user_agent)
- [Controller](#Controller)
  - [register_controller](#register_controller)
  - [register_host_controller](#register_host_controller)
- [ControllerPath](#ControllerPath)
- [CorsOptions](#CorsOptions)
  - [set_headers](#set_headers)
  - [validate_request](#validate_request)
- [Middleware](#Middleware)
- [MiddlewareOptions](#MiddlewareOptions)
- [RedirectParams](#RedirectParams)
- [Result](#Result)
- [RunParams](#RunParams)
- [StaticHandler](#StaticHandler)
  - [handle_static](#handle_static)
  - [host_handle_static](#host_handle_static)
  - [mount_static_folder_at](#mount_static_folder_at)
  - [host_mount_static_folder_at](#host_mount_static_folder_at)
  - [serve_static](#serve_static)
  - [host_serve_static](#host_serve_static)

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

## controller
[[Return to contents]](#Contents)

## controller_host
[[Return to contents]](#Contents)

## cors
Example
```v

app.use(veb.cors[Context](veb.CorsOptions{
    origins: ['*']
    allowed_methods: [.get, .head, .patch, .put, .post, .delete]
}))

```

[[Return to contents]](#Contents)

## decode_gzip
Example
```v

app.use(veb.decode_gzip[Context]())

```

[[Return to contents]](#Contents)

## encode_gzip
Example
```v

app.use(veb.encode_gzip[Context]())

```

[[Return to contents]](#Contents)

## no_result
[[Return to contents]](#Contents)

## raw
[[Return to contents]](#Contents)

## run
[[Return to contents]](#Contents)

## run_at
Example
```v

veb.run_at(new_app(), veb.RunParams{ host: 'localhost' port: 8099 family: .ip }) or { panic(err) }

```

[[Return to contents]](#Contents)

## tr
[[Return to contents]](#Contents)

## tr_plural
[[Return to contents]](#Contents)

## StaticApp
[[Return to contents]](#Contents)

## FileResponse
## done
[[Return to contents]](#Contents)

## MiddlewareHandler
[[Return to contents]](#Contents)

## Middleware[T]
## str
[[Return to contents]](#Contents)

## use
[[Return to contents]](#Contents)

## route_use
[[Return to contents]](#Contents)

## RawHtml
[[Return to contents]](#Contents)

## RequestParams
## request_done
[[Return to contents]](#Contents)

## StringResponse
## done
[[Return to contents]](#Contents)

## RedirectType
[[Return to contents]](#Contents)

## Context
[[Return to contents]](#Contents)

## before_request
[[Return to contents]](#Contents)

## error
[[Return to contents]](#Contents)

## file
[[Return to contents]](#Contents)

## get_cookie
[[Return to contents]](#Contents)

## get_custom_header
[[Return to contents]](#Contents)

## get_header
[[Return to contents]](#Contents)

## html
[[Return to contents]](#Contents)

## ip
[[Return to contents]](#Contents)

## json
[[Return to contents]](#Contents)

## json_pretty
[[Return to contents]](#Contents)

## no_content
[[Return to contents]](#Contents)

## not_found
[[Return to contents]](#Contents)

## ok
[[Return to contents]](#Contents)

## redirect
[[Return to contents]](#Contents)

## request_error
[[Return to contents]](#Contents)

## send_response_to_client
[[Return to contents]](#Contents)

## server_error
[[Return to contents]](#Contents)

## set_content_type
[[Return to contents]](#Contents)

## set_cookie
[[Return to contents]](#Contents)

## set_custom_header
[[Return to contents]](#Contents)

## set_header
[[Return to contents]](#Contents)

## takeover_conn
[[Return to contents]](#Contents)

## text
[[Return to contents]](#Contents)

## user_agent
[[Return to contents]](#Contents)

## Controller
[[Return to contents]](#Contents)

## register_controller
[[Return to contents]](#Contents)

## register_host_controller
[[Return to contents]](#Contents)

## ControllerPath
[[Return to contents]](#Contents)

## CorsOptions
[[Return to contents]](#Contents)

## set_headers
[[Return to contents]](#Contents)

## validate_request
[[Return to contents]](#Contents)

## Middleware
[[Return to contents]](#Contents)

## MiddlewareOptions
[[Return to contents]](#Contents)

## RedirectParams
[[Return to contents]](#Contents)

## Result
[[Return to contents]](#Contents)

## RunParams
[[Return to contents]](#Contents)

## StaticHandler
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

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:56
