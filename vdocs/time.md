# module time


## Contents
- [Constants](#Constants)
- [date_from_days_after_unix_epoch](#date_from_days_after_unix_epoch)
- [day_of_week](#day_of_week)
- [days_from_unix_epoch](#days_from_unix_epoch)
- [days_in_month](#days_in_month)
- [is_leap_year](#is_leap_year)
- [new](#new)
- [new_stopwatch](#new_stopwatch)
- [now](#now)
- [offset](#offset)
- [parse](#parse)
- [parse_format](#parse_format)
- [parse_iso8601](#parse_iso8601)
- [parse_rfc2822](#parse_rfc2822)
- [parse_rfc3339](#parse_rfc3339)
- [portable_timegm](#portable_timegm)
- [since](#since)
- [sleep](#sleep)
- [sys_mono_now](#sys_mono_now)
- [ticks](#ticks)
- [unix](#unix)
- [unix_micro](#unix_micro)
- [unix_microsecond](#unix_microsecond)
- [unix_milli](#unix_milli)
- [unix_nano](#unix_nano)
- [unix_nanosecond](#unix_nanosecond)
- [utc](#utc)
- [Time.new](#Time.new)
- [Duration](#Duration)
  - [days](#days)
  - [debug](#debug)
  - [hours](#hours)
  - [microseconds](#microseconds)
  - [milliseconds](#milliseconds)
  - [minutes](#minutes)
  - [nanoseconds](#nanoseconds)
  - [seconds](#seconds)
  - [str](#str)
  - [sys_milliseconds](#sys_milliseconds)
  - [timespec](#timespec)
- [FormatDate](#FormatDate)
- [FormatDelimiter](#FormatDelimiter)
- [FormatTime](#FormatTime)
- [C.mach_timebase_info_data_t](#C.mach_timebase_info_data_t)
- [C.timespec](#C.timespec)
- [C.timeval](#C.timeval)
- [C.tm](#C.tm)
- [StopWatch](#StopWatch)
  - [start](#start)
  - [restart](#restart)
  - [stop](#stop)
  - [pause](#pause)
  - [elapsed](#elapsed)
- [StopWatchOptions](#StopWatchOptions)
- [Time](#Time)
  - [-](#-)
  - [<](#<)
  - [==](#==)
  - [add](#add)
  - [add_days](#add_days)
  - [add_seconds](#add_seconds)
  - [as_local](#as_local)
  - [as_utc](#as_utc)
  - [clean](#clean)
  - [clean12](#clean12)
  - [custom_format](#custom_format)
  - [day_of_week](#day_of_week)
  - [days_from_unix_epoch](#days_from_unix_epoch)
  - [ddmmy](#ddmmy)
  - [debug](#debug)
  - [format](#format)
  - [format_rfc3339](#format_rfc3339)
  - [format_rfc3339_micro](#format_rfc3339_micro)
  - [format_rfc3339_nano](#format_rfc3339_nano)
  - [format_ss](#format_ss)
  - [format_ss_micro](#format_ss_micro)
  - [format_ss_milli](#format_ss_milli)
  - [format_ss_nano](#format_ss_nano)
  - [get_fmt_date_str](#get_fmt_date_str)
  - [get_fmt_str](#get_fmt_str)
  - [get_fmt_time_str](#get_fmt_time_str)
  - [hhmm](#hhmm)
  - [hhmm12](#hhmm12)
  - [hhmmss](#hhmmss)
  - [http_header_string](#http_header_string)
  - [is_utc](#is_utc)
  - [local](#local)
  - [local_to_utc](#local_to_utc)
  - [long_weekday_str](#long_weekday_str)
  - [md](#md)
  - [relative](#relative)
  - [relative_short](#relative_short)
  - [smonth](#smonth)
  - [str](#str)
  - [strftime](#strftime)
  - [unix](#unix)
  - [unix_micro](#unix_micro)
  - [unix_milli](#unix_milli)
  - [unix_nano](#unix_nano)
  - [utc_string](#utc_string)
  - [utc_to_local](#utc_to_local)
  - [weekday_str](#weekday_str)
  - [year_day](#year_day)
  - [ymmdd](#ymmdd)
- [TimeParseError](#TimeParseError)
  - [msg](#msg)

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

## date_from_days_after_unix_epoch
[[Return to contents]](#Contents)

## day_of_week
[[Return to contents]](#Contents)

## days_from_unix_epoch
[[Return to contents]](#Contents)

## days_in_month
[[Return to contents]](#Contents)

## is_leap_year
[[Return to contents]](#Contents)

## new
[[Return to contents]](#Contents)

## new_stopwatch
[[Return to contents]](#Contents)

## now
[[Return to contents]](#Contents)

## offset
[[Return to contents]](#Contents)

## parse
[[Return to contents]](#Contents)

## parse_format
[[Return to contents]](#Contents)

## parse_iso8601
[[Return to contents]](#Contents)

## parse_rfc2822
[[Return to contents]](#Contents)

## parse_rfc3339
[[Return to contents]](#Contents)

## portable_timegm
[[Return to contents]](#Contents)

## since
[[Return to contents]](#Contents)

## sleep
[[Return to contents]](#Contents)

## sys_mono_now
[[Return to contents]](#Contents)

## ticks
[[Return to contents]](#Contents)

## unix
[[Return to contents]](#Contents)

## unix_micro
[[Return to contents]](#Contents)

## unix_microsecond
[[Return to contents]](#Contents)

## unix_milli
[[Return to contents]](#Contents)

## unix_nano
[[Return to contents]](#Contents)

## unix_nanosecond
[[Return to contents]](#Contents)

## utc
[[Return to contents]](#Contents)

## Time.new
[[Return to contents]](#Contents)

## Duration
[[Return to contents]](#Contents)

## days
[[Return to contents]](#Contents)

## debug
[[Return to contents]](#Contents)

## hours
[[Return to contents]](#Contents)

## microseconds
[[Return to contents]](#Contents)

## milliseconds
[[Return to contents]](#Contents)

## minutes
[[Return to contents]](#Contents)

## nanoseconds
[[Return to contents]](#Contents)

## seconds
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## sys_milliseconds
[[Return to contents]](#Contents)

## timespec
[[Return to contents]](#Contents)

## FormatDate
[[Return to contents]](#Contents)

## FormatDelimiter
[[Return to contents]](#Contents)

## FormatTime
[[Return to contents]](#Contents)

## C.mach_timebase_info_data_t
[[Return to contents]](#Contents)

## C.timespec
[[Return to contents]](#Contents)

## C.timeval
[[Return to contents]](#Contents)

## C.tm
[[Return to contents]](#Contents)

## StopWatch
[[Return to contents]](#Contents)

## start
[[Return to contents]](#Contents)

## restart
[[Return to contents]](#Contents)

## stop
[[Return to contents]](#Contents)

## pause
[[Return to contents]](#Contents)

## elapsed
[[Return to contents]](#Contents)

## StopWatchOptions
[[Return to contents]](#Contents)

## Time
[[Return to contents]](#Contents)

## -
[[Return to contents]](#Contents)

## <
[[Return to contents]](#Contents)

## ==
[[Return to contents]](#Contents)

## add
[[Return to contents]](#Contents)

## add_days
[[Return to contents]](#Contents)

## add_seconds
[[Return to contents]](#Contents)

## as_local
[[Return to contents]](#Contents)

## as_utc
[[Return to contents]](#Contents)

## clean
[[Return to contents]](#Contents)

## clean12
[[Return to contents]](#Contents)

## custom_format
[[Return to contents]](#Contents)

## day_of_week
[[Return to contents]](#Contents)

## days_from_unix_epoch
[[Return to contents]](#Contents)

## ddmmy
[[Return to contents]](#Contents)

## debug
[[Return to contents]](#Contents)

## format
[[Return to contents]](#Contents)

## format_rfc3339
[[Return to contents]](#Contents)

## format_rfc3339_micro
[[Return to contents]](#Contents)

## format_rfc3339_nano
[[Return to contents]](#Contents)

## format_ss
[[Return to contents]](#Contents)

## format_ss_micro
[[Return to contents]](#Contents)

## format_ss_milli
[[Return to contents]](#Contents)

## format_ss_nano
[[Return to contents]](#Contents)

## get_fmt_date_str
[[Return to contents]](#Contents)

## get_fmt_str
[[Return to contents]](#Contents)

## get_fmt_time_str
[[Return to contents]](#Contents)

## hhmm
[[Return to contents]](#Contents)

## hhmm12
[[Return to contents]](#Contents)

## hhmmss
[[Return to contents]](#Contents)

## http_header_string
[[Return to contents]](#Contents)

## is_utc
[[Return to contents]](#Contents)

## local
[[Return to contents]](#Contents)

## local_to_utc
[[Return to contents]](#Contents)

## long_weekday_str
[[Return to contents]](#Contents)

## md
[[Return to contents]](#Contents)

## relative
[[Return to contents]](#Contents)

## relative_short
[[Return to contents]](#Contents)

## smonth
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## strftime
[[Return to contents]](#Contents)

## unix
[[Return to contents]](#Contents)

## unix_micro
[[Return to contents]](#Contents)

## unix_milli
[[Return to contents]](#Contents)

## unix_nano
[[Return to contents]](#Contents)

## utc_string
[[Return to contents]](#Contents)

## utc_to_local
[[Return to contents]](#Contents)

## weekday_str
[[Return to contents]](#Contents)

## year_day
[[Return to contents]](#Contents)

## ymmdd
[[Return to contents]](#Contents)

## TimeParseError
[[Return to contents]](#Contents)

## msg
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:55
