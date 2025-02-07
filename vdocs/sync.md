# module sync


## Contents
- [channel_select](#channel_select)
- [new_channel](#new_channel)
- [new_many_times](#new_many_times)
- [new_mutex](#new_mutex)
- [new_once](#new_once)
- [new_rwmutex](#new_rwmutex)
- [new_semaphore](#new_semaphore)
- [new_semaphore_init](#new_semaphore_init)
- [new_waitgroup](#new_waitgroup)
- [thread_id](#thread_id)
- [Direction](#Direction)
- [C.atomic_uintptr_t](#C.atomic_uintptr_t)
- [C.pthread_cond_t](#C.pthread_cond_t)
- [C.pthread_condattr_t](#C.pthread_condattr_t)
- [C.pthread_mutex_t](#C.pthread_mutex_t)
- [C.pthread_rwlock_t](#C.pthread_rwlock_t)
- [C.pthread_rwlockattr_t](#C.pthread_rwlockattr_t)
- [C.sem_t](#C.sem_t)
- [Channel](#Channel)
  - [auto_str](#auto_str)
  - [close](#close)
  - [len](#len)
  - [closed](#closed)
  - [push](#push)
  - [try_push](#try_push)
  - [pop](#pop)
  - [try_pop](#try_pop)
- [ManyTimes](#ManyTimes)
  - [do](#do)
- [Mutex](#Mutex)
  - [destroy](#destroy)
  - [init](#init)
  - [lock](#lock)
  - [str](#str)
  - [try_lock](#try_lock)
  - [unlock](#unlock)
- [Once](#Once)
  - [do](#do)
  - [do_with_param](#do_with_param)
- [RwMutex](#RwMutex)
  - [destroy](#destroy)
  - [init](#init)
  - [lock](#lock)
  - [rlock](#rlock)
  - [runlock](#runlock)
  - [str](#str)
  - [try_rlock](#try_rlock)
  - [try_wlock](#try_wlock)
  - [unlock](#unlock)
- [Semaphore](#Semaphore)
  - [init](#init)
  - [post](#post)
  - [wait](#wait)
  - [try_wait](#try_wait)
  - [timed_wait](#timed_wait)
  - [destroy](#destroy)
- [WaitGroup](#WaitGroup)
  - [init](#init)
  - [add](#add)
  - [done](#done)
  - [wait](#wait)

## channel_select
[[Return to contents]](#Contents)

## new_channel
[[Return to contents]](#Contents)

## new_many_times
[[Return to contents]](#Contents)

## new_mutex
[[Return to contents]](#Contents)

## new_once
[[Return to contents]](#Contents)

## new_rwmutex
[[Return to contents]](#Contents)

## new_semaphore
[[Return to contents]](#Contents)

## new_semaphore_init
[[Return to contents]](#Contents)

## new_waitgroup
[[Return to contents]](#Contents)

## thread_id
[[Return to contents]](#Contents)

## Direction
[[Return to contents]](#Contents)

## C.atomic_uintptr_t
[[Return to contents]](#Contents)

## C.pthread_cond_t
[[Return to contents]](#Contents)

## C.pthread_condattr_t
[[Return to contents]](#Contents)

## C.pthread_mutex_t
[[Return to contents]](#Contents)

## C.pthread_rwlock_t
[[Return to contents]](#Contents)

## C.pthread_rwlockattr_t
[[Return to contents]](#Contents)

## C.sem_t
[[Return to contents]](#Contents)

## Channel
[[Return to contents]](#Contents)

## auto_str
[[Return to contents]](#Contents)

## close
[[Return to contents]](#Contents)

## len
[[Return to contents]](#Contents)

## closed
[[Return to contents]](#Contents)

## push
[[Return to contents]](#Contents)

## try_push
[[Return to contents]](#Contents)

## pop
[[Return to contents]](#Contents)

## try_pop
[[Return to contents]](#Contents)

## ManyTimes
[[Return to contents]](#Contents)

## do
[[Return to contents]](#Contents)

## Mutex
[[Return to contents]](#Contents)

## destroy
[[Return to contents]](#Contents)

## init
[[Return to contents]](#Contents)

## lock
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## try_lock
[[Return to contents]](#Contents)

## unlock
[[Return to contents]](#Contents)

## Once
[[Return to contents]](#Contents)

## do
[[Return to contents]](#Contents)

## do_with_param
[[Return to contents]](#Contents)

## RwMutex
[[Return to contents]](#Contents)

## destroy
[[Return to contents]](#Contents)

## init
[[Return to contents]](#Contents)

## lock
[[Return to contents]](#Contents)

## rlock
[[Return to contents]](#Contents)

## runlock
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## try_rlock
[[Return to contents]](#Contents)

## try_wlock
[[Return to contents]](#Contents)

## unlock
[[Return to contents]](#Contents)

## Semaphore
[[Return to contents]](#Contents)

## init
[[Return to contents]](#Contents)

## post
[[Return to contents]](#Contents)

## wait
[[Return to contents]](#Contents)

## try_wait
[[Return to contents]](#Contents)

## timed_wait
[[Return to contents]](#Contents)

## destroy
[[Return to contents]](#Contents)

## WaitGroup
[[Return to contents]](#Contents)

## init
[[Return to contents]](#Contents)

## add
[[Return to contents]](#Contents)

## done
[[Return to contents]](#Contents)

## wait
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:55
