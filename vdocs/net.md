# module net


## Contents
- [Constants](#Constants)
- [addr_from_socket_handle](#addr_from_socket_handle)
- [close](#close)
- [default_tcp_dialer](#default_tcp_dialer)
- [dial_tcp](#dial_tcp)
- [dial_tcp_with_bind](#dial_tcp_with_bind)
- [dial_udp](#dial_udp)
- [error_code](#error_code)
- [listen_tcp](#listen_tcp)
- [listen_udp](#listen_udp)
- [new_ip](#new_ip)
- [new_ip6](#new_ip6)
- [new_tcp_socket](#new_tcp_socket)
- [peer_addr_from_socket_handle](#peer_addr_from_socket_handle)
- [resolve_addrs](#resolve_addrs)
- [resolve_addrs_fuzzy](#resolve_addrs_fuzzy)
- [resolve_ipaddrs](#resolve_ipaddrs)
- [set_blocking](#set_blocking)
- [shutdown](#shutdown)
- [socket_error](#socket_error)
- [socket_error_message](#socket_error_message)
- [split_address](#split_address)
- [tcp_socket_from_handle_raw](#tcp_socket_from_handle_raw)
- [validate_port](#validate_port)
- [wrap_error](#wrap_error)
- [Connection](#Connection)
- [Dialer](#Dialer)
- [TcpSocket](#TcpSocket)
  - [set_option_bool](#set_option_bool)
  - [set_option_int](#set_option_int)
  - [set_dualstack](#set_dualstack)
  - [bind](#bind)
- [UdpSocket](#UdpSocket)
  - [set_option_bool](#set_option_bool)
  - [set_dualstack](#set_dualstack)
- [AddrFamily](#AddrFamily)
- [ShutdownDirection](#ShutdownDirection)
- [SocketOption](#SocketOption)
- [SocketType](#SocketType)
- [Addr](#Addr)
  - [family](#family)
  - [len](#len)
  - [port](#port)
  - [str](#str)
- [C.addrinfo](#C.addrinfo)
- [C.fd_set](#C.fd_set)
- [C.sockaddr_in](#C.sockaddr_in)
- [C.sockaddr_in6](#C.sockaddr_in6)
- [C.sockaddr_un](#C.sockaddr_un)
- [Ip](#Ip)
  - [str](#str)
- [Ip6](#Ip6)
  - [str](#str)
- [ListenOptions](#ListenOptions)
- [ShutdownConfig](#ShutdownConfig)
- [Socket](#Socket)
  - [address](#address)
- [TCPDialer](#TCPDialer)
  - [dial](#dial)
- [TcpConn](#TcpConn)
  - [addr](#addr)
  - [close](#close)
  - [get_blocking](#get_blocking)
  - [peer_addr](#peer_addr)
  - [peer_ip](#peer_ip)
  - [read](#read)
  - [read_deadline](#read_deadline)
  - [read_line](#read_line)
  - [read_line_max](#read_line_max)
  - [read_ptr](#read_ptr)
  - [read_timeout](#read_timeout)
  - [set_blocking](#set_blocking)
  - [set_read_deadline](#set_read_deadline)
  - [set_read_timeout](#set_read_timeout)
  - [set_sock](#set_sock)
  - [set_write_deadline](#set_write_deadline)
  - [set_write_timeout](#set_write_timeout)
  - [str](#str)
  - [wait_for_read](#wait_for_read)
  - [wait_for_write](#wait_for_write)
  - [write](#write)
  - [write_deadline](#write_deadline)
  - [write_ptr](#write_ptr)
  - [write_string](#write_string)
  - [write_timeout](#write_timeout)
- [TcpListener](#TcpListener)
  - [accept](#accept)
  - [accept_only](#accept_only)
  - [accept_deadline](#accept_deadline)
  - [set_accept_deadline](#set_accept_deadline)
  - [accept_timeout](#accept_timeout)
  - [set_accept_timeout](#set_accept_timeout)
  - [wait_for_accept](#wait_for_accept)
  - [close](#close)
  - [addr](#addr)
- [UdpConn](#UdpConn)
  - [write_ptr](#write_ptr)
  - [write](#write)
  - [write_string](#write_string)
  - [write_to_ptr](#write_to_ptr)
  - [write_to](#write_to)
  - [write_to_string](#write_to_string)
  - [read](#read)
  - [read_deadline](#read_deadline)
  - [set_read_deadline](#set_read_deadline)
  - [write_deadline](#write_deadline)
  - [set_write_deadline](#set_write_deadline)
  - [read_timeout](#read_timeout)
  - [set_read_timeout](#set_read_timeout)
  - [write_timeout](#write_timeout)
  - [set_write_timeout](#set_write_timeout)
  - [wait_for_read](#wait_for_read)
  - [wait_for_write](#wait_for_write)
  - [str](#str)
  - [close](#close)
- [Unix](#Unix)

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

## addr_from_socket_handle
[[Return to contents]](#Contents)

## close
[[Return to contents]](#Contents)

## default_tcp_dialer
[[Return to contents]](#Contents)

## dial_tcp
[[Return to contents]](#Contents)

## dial_tcp_with_bind
[[Return to contents]](#Contents)

## dial_udp
[[Return to contents]](#Contents)

## error_code
[[Return to contents]](#Contents)

## listen_tcp
[[Return to contents]](#Contents)

## listen_udp
[[Return to contents]](#Contents)

## new_ip
[[Return to contents]](#Contents)

## new_ip6
[[Return to contents]](#Contents)

## new_tcp_socket
[[Return to contents]](#Contents)

## peer_addr_from_socket_handle
[[Return to contents]](#Contents)

## resolve_addrs
[[Return to contents]](#Contents)

## resolve_addrs_fuzzy
[[Return to contents]](#Contents)

## resolve_ipaddrs
[[Return to contents]](#Contents)

## set_blocking
[[Return to contents]](#Contents)

## shutdown
[[Return to contents]](#Contents)

## socket_error
[[Return to contents]](#Contents)

## socket_error_message
[[Return to contents]](#Contents)

## split_address
[[Return to contents]](#Contents)

## tcp_socket_from_handle_raw
[[Return to contents]](#Contents)

## validate_port
[[Return to contents]](#Contents)

## wrap_error
[[Return to contents]](#Contents)

## Connection
[[Return to contents]](#Contents)

## Dialer
[[Return to contents]](#Contents)

## TcpSocket
## set_option_bool
[[Return to contents]](#Contents)

## set_option_int
[[Return to contents]](#Contents)

## set_dualstack
[[Return to contents]](#Contents)

## bind
[[Return to contents]](#Contents)

## UdpSocket
## set_option_bool
[[Return to contents]](#Contents)

## set_dualstack
[[Return to contents]](#Contents)

## AddrFamily
[[Return to contents]](#Contents)

## ShutdownDirection
[[Return to contents]](#Contents)

## SocketOption
[[Return to contents]](#Contents)

## SocketType
[[Return to contents]](#Contents)

## Addr
[[Return to contents]](#Contents)

## family
[[Return to contents]](#Contents)

## len
[[Return to contents]](#Contents)

## port
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## C.addrinfo
[[Return to contents]](#Contents)

## C.fd_set
[[Return to contents]](#Contents)

## C.sockaddr_in
[[Return to contents]](#Contents)

## C.sockaddr_in6
[[Return to contents]](#Contents)

## C.sockaddr_un
[[Return to contents]](#Contents)

## Ip
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## Ip6
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## ListenOptions
[[Return to contents]](#Contents)

## ShutdownConfig
[[Return to contents]](#Contents)

## Socket
[[Return to contents]](#Contents)

## address
[[Return to contents]](#Contents)

## TCPDialer
[[Return to contents]](#Contents)

## dial
[[Return to contents]](#Contents)

## TcpConn
[[Return to contents]](#Contents)

## addr
[[Return to contents]](#Contents)

## close
[[Return to contents]](#Contents)

## get_blocking
[[Return to contents]](#Contents)

## peer_addr
[[Return to contents]](#Contents)

## peer_ip
[[Return to contents]](#Contents)

## read
[[Return to contents]](#Contents)

## read_deadline
[[Return to contents]](#Contents)

## read_line
[[Return to contents]](#Contents)

## read_line_max
[[Return to contents]](#Contents)

## read_ptr
[[Return to contents]](#Contents)

## read_timeout
[[Return to contents]](#Contents)

## set_blocking
[[Return to contents]](#Contents)

## set_read_deadline
[[Return to contents]](#Contents)

## set_read_timeout
[[Return to contents]](#Contents)

## set_sock
[[Return to contents]](#Contents)

## set_write_deadline
[[Return to contents]](#Contents)

## set_write_timeout
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## wait_for_read
[[Return to contents]](#Contents)

## wait_for_write
[[Return to contents]](#Contents)

## write
[[Return to contents]](#Contents)

## write_deadline
[[Return to contents]](#Contents)

## write_ptr
[[Return to contents]](#Contents)

## write_string
[[Return to contents]](#Contents)

## write_timeout
[[Return to contents]](#Contents)

## TcpListener
[[Return to contents]](#Contents)

## accept
[[Return to contents]](#Contents)

## accept_only
[[Return to contents]](#Contents)

## accept_deadline
[[Return to contents]](#Contents)

## set_accept_deadline
[[Return to contents]](#Contents)

## accept_timeout
[[Return to contents]](#Contents)

## set_accept_timeout
[[Return to contents]](#Contents)

## wait_for_accept
[[Return to contents]](#Contents)

## close
[[Return to contents]](#Contents)

## addr
[[Return to contents]](#Contents)

## UdpConn
[[Return to contents]](#Contents)

## write_ptr
[[Return to contents]](#Contents)

## write
[[Return to contents]](#Contents)

## write_string
[[Return to contents]](#Contents)

## write_to_ptr
[[Return to contents]](#Contents)

## write_to
[[Return to contents]](#Contents)

## write_to_string
[[Return to contents]](#Contents)

## read
[[Return to contents]](#Contents)

## read_deadline
[[Return to contents]](#Contents)

## set_read_deadline
[[Return to contents]](#Contents)

## write_deadline
[[Return to contents]](#Contents)

## set_write_deadline
[[Return to contents]](#Contents)

## read_timeout
[[Return to contents]](#Contents)

## set_read_timeout
[[Return to contents]](#Contents)

## write_timeout
[[Return to contents]](#Contents)

## set_write_timeout
[[Return to contents]](#Contents)

## wait_for_read
[[Return to contents]](#Contents)

## wait_for_write
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## close
[[Return to contents]](#Contents)

## Unix
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:55
