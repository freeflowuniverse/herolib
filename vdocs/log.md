# module log


## Contents
- [debug](#debug)
- [error](#error)
- [fatal](#fatal)
- [get_level](#get_level)
- [get_logger](#get_logger)
- [info](#info)
- [level_from_tag](#level_from_tag)
- [new_thread_safe_log](#new_thread_safe_log)
- [set_always_flush](#set_always_flush)
- [set_level](#set_level)
- [set_logger](#set_logger)
- [target_from_label](#target_from_label)
- [use_stdout](#use_stdout)
- [warn](#warn)
- [Logger](#Logger)
- [Level](#Level)
- [LogTarget](#LogTarget)
- [TimeFormat](#TimeFormat)
- [C.log__Logger](#C.log__Logger)
- [Log](#Log)
  - [get_level](#get_level)
  - [set_level](#set_level)
  - [set_full_logpath](#set_full_logpath)
  - [set_output_label](#set_output_label)
  - [set_output_path](#set_output_path)
  - [set_output_stream](#set_output_stream)
  - [log_to_console_too](#log_to_console_too)
  - [flush](#flush)
  - [close](#close)
  - [reopen](#reopen)
  - [send_output](#send_output)
  - [fatal](#fatal)
  - [error](#error)
  - [warn](#warn)
  - [info](#info)
  - [debug](#debug)
  - [free](#free)
  - [set_time_format](#set_time_format)
  - [set_always_flush](#set_always_flush)
  - [get_time_format](#get_time_format)
  - [set_custom_time_format](#set_custom_time_format)
  - [get_custom_time_format](#get_custom_time_format)
  - [set_short_tag](#set_short_tag)
  - [get_short_tag](#get_short_tag)
- [ThreadSafeLog](#ThreadSafeLog)
  - [free](#free)
  - [set_level](#set_level)
  - [set_always_flush](#set_always_flush)
  - [debug](#debug)
  - [info](#info)
  - [warn](#warn)
  - [error](#error)
  - [fatal](#fatal)

## debug
[[Return to contents]](#Contents)

## error
[[Return to contents]](#Contents)

## fatal
[[Return to contents]](#Contents)

## get_level
[[Return to contents]](#Contents)

## get_logger
[[Return to contents]](#Contents)

## info
[[Return to contents]](#Contents)

## level_from_tag
[[Return to contents]](#Contents)

## new_thread_safe_log
[[Return to contents]](#Contents)

## set_always_flush
[[Return to contents]](#Contents)

## set_level
[[Return to contents]](#Contents)

## set_logger
[[Return to contents]](#Contents)

## target_from_label
[[Return to contents]](#Contents)

## use_stdout
[[Return to contents]](#Contents)

## warn
[[Return to contents]](#Contents)

## Logger
[[Return to contents]](#Contents)

## Level
[[Return to contents]](#Contents)

## LogTarget
[[Return to contents]](#Contents)

## TimeFormat
[[Return to contents]](#Contents)

## C.log__Logger
[[Return to contents]](#Contents)

## Log
[[Return to contents]](#Contents)

## get_level
[[Return to contents]](#Contents)

## set_level
[[Return to contents]](#Contents)

## set_full_logpath
[[Return to contents]](#Contents)

## set_output_label
[[Return to contents]](#Contents)

## set_output_path
[[Return to contents]](#Contents)

## set_output_stream
[[Return to contents]](#Contents)

## log_to_console_too
[[Return to contents]](#Contents)

## flush
[[Return to contents]](#Contents)

## close
[[Return to contents]](#Contents)

## reopen
[[Return to contents]](#Contents)

## send_output
[[Return to contents]](#Contents)

## fatal
[[Return to contents]](#Contents)

## error
[[Return to contents]](#Contents)

## warn
[[Return to contents]](#Contents)

## info
[[Return to contents]](#Contents)

## debug
[[Return to contents]](#Contents)

## free
[[Return to contents]](#Contents)

## set_time_format
[[Return to contents]](#Contents)

## set_always_flush
[[Return to contents]](#Contents)

## get_time_format
[[Return to contents]](#Contents)

## set_custom_time_format
[[Return to contents]](#Contents)

## get_custom_time_format
[[Return to contents]](#Contents)

## set_short_tag
[[Return to contents]](#Contents)

## get_short_tag
[[Return to contents]](#Contents)

## ThreadSafeLog
[[Return to contents]](#Contents)

## free
[[Return to contents]](#Contents)

## set_level
[[Return to contents]](#Contents)

## set_always_flush
[[Return to contents]](#Contents)

## debug
[[Return to contents]](#Contents)

## info
[[Return to contents]](#Contents)

## warn
[[Return to contents]](#Contents)

## error
[[Return to contents]](#Contents)

## fatal
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:55
