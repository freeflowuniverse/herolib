# module net.http


## Contents
- [Constants](#Constants)
- [delete](#delete)
- [download_file](#download_file)
- [download_file_with_cookies](#download_file_with_cookies)
- [download_file_with_progress](#download_file_with_progress)
- [fetch](#fetch)
- [get](#get)
- [get_text](#get_text)
- [head](#head)
- [is_cookie_domain_name](#is_cookie_domain_name)
- [method_from_str](#method_from_str)
- [new_custom_header_from_map](#new_custom_header_from_map)
- [new_header](#new_header)
- [new_header_from_map](#new_header_from_map)
- [new_http_proxy](#new_http_proxy)
- [new_request](#new_request)
- [new_response](#new_response)
- [parse_form](#parse_form)
- [parse_multipart_form](#parse_multipart_form)
- [parse_request](#parse_request)
- [parse_request_head](#parse_request_head)
- [parse_response](#parse_response)
- [patch](#patch)
- [post](#post)
- [post_form](#post_form)
- [post_form_with_cookies](#post_form_with_cookies)
- [post_json](#post_json)
- [post_multipart_form](#post_multipart_form)
- [prepare](#prepare)
- [put](#put)
- [read_cookies](#read_cookies)
- [sanitize_cookie_value](#sanitize_cookie_value)
- [status_from_int](#status_from_int)
- [url_encode_form_data](#url_encode_form_data)
- [version_from_str](#version_from_str)
- [Downloader](#Downloader)
- [Handler](#Handler)
- [HeaderKeyError](#HeaderKeyError)
  - [msg](#msg)
  - [code](#code)
- [RequestFinishFn](#RequestFinishFn)
- [RequestProgressBodyFn](#RequestProgressBodyFn)
- [RequestProgressFn](#RequestProgressFn)
- [RequestRedirectFn](#RequestRedirectFn)
- [CommonHeader](#CommonHeader)
  - [str](#str)
- [Method](#Method)
  - [str](#str)
- [SameSite](#SameSite)
- [ServerStatus](#ServerStatus)
- [Status](#Status)
  - [str](#str)
  - [int](#int)
  - [is_valid](#is_valid)
  - [is_error](#is_error)
  - [is_success](#is_success)
- [Version](#Version)
  - [str](#str)
  - [protos](#protos)
- [Cookie](#Cookie)
  - [str](#str)
- [DownloaderParams](#DownloaderParams)
- [FetchConfig](#FetchConfig)
- [FileData](#FileData)
- [Header](#Header)
  - [free](#free)
  - [add](#add)
  - [add_custom](#add_custom)
  - [add_map](#add_map)
  - [add_custom_map](#add_custom_map)
  - [set](#set)
  - [set_custom](#set_custom)
  - [delete](#delete)
  - [delete_custom](#delete_custom)
  - [coerce](#coerce)
  - [contains](#contains)
  - [contains_custom](#contains_custom)
  - [get](#get)
  - [get_custom](#get_custom)
  - [starting_with](#starting_with)
  - [values](#values)
  - [custom_values](#custom_values)
  - [keys](#keys)
  - [render](#render)
  - [render_into_sb](#render_into_sb)
  - [join](#join)
  - [str](#str)
- [HeaderCoerceConfig](#HeaderCoerceConfig)
- [HeaderConfig](#HeaderConfig)
- [HeaderQueryConfig](#HeaderQueryConfig)
- [HeaderRenderConfig](#HeaderRenderConfig)
- [MultiplePathAttributesError](#MultiplePathAttributesError)
  - [msg](#msg)
- [PostMultipartFormConfig](#PostMultipartFormConfig)
- [Request](#Request)
  - [add_header](#add_header)
  - [add_custom_header](#add_custom_header)
  - [add_cookie](#add_cookie)
  - [cookie](#cookie)
  - [do](#do)
  - [referer](#referer)
- [Response](#Response)
  - [bytes](#bytes)
  - [bytestr](#bytestr)
  - [cookies](#cookies)
  - [status](#status)
  - [set_status](#set_status)
  - [version](#version)
  - [set_version](#set_version)
- [ResponseConfig](#ResponseConfig)
- [Server](#Server)
  - [listen_and_serve](#listen_and_serve)
  - [stop](#stop)
  - [close](#close)
  - [status](#status)
  - [wait_till_running](#wait_till_running)
- [SilentStreamingDownloader](#SilentStreamingDownloader)
  - [on_start](#on_start)
  - [on_chunk](#on_chunk)
  - [on_finish](#on_finish)
- [TerminalStreamingDownloader](#TerminalStreamingDownloader)
  - [on_start](#on_start)
  - [on_chunk](#on_chunk)
  - [on_finish](#on_finish)
- [UnexpectedExtraAttributeError](#UnexpectedExtraAttributeError)
  - [msg](#msg)
- [WaitTillRunningParams](#WaitTillRunningParams)

## Constants
[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

## delete
[[Return to contents]](#Contents)

## download_file
[[Return to contents]](#Contents)

## download_file_with_cookies
[[Return to contents]](#Contents)

## download_file_with_progress
[[Return to contents]](#Contents)

## fetch
[[Return to contents]](#Contents)

## get
[[Return to contents]](#Contents)

## get_text
[[Return to contents]](#Contents)

## head
[[Return to contents]](#Contents)

## is_cookie_domain_name
[[Return to contents]](#Contents)

## method_from_str
[[Return to contents]](#Contents)

## new_custom_header_from_map
[[Return to contents]](#Contents)

## new_header
[[Return to contents]](#Contents)

## new_header_from_map
[[Return to contents]](#Contents)

## new_http_proxy
[[Return to contents]](#Contents)

## new_request
[[Return to contents]](#Contents)

## new_response
[[Return to contents]](#Contents)

## parse_form
[[Return to contents]](#Contents)

## parse_multipart_form
[[Return to contents]](#Contents)

## parse_request
[[Return to contents]](#Contents)

## parse_request_head
[[Return to contents]](#Contents)

## parse_response
[[Return to contents]](#Contents)

## patch
[[Return to contents]](#Contents)

## post
[[Return to contents]](#Contents)

## post_form
[[Return to contents]](#Contents)

## post_form_with_cookies
[[Return to contents]](#Contents)

## post_json
[[Return to contents]](#Contents)

## post_multipart_form
[[Return to contents]](#Contents)

## prepare
[[Return to contents]](#Contents)

## put
[[Return to contents]](#Contents)

## read_cookies
[[Return to contents]](#Contents)

## sanitize_cookie_value
[[Return to contents]](#Contents)

## status_from_int
[[Return to contents]](#Contents)

## url_encode_form_data
[[Return to contents]](#Contents)

## version_from_str
[[Return to contents]](#Contents)

## Downloader
[[Return to contents]](#Contents)

## Handler
[[Return to contents]](#Contents)

## HeaderKeyError
## msg
[[Return to contents]](#Contents)

## code
[[Return to contents]](#Contents)

## RequestFinishFn
[[Return to contents]](#Contents)

## RequestProgressBodyFn
[[Return to contents]](#Contents)

## RequestProgressFn
[[Return to contents]](#Contents)

## RequestRedirectFn
[[Return to contents]](#Contents)

## CommonHeader
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## Method
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## SameSite
[[Return to contents]](#Contents)

## ServerStatus
[[Return to contents]](#Contents)

## Status
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## int
[[Return to contents]](#Contents)

## is_valid
[[Return to contents]](#Contents)

## is_error
[[Return to contents]](#Contents)

## is_success
[[Return to contents]](#Contents)

## Version
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## protos
[[Return to contents]](#Contents)

## Cookie
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## DownloaderParams
[[Return to contents]](#Contents)

## FetchConfig
[[Return to contents]](#Contents)

## FileData
[[Return to contents]](#Contents)

## Header
[[Return to contents]](#Contents)

## free
[[Return to contents]](#Contents)

## add
[[Return to contents]](#Contents)

## add_custom
[[Return to contents]](#Contents)

## add_map
[[Return to contents]](#Contents)

## add_custom_map
[[Return to contents]](#Contents)

## set
[[Return to contents]](#Contents)

## set_custom
[[Return to contents]](#Contents)

## delete
[[Return to contents]](#Contents)

## delete_custom
[[Return to contents]](#Contents)

## coerce
[[Return to contents]](#Contents)

## contains
[[Return to contents]](#Contents)

## contains_custom
[[Return to contents]](#Contents)

## get
[[Return to contents]](#Contents)

## get_custom
[[Return to contents]](#Contents)

## starting_with
[[Return to contents]](#Contents)

## values
[[Return to contents]](#Contents)

## custom_values
[[Return to contents]](#Contents)

## keys
[[Return to contents]](#Contents)

## render
[[Return to contents]](#Contents)

## render_into_sb
[[Return to contents]](#Contents)

## join
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## HeaderCoerceConfig
[[Return to contents]](#Contents)

## HeaderConfig
[[Return to contents]](#Contents)

## HeaderQueryConfig
[[Return to contents]](#Contents)

## HeaderRenderConfig
[[Return to contents]](#Contents)

## MultiplePathAttributesError
[[Return to contents]](#Contents)

## msg
[[Return to contents]](#Contents)

## PostMultipartFormConfig
[[Return to contents]](#Contents)

## Request
[[Return to contents]](#Contents)

## add_header
[[Return to contents]](#Contents)

## add_custom_header
[[Return to contents]](#Contents)

## add_cookie
[[Return to contents]](#Contents)

## cookie
[[Return to contents]](#Contents)

## do
[[Return to contents]](#Contents)

## referer
[[Return to contents]](#Contents)

## Response
[[Return to contents]](#Contents)

## bytes
[[Return to contents]](#Contents)

## bytestr
[[Return to contents]](#Contents)

## cookies
[[Return to contents]](#Contents)

## status
[[Return to contents]](#Contents)

## set_status
[[Return to contents]](#Contents)

## version
[[Return to contents]](#Contents)

## set_version
[[Return to contents]](#Contents)

## ResponseConfig
[[Return to contents]](#Contents)

## Server
[[Return to contents]](#Contents)

## listen_and_serve
[[Return to contents]](#Contents)

## stop
[[Return to contents]](#Contents)

## close
[[Return to contents]](#Contents)

## status
[[Return to contents]](#Contents)

## wait_till_running
[[Return to contents]](#Contents)

## SilentStreamingDownloader
[[Return to contents]](#Contents)

## on_start
[[Return to contents]](#Contents)

## on_chunk
[[Return to contents]](#Contents)

## on_finish
[[Return to contents]](#Contents)

## TerminalStreamingDownloader
[[Return to contents]](#Contents)

## on_start
[[Return to contents]](#Contents)

## on_chunk
[[Return to contents]](#Contents)

## on_finish
[[Return to contents]](#Contents)

## UnexpectedExtraAttributeError
[[Return to contents]](#Contents)

## msg
[[Return to contents]](#Contents)

## WaitTillRunningParams
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:55
