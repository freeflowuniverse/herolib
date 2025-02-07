# module x.sessions


## Contents
- [new_session_id](#new_session_id)
- [verify_session_id](#verify_session_id)
- [DBStore.create](#DBStore.create)
- [Store](#Store)
  - [all](#all)
  - [clear](#clear)
- [DBStore[T]](#DBStore[T])
  - [all](#all)
  - [get](#get)
  - [destroy](#destroy)
  - [clear](#clear)
  - [set](#set)
- [MemoryStore[T]](#MemoryStore[T])
  - [all](#all)
  - [get](#get)
  - [destroy](#destroy)
  - [clear](#clear)
  - [set](#set)
- [Sessions[T]](#Sessions[T])
  - [set_session_id](#set_session_id)
  - [validate_session](#validate_session)
  - [get](#get)
  - [destroy](#destroy)
  - [logout](#logout)
  - [save](#save)
  - [resave](#resave)
  - [get_session_id](#get_session_id)
- [CookieOptions](#CookieOptions)
- [CurrentSession](#CurrentSession)
- [DBStore](#DBStore)
- [DBStoreSessions](#DBStoreSessions)
- [MemoryStore](#MemoryStore)
- [Sessions](#Sessions)

## new_session_id
[[Return to contents]](#Contents)

## verify_session_id
[[Return to contents]](#Contents)

## DBStore.create
[[Return to contents]](#Contents)

## Store
[[Return to contents]](#Contents)

## all
[[Return to contents]](#Contents)

## clear
[[Return to contents]](#Contents)

## DBStore[T]
## all
[[Return to contents]](#Contents)

## get
[[Return to contents]](#Contents)

## destroy
[[Return to contents]](#Contents)

## clear
[[Return to contents]](#Contents)

## set
[[Return to contents]](#Contents)

## MemoryStore[T]
## all
[[Return to contents]](#Contents)

## get
[[Return to contents]](#Contents)

## destroy
[[Return to contents]](#Contents)

## clear
[[Return to contents]](#Contents)

## set
[[Return to contents]](#Contents)

## Sessions[T]
## set_session_id
[[Return to contents]](#Contents)

## validate_session
[[Return to contents]](#Contents)

## get
[[Return to contents]](#Contents)

## destroy
[[Return to contents]](#Contents)

## logout
[[Return to contents]](#Contents)

## save
[[Return to contents]](#Contents)

## resave
[[Return to contents]](#Contents)

## get_session_id
[[Return to contents]](#Contents)

## CookieOptions
[[Return to contents]](#Contents)

## CurrentSession
Example
```v

pub struct Context {
    vweb.Context
    sessions.CurrentSessions[User]
}

```

[[Return to contents]](#Contents)

## DBStore
[[Return to contents]](#Contents)

## DBStoreSessions
[[Return to contents]](#Contents)

## MemoryStore
[[Return to contents]](#Contents)

## Sessions
Example
```v

pub struct App {
pub mut:
    sessions &sessions.Sessions[User]
}

```

[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:57
