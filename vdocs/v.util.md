# module v.util


## Contents
- [Constants](#Constants)
- [args_quote_paths](#args_quote_paths)
- [bold](#bold)
- [cached_file2sourcelines](#cached_file2sourcelines)
- [cached_read_source_file](#cached_read_source_file)
- [cescaped_path](#cescaped_path)
- [check_module_is_installed](#check_module_is_installed)
- [color](#color)
- [contains_capital](#contains_capital)
- [ensure_modules_for_all_tools_are_installed](#ensure_modules_for_all_tools_are_installed)
- [find_all_v_files](#find_all_v_files)
- [formatted_error](#formatted_error)
- [free_caches](#free_caches)
- [get_build_time](#get_build_time)
- [get_timers](#get_timers)
- [get_vtmp_folder](#get_vtmp_folder)
- [good_type_name](#good_type_name)
- [highlight_suggestion](#highlight_suggestion)
- [is_escape_sequence](#is_escape_sequence)
- [is_func_char](#is_func_char)
- [is_generic_type_name](#is_generic_type_name)
- [is_name_char](#is_name_char)
- [join_env_vflags_and_os_args](#join_env_vflags_and_os_args)
- [launch_tool](#launch_tool)
- [module_is_builtin](#module_is_builtin)
- [new_error_manager](#new_error_manager)
- [new_suggestion](#new_suggestion)
- [new_surrounder](#new_surrounder)
- [new_timers](#new_timers)
- [no_cur_mod](#no_cur_mod)
- [no_dots](#no_dots)
- [path_of_executable](#path_of_executable)
- [path_styled_for_error_messages](#path_styled_for_error_messages)
- [prepare_tool_when_needed](#prepare_tool_when_needed)
- [qualify_import](#qualify_import)
- [qualify_module](#qualify_module)
- [quote_path](#quote_path)
- [read_file](#read_file)
- [recompile_file](#recompile_file)
- [replace_op](#replace_op)
- [resolve_d_value](#resolve_d_value)
- [resolve_env_value](#resolve_env_value)
- [resolve_vmodroot](#resolve_vmodroot)
- [set_source_for_path](#set_source_for_path)
- [set_vroot_folder](#set_vroot_folder)
- [short_module_name](#short_module_name)
- [should_bundle_module](#should_bundle_module)
- [should_recompile_tool](#should_recompile_tool)
- [show_compiler_message](#show_compiler_message)
- [skip_bom](#skip_bom)
- [smart_quote](#smart_quote)
- [source_file_context](#source_file_context)
- [strip_main_name](#strip_main_name)
- [strip_mod_name](#strip_mod_name)
- [tabs](#tabs)
- [timing_measure](#timing_measure)
- [timing_measure_cumulative](#timing_measure_cumulative)
- [timing_set_should_print](#timing_set_should_print)
- [timing_start](#timing_start)
- [verror](#verror)
- [vlines_escape_path](#vlines_escape_path)
- [CalculateSuggestionSimilarityFN](#CalculateSuggestionSimilarityFN)
- [Suggestion](#Suggestion)
  - [add](#add)
  - [add_many](#add_many)
  - [sort](#sort)
  - [say](#say)
- [EManager](#EManager)
  - [set_support_color](#set_support_color)
- [SuggestionParams](#SuggestionParams)
- [Surrounder](#Surrounder)
  - [add](#add)
  - [before](#before)
  - [after](#after)
  - [builder_write_befores](#builder_write_befores)
  - [builder_write_afters](#builder_write_afters)
  - [free](#free)
- [TimerParams](#TimerParams)
- [Timers](#Timers)
  - [start](#start)
  - [measure](#measure)
  - [measure_cumulative](#measure_cumulative)
  - [measure_pause](#measure_pause)
  - [measure_resume](#measure_resume)
  - [message](#message)
  - [show](#show)
  - [show_if_exists](#show_if_exists)
  - [show_remaining](#show_remaining)
  - [dump_all](#dump_all)

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

## args_quote_paths
[[Return to contents]](#Contents)

## bold
[[Return to contents]](#Contents)

## cached_file2sourcelines
[[Return to contents]](#Contents)

## cached_read_source_file
[[Return to contents]](#Contents)

## cescaped_path
[[Return to contents]](#Contents)

## check_module_is_installed
[[Return to contents]](#Contents)

## color
[[Return to contents]](#Contents)

## contains_capital
[[Return to contents]](#Contents)

## ensure_modules_for_all_tools_are_installed
[[Return to contents]](#Contents)

## find_all_v_files
[[Return to contents]](#Contents)

## formatted_error
[[Return to contents]](#Contents)

## free_caches
[[Return to contents]](#Contents)

## get_build_time
[[Return to contents]](#Contents)

## get_timers
[[Return to contents]](#Contents)

## get_vtmp_folder
[[Return to contents]](#Contents)

## good_type_name
[[Return to contents]](#Contents)

## highlight_suggestion
[[Return to contents]](#Contents)

## is_escape_sequence
[[Return to contents]](#Contents)

## is_func_char
[[Return to contents]](#Contents)

## is_generic_type_name
[[Return to contents]](#Contents)

## is_name_char
[[Return to contents]](#Contents)

## join_env_vflags_and_os_args
[[Return to contents]](#Contents)

## launch_tool
[[Return to contents]](#Contents)

## module_is_builtin
[[Return to contents]](#Contents)

## new_error_manager
[[Return to contents]](#Contents)

## new_suggestion
[[Return to contents]](#Contents)

## new_surrounder
[[Return to contents]](#Contents)

## new_timers
[[Return to contents]](#Contents)

## no_cur_mod
[[Return to contents]](#Contents)

## no_dots
[[Return to contents]](#Contents)

## path_of_executable
[[Return to contents]](#Contents)

## path_styled_for_error_messages
[[Return to contents]](#Contents)

## prepare_tool_when_needed
[[Return to contents]](#Contents)

## qualify_import
[[Return to contents]](#Contents)

## qualify_module
[[Return to contents]](#Contents)

## quote_path
[[Return to contents]](#Contents)

## read_file
[[Return to contents]](#Contents)

## recompile_file
[[Return to contents]](#Contents)

## replace_op
[[Return to contents]](#Contents)

## resolve_d_value
[[Return to contents]](#Contents)

## resolve_env_value
[[Return to contents]](#Contents)

## resolve_vmodroot
[[Return to contents]](#Contents)

## set_source_for_path
[[Return to contents]](#Contents)

## set_vroot_folder
[[Return to contents]](#Contents)

## short_module_name
[[Return to contents]](#Contents)

## should_bundle_module
[[Return to contents]](#Contents)

## should_recompile_tool
[[Return to contents]](#Contents)

## show_compiler_message
[[Return to contents]](#Contents)

## skip_bom
[[Return to contents]](#Contents)

## smart_quote
[[Return to contents]](#Contents)

## source_file_context
[[Return to contents]](#Contents)

## strip_main_name
[[Return to contents]](#Contents)

## strip_mod_name
[[Return to contents]](#Contents)

## tabs
[[Return to contents]](#Contents)

## timing_measure
[[Return to contents]](#Contents)

## timing_measure_cumulative
[[Return to contents]](#Contents)

## timing_set_should_print
[[Return to contents]](#Contents)

## timing_start
[[Return to contents]](#Contents)

## verror
[[Return to contents]](#Contents)

## vlines_escape_path
[[Return to contents]](#Contents)

## CalculateSuggestionSimilarityFN
[[Return to contents]](#Contents)

## Suggestion
## add
[[Return to contents]](#Contents)

## add_many
[[Return to contents]](#Contents)

## sort
[[Return to contents]](#Contents)

## say
[[Return to contents]](#Contents)

## EManager
[[Return to contents]](#Contents)

## set_support_color
[[Return to contents]](#Contents)

## SuggestionParams
[[Return to contents]](#Contents)

## Surrounder
[[Return to contents]](#Contents)

## add
[[Return to contents]](#Contents)

## before
[[Return to contents]](#Contents)

## after
[[Return to contents]](#Contents)

## builder_write_befores
[[Return to contents]](#Contents)

## builder_write_afters
[[Return to contents]](#Contents)

## free
[[Return to contents]](#Contents)

## TimerParams
[[Return to contents]](#Contents)

## Timers
[[Return to contents]](#Contents)

## start
[[Return to contents]](#Contents)

## measure
[[Return to contents]](#Contents)

## measure_cumulative
[[Return to contents]](#Contents)

## measure_pause
[[Return to contents]](#Contents)

## measure_resume
[[Return to contents]](#Contents)

## message
[[Return to contents]](#Contents)

## show
[[Return to contents]](#Contents)

## show_if_exists
[[Return to contents]](#Contents)

## show_remaining
[[Return to contents]](#Contents)

## dump_all
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:56
