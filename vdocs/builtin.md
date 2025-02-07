# module builtin


## Contents
- [Constants](#Constants)
- [C.android_print](#C.android_print)
- [arguments](#arguments)
- [at_exit](#at_exit)
- [c_error_number_str](#c_error_number_str)
- [compare_strings](#compare_strings)
- [copy](#copy)
- [cstring_to_vstring](#cstring_to_vstring)
- [eprint](#eprint)
- [eprintln](#eprintln)
- [error](#error)
- [error_with_code](#error_with_code)
- [exit](#exit)
- [f32_abs](#f32_abs)
- [f32_max](#f32_max)
- [f32_min](#f32_min)
- [f64_abs](#f64_abs)
- [f64_max](#f64_max)
- [f64_min](#f64_min)
- [flush_stderr](#flush_stderr)
- [flush_stdout](#flush_stdout)
- [free](#free)
- [gc_check_leaks](#gc_check_leaks)
- [gc_collect](#gc_collect)
- [gc_disable](#gc_disable)
- [gc_enable](#gc_enable)
- [gc_get_warn_proc](#gc_get_warn_proc)
- [gc_heap_usage](#gc_heap_usage)
- [gc_is_enabled](#gc_is_enabled)
- [gc_memory_use](#gc_memory_use)
- [gc_set_warn_proc](#gc_set_warn_proc)
- [get_str_intp_u32_format](#get_str_intp_u32_format)
- [get_str_intp_u64_format](#get_str_intp_u64_format)
- [input_character](#input_character)
- [int_max](#int_max)
- [int_min](#int_min)
- [isnil](#isnil)
- [malloc](#malloc)
- [malloc_noscan](#malloc_noscan)
- [malloc_uncollectable](#malloc_uncollectable)
- [memdup](#memdup)
- [memdup_noscan](#memdup_noscan)
- [memdup_uncollectable](#memdup_uncollectable)
- [panic](#panic)
- [panic_error_number](#panic_error_number)
- [panic_lasterr](#panic_lasterr)
- [panic_n](#panic_n)
- [panic_n2](#panic_n2)
- [panic_option_not_set](#panic_option_not_set)
- [panic_result_not_set](#panic_result_not_set)
- [print](#print)
- [print_backtrace](#print_backtrace)
- [print_backtrace_skipping_top_frames](#print_backtrace_skipping_top_frames)
- [print_character](#print_character)
- [println](#println)
- [proc_pidpath](#proc_pidpath)
- [ptr_str](#ptr_str)
- [realloc_data](#realloc_data)
- [str_intp](#str_intp)
- [str_intp_g32](#str_intp_g32)
- [str_intp_g64](#str_intp_g64)
- [str_intp_rune](#str_intp_rune)
- [str_intp_sq](#str_intp_sq)
- [str_intp_sub](#str_intp_sub)
- [string_from_wide](#string_from_wide)
- [string_from_wide2](#string_from_wide2)
- [string_to_ansi_not_null_terminated](#string_to_ansi_not_null_terminated)
- [tos](#tos)
- [tos2](#tos2)
- [tos3](#tos3)
- [tos4](#tos4)
- [tos5](#tos5)
- [tos_clone](#tos_clone)
- [unbuffer_stdout](#unbuffer_stdout)
- [utf32_decode_to_buffer](#utf32_decode_to_buffer)
- [utf32_to_str](#utf32_to_str)
- [utf32_to_str_no_malloc](#utf32_to_str_no_malloc)
- [utf8_char_len](#utf8_char_len)
- [utf8_str_visible_length](#utf8_str_visible_length)
- [v_realloc](#v_realloc)
- [vcalloc](#vcalloc)
- [vcalloc_noscan](#vcalloc_noscan)
- [vmemcmp](#vmemcmp)
- [vmemcpy](#vmemcpy)
- [vmemmove](#vmemmove)
- [vmemset](#vmemset)
- [vstrlen](#vstrlen)
- [vstrlen_char](#vstrlen_char)
- [wide_to_ansi](#wide_to_ansi)
- [IError](#IError)
  - [free](#free)
  - [str](#str)
- [C.intptr_t](#C.intptr_t)
- [FnExitCb](#FnExitCb)
- [FnGC_WarnCB](#FnGC_WarnCB)
- [MessageError](#MessageError)
  - [str](#str)
  - [msg](#msg)
  - [code](#code)
  - [free](#free)
- [[]rune](#[]rune)
  - [string](#string)
- [[]string](#[]string)
  - [free](#free)
  - [join](#join)
  - [join_lines](#join_lines)
  - [sort_by_len](#sort_by_len)
  - [sort_ignore_case](#sort_ignore_case)
  - [str](#str)
- [[]u8](#[]u8)
  - [byterune](#byterune)
  - [bytestr](#bytestr)
  - [hex](#hex)
  - [utf8_to_utf32](#utf8_to_utf32)
- [bool](#bool)
  - [str](#str)
- [byte](#byte)
- [byteptr](#byteptr)
  - [str](#str)
  - [vbytes](#vbytes)
  - [vstring](#vstring)
  - [vstring_literal](#vstring_literal)
  - [vstring_literal_with_len](#vstring_literal_with_len)
  - [vstring_with_len](#vstring_with_len)
- [chan](#chan)
  - [close](#close)
  - [try_pop](#try_pop)
  - [try_push](#try_push)
- [char](#char)
  - [str](#str)
  - [vstring](#vstring)
  - [vstring_literal](#vstring_literal)
  - [vstring_literal_with_len](#vstring_literal_with_len)
  - [vstring_with_len](#vstring_with_len)
- [charptr](#charptr)
  - [str](#str)
  - [vstring](#vstring)
  - [vstring_literal](#vstring_literal)
  - [vstring_literal_with_len](#vstring_literal_with_len)
  - [vstring_with_len](#vstring_with_len)
- [f32](#f32)
  - [str](#str)
  - [strg](#strg)
  - [strsci](#strsci)
  - [strlong](#strlong)
  - [eq_epsilon](#eq_epsilon)
- [f64](#f64)
  - [str](#str)
  - [strg](#strg)
  - [strsci](#strsci)
  - [strlong](#strlong)
  - [eq_epsilon](#eq_epsilon)
- [float-literal](#float literal)
  - [str](#str)
- [i16](#i16)
  - [str](#str)
  - [hex](#hex)
  - [hex_full](#hex_full)
- [i32](#i32)
  - [str](#str)
- [i64](#i64)
  - [str](#str)
  - [hex](#hex)
  - [hex_full](#hex_full)
- [i8](#i8)
  - [str](#str)
  - [hex](#hex)
  - [hex_full](#hex_full)
- [int](#int)
  - [hex_full](#hex_full)
  - [str](#str)
  - [hex](#hex)
  - [hex2](#hex2)
- [int-literal](#int literal)
  - [str](#str)
  - [hex](#hex)
  - [hex_full](#hex_full)
- [isize](#isize)
  - [str](#str)
- [none](#none)
  - [str](#str)
- [rune](#rune)
  - [str](#str)
  - [repeat](#repeat)
  - [bytes](#bytes)
  - [length_in_bytes](#length_in_bytes)
  - [to_upper](#to_upper)
  - [to_lower](#to_lower)
  - [to_title](#to_title)
- [u16](#u16)
  - [str](#str)
  - [hex](#hex)
  - [hex_full](#hex_full)
- [u32](#u32)
  - [str](#str)
  - [hex](#hex)
  - [hex_full](#hex_full)
- [u64](#u64)
  - [str](#str)
  - [hex](#hex)
  - [hex_full](#hex_full)
- [u8](#u8)
  - [ascii_str](#ascii_str)
  - [free](#free)
  - [hex](#hex)
  - [hex_full](#hex_full)
  - [is_alnum](#is_alnum)
  - [is_bin_digit](#is_bin_digit)
  - [is_capital](#is_capital)
  - [is_digit](#is_digit)
  - [is_hex_digit](#is_hex_digit)
  - [is_letter](#is_letter)
  - [is_oct_digit](#is_oct_digit)
  - [is_space](#is_space)
  - [repeat](#repeat)
  - [str](#str)
  - [str_escaped](#str_escaped)
  - [vbytes](#vbytes)
  - [vstring](#vstring)
  - [vstring_literal](#vstring_literal)
  - [vstring_literal_with_len](#vstring_literal_with_len)
  - [vstring_with_len](#vstring_with_len)
- [usize](#usize)
  - [str](#str)
- [voidptr](#voidptr)
  - [hex_full](#hex_full)
  - [str](#str)
  - [vbytes](#vbytes)
- [ArrayFlags](#ArrayFlags)
- [AttributeKind](#AttributeKind)
- [ChanState](#ChanState)
- [StrIntpType](#StrIntpType)
  - [str](#str)
- [C.DIR](#C.DIR)
- [C.FILE](#C.FILE)
- [C.GC_stack_base](#C.GC_stack_base)
- [C.IError](#C.IError)
- [EnumData](#EnumData)
- [Error](#Error)
  - [msg](#msg)
  - [code](#code)
- [FieldData](#FieldData)
- [FunctionData](#FunctionData)
- [GCHeapUsage](#GCHeapUsage)
- [MethodParam](#MethodParam)
- [SortedMap](#SortedMap)
  - [delete](#delete)
  - [keys](#keys)
  - [free](#free)
  - [print](#print)
- [StrIntpCgenData](#StrIntpCgenData)
- [StrIntpData](#StrIntpData)
- [StrIntpMem](#StrIntpMem)
- [VAssertMetaInfo](#VAssertMetaInfo)
  - [free](#free)
- [VAttribute](#VAttribute)
- [VContext](#VContext)
- [VariantData](#VariantData)
- [WrapConfig](#WrapConfig)
- [array](#array)
  - [repeat](#repeat)
  - [repeat_to_depth](#repeat_to_depth)
  - [insert](#insert)
  - [prepend](#prepend)
  - [delete](#delete)
  - [delete_many](#delete_many)
  - [clear](#clear)
  - [reset](#reset)
  - [trim](#trim)
  - [drop](#drop)
  - [first](#first)
  - [last](#last)
  - [pop](#pop)
  - [delete_last](#delete_last)
  - [clone](#clone)
  - [clone_to_depth](#clone_to_depth)
  - [push_many](#push_many)
  - [reverse_in_place](#reverse_in_place)
  - [reverse](#reverse)
  - [free](#free)
  - [filter](#filter)
  - [any](#any)
  - [count](#count)
  - [all](#all)
  - [map](#map)
  - [sort](#sort)
  - [sorted](#sorted)
  - [sort_with_compare](#sort_with_compare)
  - [sorted_with_compare](#sorted_with_compare)
  - [contains](#contains)
  - [index](#index)
  - [grow_cap](#grow_cap)
  - [grow_len](#grow_len)
  - [pointers](#pointers)
- [map](#map)
  - [move](#move)
  - [clear](#clear)
  - [reserve](#reserve)
  - [delete](#delete)
  - [keys](#keys)
  - [values](#values)
  - [clone](#clone)
  - [free](#free)
- [string](#string)
  - [after](#after)
  - [after_char](#after_char)
  - [all_after](#all_after)
  - [all_after_first](#all_after_first)
  - [all_after_last](#all_after_last)
  - [all_before](#all_before)
  - [all_before_last](#all_before_last)
  - [before](#before)
  - [bool](#bool)
  - [bytes](#bytes)
  - [camel_to_snake](#camel_to_snake)
  - [capitalize](#capitalize)
  - [clone](#clone)
  - [compare](#compare)
  - [contains](#contains)
  - [contains_any](#contains_any)
  - [contains_any_substr](#contains_any_substr)
  - [contains_only](#contains_only)
  - [contains_u8](#contains_u8)
  - [count](#count)
  - [ends_with](#ends_with)
  - [f32](#f32)
  - [f64](#f64)
  - [fields](#fields)
  - [find_between](#find_between)
  - [free](#free)
  - [hash](#hash)
  - [hex](#hex)
  - [i16](#i16)
  - [i32](#i32)
  - [i64](#i64)
  - [i8](#i8)
  - [indent_width](#indent_width)
  - [index](#index)
  - [index_after](#index_after)
  - [index_any](#index_any)
  - [index_u8](#index_u8)
  - [int](#int)
  - [is_ascii](#is_ascii)
  - [is_bin](#is_bin)
  - [is_blank](#is_blank)
  - [is_capital](#is_capital)
  - [is_hex](#is_hex)
  - [is_int](#is_int)
  - [is_lower](#is_lower)
  - [is_oct](#is_oct)
  - [is_pure_ascii](#is_pure_ascii)
  - [is_title](#is_title)
  - [is_upper](#is_upper)
  - [last_index](#last_index)
  - [last_index_u8](#last_index_u8)
  - [len_utf8](#len_utf8)
  - [limit](#limit)
  - [match_glob](#match_glob)
  - [normalize_tabs](#normalize_tabs)
  - [parse_int](#parse_int)
  - [parse_uint](#parse_uint)
  - [repeat](#repeat)
  - [replace](#replace)
  - [replace_char](#replace_char)
  - [replace_each](#replace_each)
  - [replace_once](#replace_once)
  - [reverse](#reverse)
  - [rsplit](#rsplit)
  - [rsplit_any](#rsplit_any)
  - [rsplit_nth](#rsplit_nth)
  - [rsplit_once](#rsplit_once)
  - [runes](#runes)
  - [snake_to_camel](#snake_to_camel)
  - [split](#split)
  - [split_any](#split_any)
  - [split_by_space](#split_by_space)
  - [split_into_lines](#split_into_lines)
  - [split_n](#split_n)
  - [split_nth](#split_nth)
  - [split_once](#split_once)
  - [starts_with](#starts_with)
  - [starts_with_capital](#starts_with_capital)
  - [str](#str)
  - [strip_margin](#strip_margin)
  - [strip_margin_custom](#strip_margin_custom)
  - [substr](#substr)
  - [substr_ni](#substr_ni)
  - [substr_unsafe](#substr_unsafe)
  - [substr_with_check](#substr_with_check)
  - [title](#title)
  - [to_lower](#to_lower)
  - [to_lower_ascii](#to_lower_ascii)
  - [to_upper](#to_upper)
  - [to_upper_ascii](#to_upper_ascii)
  - [to_wide](#to_wide)
  - [trim](#trim)
  - [trim_indent](#trim_indent)
  - [trim_indexes](#trim_indexes)
  - [trim_left](#trim_left)
  - [trim_right](#trim_right)
  - [trim_space](#trim_space)
  - [trim_space_left](#trim_space_left)
  - [trim_space_right](#trim_space_right)
  - [trim_string_left](#trim_string_left)
  - [trim_string_right](#trim_string_right)
  - [u16](#u16)
  - [u32](#u32)
  - [u64](#u64)
  - [u8](#u8)
  - [u8_array](#u8_array)
  - [uncapitalize](#uncapitalize)
  - [utf32_code](#utf32_code)
  - [wrap](#wrap)

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

## C.android_print
[[Return to contents]](#Contents)

## arguments
[[Return to contents]](#Contents)

## at_exit
[[Return to contents]](#Contents)

## c_error_number_str
[[Return to contents]](#Contents)

## compare_strings
[[Return to contents]](#Contents)

## copy
[[Return to contents]](#Contents)

## cstring_to_vstring
[[Return to contents]](#Contents)

## eprint
[[Return to contents]](#Contents)

## eprintln
[[Return to contents]](#Contents)

## error
Example
```v

if ouch { return error('an error occurred') }

```

[[Return to contents]](#Contents)

## error_with_code
Example
```v

if ouch { return error_with_code('an error occurred', 1) }

```

[[Return to contents]](#Contents)

## exit
[[Return to contents]](#Contents)

## f32_abs
Example
```v

assert f32_abs(-2.0) == 2.0

```

[[Return to contents]](#Contents)

## f32_max
Example
```v

assert f32_max(2.0,3.0) == 3.0

```

[[Return to contents]](#Contents)

## f32_min
Example
```v

assert f32_min(2.0,3.0) == 2.0

```

[[Return to contents]](#Contents)

## f64_abs
Example
```v

assert f64_abs(-2.0) == f64(2.0)

```

[[Return to contents]](#Contents)

## f64_max
Example
```v

assert f64_max(2.0,3.0) == 3.0

```

[[Return to contents]](#Contents)

## f64_min
Example
```v

assert f64_min(2.0,3.0) == 2.0

```

[[Return to contents]](#Contents)

## flush_stderr
[[Return to contents]](#Contents)

## flush_stdout
[[Return to contents]](#Contents)

## free
[[Return to contents]](#Contents)

## gc_check_leaks
[[Return to contents]](#Contents)

## gc_collect
[[Return to contents]](#Contents)

## gc_disable
[[Return to contents]](#Contents)

## gc_enable
[[Return to contents]](#Contents)

## gc_get_warn_proc
[[Return to contents]](#Contents)

## gc_heap_usage
[[Return to contents]](#Contents)

## gc_is_enabled
[[Return to contents]](#Contents)

## gc_memory_use
[[Return to contents]](#Contents)

## gc_set_warn_proc
[[Return to contents]](#Contents)

## get_str_intp_u32_format
[[Return to contents]](#Contents)

## get_str_intp_u64_format
[[Return to contents]](#Contents)

## input_character
[[Return to contents]](#Contents)

## int_max
Example
```v

assert int_max(2,3) == 3

```

[[Return to contents]](#Contents)

## int_min
Example
```v

assert int_min(2,3) == 2

```

[[Return to contents]](#Contents)

## isnil
[[Return to contents]](#Contents)

## malloc
[[Return to contents]](#Contents)

## malloc_noscan
[[Return to contents]](#Contents)

## malloc_uncollectable
[[Return to contents]](#Contents)

## memdup
[[Return to contents]](#Contents)

## memdup_noscan
[[Return to contents]](#Contents)

## memdup_uncollectable
[[Return to contents]](#Contents)

## panic
[[Return to contents]](#Contents)

## panic_error_number
[[Return to contents]](#Contents)

## panic_lasterr
[[Return to contents]](#Contents)

## panic_n
[[Return to contents]](#Contents)

## panic_n2
[[Return to contents]](#Contents)

## panic_option_not_set
[[Return to contents]](#Contents)

## panic_result_not_set
[[Return to contents]](#Contents)

## print
[[Return to contents]](#Contents)

## print_backtrace
[[Return to contents]](#Contents)

## print_backtrace_skipping_top_frames
[[Return to contents]](#Contents)

## print_character
[[Return to contents]](#Contents)

## println
[[Return to contents]](#Contents)

## proc_pidpath
[[Return to contents]](#Contents)

## ptr_str
[[Return to contents]](#Contents)

## realloc_data
[[Return to contents]](#Contents)

## str_intp
[[Return to contents]](#Contents)

## str_intp_g32
[[Return to contents]](#Contents)

## str_intp_g64
[[Return to contents]](#Contents)

## str_intp_rune
[[Return to contents]](#Contents)

## str_intp_sq
[[Return to contents]](#Contents)

## str_intp_sub
[[Return to contents]](#Contents)

## string_from_wide
[[Return to contents]](#Contents)

## string_from_wide2
[[Return to contents]](#Contents)

## string_to_ansi_not_null_terminated
[[Return to contents]](#Contents)

## tos
[[Return to contents]](#Contents)

## tos2
[[Return to contents]](#Contents)

## tos3
[[Return to contents]](#Contents)

## tos4
[[Return to contents]](#Contents)

## tos5
[[Return to contents]](#Contents)

## tos_clone
[[Return to contents]](#Contents)

## unbuffer_stdout
[[Return to contents]](#Contents)

## utf32_decode_to_buffer
[[Return to contents]](#Contents)

## utf32_to_str
[[Return to contents]](#Contents)

## utf32_to_str_no_malloc
[[Return to contents]](#Contents)

## utf8_char_len
[[Return to contents]](#Contents)

## utf8_str_visible_length
[[Return to contents]](#Contents)

## v_realloc
[[Return to contents]](#Contents)

## vcalloc
[[Return to contents]](#Contents)

## vcalloc_noscan
[[Return to contents]](#Contents)

## vmemcmp
[[Return to contents]](#Contents)

## vmemcpy
[[Return to contents]](#Contents)

## vmemmove
[[Return to contents]](#Contents)

## vmemset
[[Return to contents]](#Contents)

## vstrlen
[[Return to contents]](#Contents)

## vstrlen_char
[[Return to contents]](#Contents)

## wide_to_ansi
[[Return to contents]](#Contents)

## IError
[[Return to contents]](#Contents)

## free
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## C.intptr_t
[[Return to contents]](#Contents)

## FnExitCb
[[Return to contents]](#Contents)

## FnGC_WarnCB
[[Return to contents]](#Contents)

## MessageError
## str
[[Return to contents]](#Contents)

## msg
[[Return to contents]](#Contents)

## code
[[Return to contents]](#Contents)

## free
[[Return to contents]](#Contents)

## []rune
## string
[[Return to contents]](#Contents)

## []string
## free
[[Return to contents]](#Contents)

## join
Example
```v

assert ['Hello','V'].join(' ') == 'Hello V'

```

[[Return to contents]](#Contents)

## join_lines
[[Return to contents]](#Contents)

## sort_by_len
[[Return to contents]](#Contents)

## sort_ignore_case
[[Return to contents]](#Contents)

## str
Example
```v

['a', 'b', 'c'].str() // => "['a', 'b', 'c']".

```

[[Return to contents]](#Contents)

## []u8
## byterune
[[Return to contents]](#Contents)

## bytestr
[[Return to contents]](#Contents)

## hex
[[Return to contents]](#Contents)

## utf8_to_utf32
[[Return to contents]](#Contents)

## bool
## str
Example
```v

assert (2 > 1).str() == 'true'

```

[[Return to contents]](#Contents)

## byte
[[Return to contents]](#Contents)

## byteptr
## str
[[Return to contents]](#Contents)

## vbytes
[[Return to contents]](#Contents)

## vstring
[[Return to contents]](#Contents)

## vstring_literal
[[Return to contents]](#Contents)

## vstring_literal_with_len
[[Return to contents]](#Contents)

## vstring_with_len
[[Return to contents]](#Contents)

## chan
## close
[[Return to contents]](#Contents)

## try_pop
[[Return to contents]](#Contents)

## try_push
[[Return to contents]](#Contents)

## char
## str
[[Return to contents]](#Contents)

## vstring
[[Return to contents]](#Contents)

## vstring_literal
[[Return to contents]](#Contents)

## vstring_literal_with_len
[[Return to contents]](#Contents)

## vstring_with_len
[[Return to contents]](#Contents)

## charptr
## str
[[Return to contents]](#Contents)

## vstring
[[Return to contents]](#Contents)

## vstring_literal
[[Return to contents]](#Contents)

## vstring_literal_with_len
[[Return to contents]](#Contents)

## vstring_with_len
[[Return to contents]](#Contents)

## f32
## str
[[Return to contents]](#Contents)

## strg
[[Return to contents]](#Contents)

## strsci
Example
```v

assert f32(1.234).strsci(3) == '1.234e+00'

```

[[Return to contents]](#Contents)

## strlong
[[Return to contents]](#Contents)

## eq_epsilon
Example
```v

assert f32(2.0).eq_epsilon(2.0)

```

[[Return to contents]](#Contents)

## f64
## str
[[Return to contents]](#Contents)

## strg
[[Return to contents]](#Contents)

## strsci
Example
```v

assert f64(1.234).strsci(3) == '1.234e+00'

```

[[Return to contents]](#Contents)

## strlong
Example
```v

assert f64(1.23456).strlong() == '1.23456'

```

[[Return to contents]](#Contents)

## eq_epsilon
Example
```v

assert f64(2.0).eq_epsilon(2.0)

```

[[Return to contents]](#Contents)

## float literal
## str
[[Return to contents]](#Contents)

## i16
## str
Example
```v

assert i16(-20).str() == '-20'

```

[[Return to contents]](#Contents)

## hex
Examples
```v

assert i16(2).hex() == '2'

assert i16(200).hex() == 'c8'

```

[[Return to contents]](#Contents)

## hex_full
[[Return to contents]](#Contents)

## i32
## str
[[Return to contents]](#Contents)

## i64
## str
Example
```v

assert i64(-200000).str() == '-200000'

```

[[Return to contents]](#Contents)

## hex
Examples
```v

assert i64(2).hex() == '2'

assert i64(-200).hex() == 'ffffffffffffff38'

assert i64(2021).hex() == '7e5'

```

[[Return to contents]](#Contents)

## hex_full
[[Return to contents]](#Contents)

## i8
## str
Example
```v

assert i8(-2).str() == '-2'

```

[[Return to contents]](#Contents)

## hex
Examples
```v

assert i8(8).hex() == '08'

assert i8(10).hex() == '0a'

assert i8(15).hex() == '0f'

```

[[Return to contents]](#Contents)

## hex_full
[[Return to contents]](#Contents)

## int
## hex_full
[[Return to contents]](#Contents)

## str
Example
```v

assert int(-2020).str() == '-2020'

```

[[Return to contents]](#Contents)

## hex
Examples
```v

assert int(2).hex() == '2'

assert int(200).hex() == 'c8'

```

[[Return to contents]](#Contents)

## hex2
Examples
```v

assert int(8).hex2() == '0x8'

assert int(15).hex2() == '0xf'

assert int(18).hex2() == '0x12'

```

[[Return to contents]](#Contents)

## int literal
## str
[[Return to contents]](#Contents)

## hex
[[Return to contents]](#Contents)

## hex_full
[[Return to contents]](#Contents)

## isize
## str
[[Return to contents]](#Contents)

## none
## str
[[Return to contents]](#Contents)

## rune
## str
[[Return to contents]](#Contents)

## repeat
[[Return to contents]](#Contents)

## bytes
[[Return to contents]](#Contents)

## length_in_bytes
[[Return to contents]](#Contents)

## to_upper
[[Return to contents]](#Contents)

## to_lower
[[Return to contents]](#Contents)

## to_title
[[Return to contents]](#Contents)

## u16
## str
Example
```v

assert u16(20).str() == '20'

```

[[Return to contents]](#Contents)

## hex
Examples
```v

assert u16(2).hex() == '2'

assert u16(200).hex() == 'c8'

```

[[Return to contents]](#Contents)

## hex_full
[[Return to contents]](#Contents)

## u32
## str
Example
```v

assert u32(20000).str() == '20000'

```

[[Return to contents]](#Contents)

## hex
Examples
```v

assert u32(2).hex() == '2'

assert u32(200).hex() == 'c8'

```

[[Return to contents]](#Contents)

## hex_full
[[Return to contents]](#Contents)

## u64
## str
Example
```v

assert u64(2000000).str() == '2000000'

```

[[Return to contents]](#Contents)

## hex
Examples
```v

assert u64(2).hex() == '2'

assert u64(2000).hex() == '7d0'

```

[[Return to contents]](#Contents)

## hex_full
Examples
```v

assert u64(2).hex_full() == '0000000000000002'

assert u64(255).hex_full() == '00000000000000ff'

```

[[Return to contents]](#Contents)

## u8
## ascii_str
Example
```v

assert u8(97).ascii_str() == 'a'

```

[[Return to contents]](#Contents)

## free
[[Return to contents]](#Contents)

## hex
Examples
```v

assert u8(2).hex() == '02'

assert u8(15).hex() == '0f'

assert u8(255).hex() == 'ff'

```

[[Return to contents]](#Contents)

## hex_full
[[Return to contents]](#Contents)

## is_alnum
Example
```v

assert u8(`V`).is_alnum() == true

```

[[Return to contents]](#Contents)

## is_bin_digit
Example
```v

assert u8(`0`).is_bin_digit() == true

```

[[Return to contents]](#Contents)

## is_capital
Examples
```v

assert `H`.is_capital() == true

assert `h`.is_capital() == false

```

[[Return to contents]](#Contents)

## is_digit
Example
```v

assert u8(`9`).is_digit() == true

```

[[Return to contents]](#Contents)

## is_hex_digit
Example
```v

assert u8(`F`).is_hex_digit() == true

```

[[Return to contents]](#Contents)

## is_letter
Example
```v

assert u8(`V`).is_letter() == true

```

[[Return to contents]](#Contents)

## is_oct_digit
Example
```v

assert u8(`7`).is_oct_digit() == true

```

[[Return to contents]](#Contents)

## is_space
Example
```v

assert u8(` `).is_space() == true

```

[[Return to contents]](#Contents)

## repeat
[[Return to contents]](#Contents)

## str
Example
```v

assert u8(111).str() == '111'

```

[[Return to contents]](#Contents)

## str_escaped
Example
```v

assert u8(0).str_escaped() == r'`\0`'

```

[[Return to contents]](#Contents)

## vbytes
[[Return to contents]](#Contents)

## vstring
[[Return to contents]](#Contents)

## vstring_literal
[[Return to contents]](#Contents)

## vstring_literal_with_len
[[Return to contents]](#Contents)

## vstring_with_len
[[Return to contents]](#Contents)

## usize
## str
[[Return to contents]](#Contents)

## voidptr
## hex_full
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## vbytes
[[Return to contents]](#Contents)

## ArrayFlags
[[Return to contents]](#Contents)

## AttributeKind
[[Return to contents]](#Contents)

## ChanState
[[Return to contents]](#Contents)

## StrIntpType
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## C.DIR
[[Return to contents]](#Contents)

## C.FILE
[[Return to contents]](#Contents)

## C.GC_stack_base
[[Return to contents]](#Contents)

## C.IError
[[Return to contents]](#Contents)

## EnumData
[[Return to contents]](#Contents)

## Error
[[Return to contents]](#Contents)

## msg
[[Return to contents]](#Contents)

## code
[[Return to contents]](#Contents)

## FieldData
[[Return to contents]](#Contents)

## FunctionData
[[Return to contents]](#Contents)

## GCHeapUsage
[[Return to contents]](#Contents)

## MethodParam
[[Return to contents]](#Contents)

## SortedMap
[[Return to contents]](#Contents)

## delete
[[Return to contents]](#Contents)

## keys
[[Return to contents]](#Contents)

## free
[[Return to contents]](#Contents)

## print
[[Return to contents]](#Contents)

## StrIntpCgenData
[[Return to contents]](#Contents)

## StrIntpData
[[Return to contents]](#Contents)

## StrIntpMem
[[Return to contents]](#Contents)

## VAssertMetaInfo
[[Return to contents]](#Contents)

## free
[[Return to contents]](#Contents)

## VAttribute
[[Return to contents]](#Contents)

## VContext
[[Return to contents]](#Contents)

## VariantData
[[Return to contents]](#Contents)

## WrapConfig
[[Return to contents]](#Contents)

## array
[[Return to contents]](#Contents)

## repeat
[[Return to contents]](#Contents)

## repeat_to_depth
[[Return to contents]](#Contents)

## insert
Example
```v

mut a := [1, 2, 4]
a.insert(2, 3)          // a now is [1, 2, 3, 4]
mut b := [3, 4]
b.insert(0, [1, 2])     // b now is [1, 2, 3, 4]
mut c := [[3, 4]]
c.insert(0, [1, 2])     // c now is [[1, 2], [3, 4]]

```

[[Return to contents]](#Contents)

## prepend
[[Return to contents]](#Contents)

## delete
Example
```v

mut a := ['0', '1', '2', '3', '4', '5']
a.delete(1) // a is now ['0', '2', '3', '4', '5']

```

[[Return to contents]](#Contents)

## delete_many
Example
```v

mut a := [1, 2, 3, 4, 5, 6, 7, 8, 9]
b := a[..9] // creates a `slice` of `a`, not a clone
a.delete_many(4, 3) // replaces `a` with a modified clone
dump(a) // a: [1, 2, 3, 4, 8, 9] // `a` is now different
dump(b) // b: [1, 2, 3, 4, 5, 6, 7, 8, 9] // `b` is still the same

```

[[Return to contents]](#Contents)

## clear
Example
```v

a.clear() // `a.len` is now 0

```

[[Return to contents]](#Contents)

## reset
[[Return to contents]](#Contents)

## trim
Example
```v

a.trim(3) // `a.len` is now <= 3

```

[[Return to contents]](#Contents)

## drop
Example
```v

mut a := [1,2]
a << 3
a.drop(2)
assert a == [3]
assert a.cap > a.len

```

[[Return to contents]](#Contents)

## first
[[Return to contents]](#Contents)

## last
[[Return to contents]](#Contents)

## pop
Example
```v

mut a := [1, 2, 3, 4, 5, 6, 7, 8, 9]
b := a[..9] // creates a "view" into the same memory
c := a.pop() // c == 9
a[1] = 5
dump(a) // a: [1, 5, 3, 4, 5, 6, 7, 8]
dump(b) // b: [1, 5, 3, 4, 5, 6, 7, 8, 9]

```

[[Return to contents]](#Contents)

## delete_last
[[Return to contents]](#Contents)

## clone
[[Return to contents]](#Contents)

## clone_to_depth
[[Return to contents]](#Contents)

## push_many
[[Return to contents]](#Contents)

## reverse_in_place
[[Return to contents]](#Contents)

## reverse
[[Return to contents]](#Contents)

## free
[[Return to contents]](#Contents)

## filter
Examples
```v

array.filter(it < 5) // create an array of elements less than 5

array.filter(it % 2 == 1) // create an array of only odd elements

array.filter(it.name[0] == `A`) // create an array of elements whose `name` field starts with 'A'

```

[[Return to contents]](#Contents)

## any
Examples
```v

array.any(it % 2 == 1) // will return true if any element is odd

array.any(it.name == 'Bob') // will yield `true` if any element has `.name == 'Bob'`

```

[[Return to contents]](#Contents)

## count
Example
```v

array.count(it % 2 == 1) // will return how many elements are odd

```

[[Return to contents]](#Contents)

## all
Example
```v

array.all(it % 2 == 1) // will return true if every element is odd

```

[[Return to contents]](#Contents)

## map
Example
```v

words := ['hello', 'world']
r1 := words.map(it.to_upper())
assert r1 == ['HELLO', 'WORLD']

// map can also accept anonymous functions
r2 := words.map(fn (w string) string {
	return w.to_upper()
})
assert r2 == ['HELLO', 'WORLD']

```

[[Return to contents]](#Contents)

## sort
Examples
```v

array.sort() // will sort the array in ascending order

array.sort(b < a) // will sort the array in descending order

array.sort(b.name < a.name) // will sort descending by the .name field

```

[[Return to contents]](#Contents)

## sorted
Examples
```v

assert [9,1,6,3,9].sorted() == [1,3,6,9,9]

assert [9,1,6,3,9].sorted(b < a) == [9,9,6,3,1]

```

[[Return to contents]](#Contents)

## sort_with_compare
Example
```v

fn main() {
	mut a := ['hi', '1', '5', '3']
	a.sort_with_compare(fn (a &string, b &string) int {
		if a < b {
			return -1
		}
		if a > b {
			return 1
		}
		return 0
	})
	assert a == ['1', '3', '5', 'hi']
}

```

[[Return to contents]](#Contents)

## sorted_with_compare
[[Return to contents]](#Contents)

## contains
Example
```v

[1, 2, 3].contains(4) == false

```

[[Return to contents]](#Contents)

## index
[[Return to contents]](#Contents)

## grow_cap
[[Return to contents]](#Contents)

## grow_len
[[Return to contents]](#Contents)

## pointers
[[Return to contents]](#Contents)

## map
[[Return to contents]](#Contents)

## move
[[Return to contents]](#Contents)

## clear
Example
```v

a.clear() // `a.len` and `a.key_values.len` is now 0

```

[[Return to contents]](#Contents)

## reserve
[[Return to contents]](#Contents)

## delete
[[Return to contents]](#Contents)

## keys
[[Return to contents]](#Contents)

## values
[[Return to contents]](#Contents)

## clone
[[Return to contents]](#Contents)

## free
[[Return to contents]](#Contents)

## string
[[Return to contents]](#Contents)

## after
Examples
```v

assert '23:34:45.234'.after(':') == '45.234'

assert 'abcd'.after('z') == 'abcd'

```

[[Return to contents]](#Contents)

## after_char
Examples
```v

assert '23:34:45.234'.after_char(`:`) == '34:45.234'

assert 'abcd'.after_char(`:`) == 'abcd'

```

[[Return to contents]](#Contents)

## all_after
Examples
```v

assert '23:34:45.234'.all_after('.') == '234'

assert 'abcd'.all_after('z') == 'abcd'

```

[[Return to contents]](#Contents)

## all_after_first
Examples
```v

assert '23:34:45.234'.all_after_first(':') == '34:45.234'

assert 'abcd'.all_after_first('z') == 'abcd'

```

[[Return to contents]](#Contents)

## all_after_last
Examples
```v

assert '23:34:45.234'.all_after_last(':') == '45.234'

assert 'abcd'.all_after_last('z') == 'abcd'

```

[[Return to contents]](#Contents)

## all_before
Examples
```v

assert '23:34:45.234'.all_before('.') == '23:34:45'

assert 'abcd'.all_before('.') == 'abcd'

```

[[Return to contents]](#Contents)

## all_before_last
Examples
```v

assert '23:34:45.234'.all_before_last(':') == '23:34'

assert 'abcd'.all_before_last('.') == 'abcd'

```

[[Return to contents]](#Contents)

## before
Examples
```v

assert '23:34:45.234'.before('.') == '23:34:45'

assert 'abcd'.before('.') == 'abcd'

```

[[Return to contents]](#Contents)

## bool
[[Return to contents]](#Contents)

## bytes
[[Return to contents]](#Contents)

## camel_to_snake
Examples
```v

assert 'Abcd'.camel_to_snake() == 'abcd'

assert 'aaBB'.camel_to_snake() == 'aa_bb'

assert 'BBaa'.camel_to_snake() == 'b_baa'

assert 'aa_BB'.camel_to_snake() == 'aa_bb'

```

[[Return to contents]](#Contents)

## capitalize
Example
```v

assert 'hello'.capitalize() == 'Hello'

```

[[Return to contents]](#Contents)

## clone
[[Return to contents]](#Contents)

## compare
[[Return to contents]](#Contents)

## contains
[[Return to contents]](#Contents)

## contains_any
[[Return to contents]](#Contents)

## contains_any_substr
[[Return to contents]](#Contents)

## contains_only
[[Return to contents]](#Contents)

## contains_u8
[[Return to contents]](#Contents)

## count
[[Return to contents]](#Contents)

## ends_with
[[Return to contents]](#Contents)

## f32
[[Return to contents]](#Contents)

## f64
[[Return to contents]](#Contents)

## fields
Examples
```v

assert '\t\tv = v'.fields() == ['v', '=', 'v']

assert '  sss   ssss'.fields() == ['sss', 'ssss']

```

[[Return to contents]](#Contents)

## find_between
Example
```v

assert 'hey [man] how you doin'.find_between('[', ']') == 'man'

```

[[Return to contents]](#Contents)

## free
[[Return to contents]](#Contents)

## hash
[[Return to contents]](#Contents)

## hex
[[Return to contents]](#Contents)

## i16
[[Return to contents]](#Contents)

## i32
[[Return to contents]](#Contents)

## i64
[[Return to contents]](#Contents)

## i8
[[Return to contents]](#Contents)

## indent_width
Examples
```v

assert '  v'.indent_width() == 2

assert '\t\tv'.indent_width() == 2

```

[[Return to contents]](#Contents)

## index
[[Return to contents]](#Contents)

## index_after
[[Return to contents]](#Contents)

## index_any
[[Return to contents]](#Contents)

## index_u8
[[Return to contents]](#Contents)

## int
[[Return to contents]](#Contents)

## is_ascii
[[Return to contents]](#Contents)

## is_bin
[[Return to contents]](#Contents)

## is_blank
Examples
```v

assert ' '.is_blank()

assert '\t'.is_blank()

assert 'v'.is_blank() == false

```

[[Return to contents]](#Contents)

## is_capital
Examples
```v

assert 'Hello'.is_capital() == true

assert 'HelloWorld'.is_capital() == false

```

[[Return to contents]](#Contents)

## is_hex
[[Return to contents]](#Contents)

## is_int
[[Return to contents]](#Contents)

## is_lower
Example
```v

assert 'hello developer'.is_lower() == true

```

[[Return to contents]](#Contents)

## is_oct
[[Return to contents]](#Contents)

## is_pure_ascii
[[Return to contents]](#Contents)

## is_title
Example
```v

assert 'Hello V Developer'.is_title() == true

```

[[Return to contents]](#Contents)

## is_upper
Example
```v

assert 'HELLO V'.is_upper() == true

```

[[Return to contents]](#Contents)

## last_index
[[Return to contents]](#Contents)

## last_index_u8
[[Return to contents]](#Contents)

## len_utf8
[[Return to contents]](#Contents)

## limit
[[Return to contents]](#Contents)

## match_glob
Examples
```v

assert 'ABCD'.match_glob('AB*')

assert 'ABCD'.match_glob('*D')

assert 'ABCD'.match_glob('*B*')

assert !'ABCD'.match_glob('AB')

```

[[Return to contents]](#Contents)

## normalize_tabs
Example
```v

assert '\t\tpop rax\t; pop rax'.normalize_tabs(2) == '    pop rax  ; pop rax'

```

[[Return to contents]](#Contents)

## parse_int
[[Return to contents]](#Contents)

## parse_uint
[[Return to contents]](#Contents)

## repeat
[[Return to contents]](#Contents)

## replace
[[Return to contents]](#Contents)

## replace_char
Example
```v

assert '\tHello!'.replace_char(`\t`,` `,8) == '        Hello!'

```

[[Return to contents]](#Contents)

## replace_each
Example
```v

assert 'ABCD'.replace_each(['B','C/','C','D','D','C']) == 'AC/DC'

```

[[Return to contents]](#Contents)

## replace_once
[[Return to contents]](#Contents)

## reverse
Example
```v

assert 'Hello V'.reverse() == 'V olleH'

```

[[Return to contents]](#Contents)

## rsplit
Examples
```v

assert 'A B C'.rsplit(' ') == ['C','B','A']

assert 'DEF'.rsplit('') == ['F','E','D']

```

[[Return to contents]](#Contents)

## rsplit_any
Example
```v

"first row\nsecond row".rsplit_any(" \n") == ['row', 'second', 'row', 'first']

```

[[Return to contents]](#Contents)

## rsplit_nth
[[Return to contents]](#Contents)

## rsplit_once
Example
```v

path, ext := 'file.ts.dts'.rsplit_once('.')?
assert path == 'file.ts'
assert ext == 'dts'

```

[[Return to contents]](#Contents)

## runes
[[Return to contents]](#Contents)

## snake_to_camel
Examples
```v

assert 'abcd'.snake_to_camel() == 'Abcd'

assert 'ab_cd'.snake_to_camel() == 'AbCd'

assert '_abcd'.snake_to_camel() == 'Abcd'

assert '_abcd_'.snake_to_camel() == 'Abcd'

```

[[Return to contents]](#Contents)

## split
Examples
```v

assert 'A B C'.split(' ') == ['A','B','C']

assert 'DEF'.split('') == ['D','E','F']

```

[[Return to contents]](#Contents)

## split_any
Example
```v

"first row\nsecond row".split_any(" \n") == ['first', 'row', 'second', 'row']

```

[[Return to contents]](#Contents)

## split_by_space
[[Return to contents]](#Contents)

## split_into_lines
[[Return to contents]](#Contents)

## split_n
[[Return to contents]](#Contents)

## split_nth
[[Return to contents]](#Contents)

## split_once
Example
```v

path, ext := 'file.ts.dts'.split_once('.')?
assert path == 'file'
assert ext == 'ts.dts'

```

[[Return to contents]](#Contents)

## starts_with
[[Return to contents]](#Contents)

## starts_with_capital
Examples
```v

assert 'Hello'.starts_with_capital() == true

assert 'Hello. World.'.starts_with_capital() == true

```

[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## strip_margin
Example
```v

st := 'Hello there,
       |  this is a string,
       |  Everything before the first | is removed'.strip_margin()

assert st == 'Hello there,
  this is a string,
  Everything before the first | is removed'

```

[[Return to contents]](#Contents)

## strip_margin_custom
[[Return to contents]](#Contents)

## substr
Example
```v

assert 'ABCD'.substr(1,3) == 'BC'

```

[[Return to contents]](#Contents)

## substr_ni
[[Return to contents]](#Contents)

## substr_unsafe
[[Return to contents]](#Contents)

## substr_with_check
[[Return to contents]](#Contents)

## title
Example
```v

assert 'hello v developer'.title() == 'Hello V Developer'

```

[[Return to contents]](#Contents)

## to_lower
Example
```v

assert 'Hello V'.to_lower() == 'hello v'

```

[[Return to contents]](#Contents)

## to_lower_ascii
[[Return to contents]](#Contents)

## to_upper
Example
```v

assert 'Hello V'.to_upper() == 'HELLO V'

```

[[Return to contents]](#Contents)

## to_upper_ascii
[[Return to contents]](#Contents)

## to_wide
[[Return to contents]](#Contents)

## trim
Example
```v

assert ' ffHello V ffff'.trim(' f') == 'Hello V'

```

[[Return to contents]](#Contents)

## trim_indent
Example
```v

st := '
     Hello there,
     this is a string,
     all the leading indents are removed
     and also the first and the last lines if they are blank
'.trim_indent()

assert st == 'Hello there,
this is a string,
all the leading indents are removed
and also the first and the last lines if they are blank'

```

[[Return to contents]](#Contents)

## trim_indexes
Example
```v

left, right := '-hi-'.trim_indexes('-')

```

[[Return to contents]](#Contents)

## trim_left
Example
```v

assert 'd Hello V developer'.trim_left(' d') == 'Hello V developer'

```

[[Return to contents]](#Contents)

## trim_right
Example
```v

assert ' Hello V d'.trim_right(' d') == ' Hello V'

```

[[Return to contents]](#Contents)

## trim_space
Example
```v

assert ' Hello V '.trim_space() == 'Hello V'

```

[[Return to contents]](#Contents)

## trim_space_left
Example
```v

assert ' Hello V '.trim_space_left() == 'Hello V '

```

[[Return to contents]](#Contents)

## trim_space_right
Example
```v

assert ' Hello V '.trim_space_right() == ' Hello V'

```

[[Return to contents]](#Contents)

## trim_string_left
Example
```v

assert 'WorldHello V'.trim_string_left('World') == 'Hello V'

```

[[Return to contents]](#Contents)

## trim_string_right
Example
```v

assert 'Hello VWorld'.trim_string_right('World') == 'Hello V'

```

[[Return to contents]](#Contents)

## u16
[[Return to contents]](#Contents)

## u32
[[Return to contents]](#Contents)

## u64
[[Return to contents]](#Contents)

## u8
[[Return to contents]](#Contents)

## u8_array
[[Return to contents]](#Contents)

## uncapitalize
Example
```v

assert 'Hello, Bob!'.uncapitalize() == 'hello, Bob!'

```

[[Return to contents]](#Contents)

## utf32_code
[[Return to contents]](#Contents)

## wrap
Example
```v

`assert 'Hello, my name is Carl and I am a delivery'.wrap(width: 20) == 'Hello, my name is\nCarl and I am a\ndelivery'`

```

[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:55
