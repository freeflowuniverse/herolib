# module net.websocket


## Contents
- [new_client](#new_client)
- [new_server](#new_server)
- [AcceptClientFn](#AcceptClientFn)
- [SocketCloseFn](#SocketCloseFn)
- [SocketCloseFn2](#SocketCloseFn2)
- [SocketErrorFn](#SocketErrorFn)
- [SocketErrorFn2](#SocketErrorFn2)
- [SocketMessageFn](#SocketMessageFn)
- [SocketMessageFn2](#SocketMessageFn2)
- [SocketOpenFn](#SocketOpenFn)
- [SocketOpenFn2](#SocketOpenFn2)
- [Uri](#Uri)
  - [str](#str)
- [OPCode](#OPCode)
- [State](#State)
- [Client](#Client)
  - [close](#close)
  - [connect](#connect)
  - [free](#free)
  - [get_state](#get_state)
  - [listen](#listen)
  - [on_close](#on_close)
  - [on_close_ref](#on_close_ref)
  - [on_error](#on_error)
  - [on_error_ref](#on_error_ref)
  - [on_message](#on_message)
  - [on_message_ref](#on_message_ref)
  - [on_open](#on_open)
  - [on_open_ref](#on_open_ref)
  - [parse_frame_header](#parse_frame_header)
  - [ping](#ping)
  - [pong](#pong)
  - [read_next_message](#read_next_message)
  - [reset_state](#reset_state)
  - [set_state](#set_state)
  - [validate_frame](#validate_frame)
  - [write](#write)
  - [write_ptr](#write_ptr)
  - [write_string](#write_string)
- [ClientOpt](#ClientOpt)
- [ClientState](#ClientState)
- [Message](#Message)
  - [free](#free)
- [Server](#Server)
  - [free](#free)
  - [get_ping_interval](#get_ping_interval)
  - [get_state](#get_state)
  - [handle_handshake](#handle_handshake)
  - [listen](#listen)
  - [on_close](#on_close)
  - [on_close_ref](#on_close_ref)
  - [on_connect](#on_connect)
  - [on_message](#on_message)
  - [on_message_ref](#on_message_ref)
  - [set_ping_interval](#set_ping_interval)
  - [set_state](#set_state)
- [ServerClient](#ServerClient)
- [ServerOpt](#ServerOpt)
- [ServerState](#ServerState)

## new_client
[[Return to contents]](#Contents)

## new_server
[[Return to contents]](#Contents)

## AcceptClientFn
[[Return to contents]](#Contents)

## SocketCloseFn
[[Return to contents]](#Contents)

## SocketCloseFn2
[[Return to contents]](#Contents)

## SocketErrorFn
[[Return to contents]](#Contents)

## SocketErrorFn2
[[Return to contents]](#Contents)

## SocketMessageFn
[[Return to contents]](#Contents)

## SocketMessageFn2
[[Return to contents]](#Contents)

## SocketOpenFn
[[Return to contents]](#Contents)

## SocketOpenFn2
[[Return to contents]](#Contents)

## Uri
## str
[[Return to contents]](#Contents)

## OPCode
[[Return to contents]](#Contents)

## State
[[Return to contents]](#Contents)

## Client
[[Return to contents]](#Contents)

## close
[[Return to contents]](#Contents)

## connect
[[Return to contents]](#Contents)

## free
[[Return to contents]](#Contents)

## get_state
[[Return to contents]](#Contents)

## listen
[[Return to contents]](#Contents)

## on_close
[[Return to contents]](#Contents)

## on_close_ref
[[Return to contents]](#Contents)

## on_error
[[Return to contents]](#Contents)

## on_error_ref
[[Return to contents]](#Contents)

## on_message
[[Return to contents]](#Contents)

## on_message_ref
[[Return to contents]](#Contents)

## on_open
[[Return to contents]](#Contents)

## on_open_ref
[[Return to contents]](#Contents)

## parse_frame_header
[[Return to contents]](#Contents)

## ping
[[Return to contents]](#Contents)

## pong
[[Return to contents]](#Contents)

## read_next_message
[[Return to contents]](#Contents)

## reset_state
[[Return to contents]](#Contents)

## set_state
[[Return to contents]](#Contents)

## validate_frame
[[Return to contents]](#Contents)

## write
[[Return to contents]](#Contents)

## write_ptr
[[Return to contents]](#Contents)

## write_string
[[Return to contents]](#Contents)

## ClientOpt
[[Return to contents]](#Contents)

## ClientState
[[Return to contents]](#Contents)

## Message
[[Return to contents]](#Contents)

## free
[[Return to contents]](#Contents)

## Server
[[Return to contents]](#Contents)

## free
[[Return to contents]](#Contents)

## get_ping_interval
[[Return to contents]](#Contents)

## get_state
[[Return to contents]](#Contents)

## handle_handshake
[[Return to contents]](#Contents)

## listen
[[Return to contents]](#Contents)

## on_close
[[Return to contents]](#Contents)

## on_close_ref
[[Return to contents]](#Contents)

## on_connect
[[Return to contents]](#Contents)

## on_message
[[Return to contents]](#Contents)

## on_message_ref
[[Return to contents]](#Contents)

## set_ping_interval
[[Return to contents]](#Contents)

## set_state
[[Return to contents]](#Contents)

## ServerClient
[[Return to contents]](#Contents)

## ServerOpt
[[Return to contents]](#Contents)

## ServerState
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:55
