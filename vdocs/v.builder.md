# module v.builder


## Contents
- [compile](#compile)
- [module_path](#module_path)
- [new_builder](#new_builder)
- [verror](#verror)
- [FnBackend](#FnBackend)
- [CC](#CC)
- [Builder](#Builder)
  - [cc](#cc)
  - [dump_c_options](#dump_c_options)
  - [dump_defines](#dump_defines)
  - [dump_files](#dump_files)
  - [dump_modules](#dump_modules)
  - [error_with_pos](#error_with_pos)
  - [find_invalidated_modules_by_files](#find_invalidated_modules_by_files)
  - [find_module_path](#find_module_path)
  - [front_and_middle_stages](#front_and_middle_stages)
  - [front_stages](#front_stages)
  - [get_builtin_files](#get_builtin_files)
  - [get_compile_args](#get_compile_args)
  - [get_linker_args](#get_linker_args)
  - [get_user_files](#get_user_files)
  - [get_vtmp_filename](#get_vtmp_filename)
  - [import_graph](#import_graph)
  - [info](#info)
  - [interpret_text](#interpret_text)
  - [log](#log)
  - [middle_stages](#middle_stages)
  - [parse_imports](#parse_imports)
  - [print_warnings_and_errors](#print_warnings_and_errors)
  - [quote_compiler_name](#quote_compiler_name)
  - [rebuild](#rebuild)
  - [rebuild_modules](#rebuild_modules)
  - [resolve_deps](#resolve_deps)
  - [set_module_lookup_paths](#set_module_lookup_paths)
  - [should_rebuild](#should_rebuild)
  - [show_total_warns_and_errors_stats](#show_total_warns_and_errors_stats)
  - [v_files_from_dir](#v_files_from_dir)
- [CcompilerOptions](#CcompilerOptions)

## compile
[[Return to contents]](#Contents)

## module_path
[[Return to contents]](#Contents)

## new_builder
[[Return to contents]](#Contents)

## verror
[[Return to contents]](#Contents)

## FnBackend
[[Return to contents]](#Contents)

## CC
[[Return to contents]](#Contents)

## Builder
[[Return to contents]](#Contents)

## cc
[[Return to contents]](#Contents)

## dump_c_options
[[Return to contents]](#Contents)

## dump_defines
[[Return to contents]](#Contents)

## dump_files
[[Return to contents]](#Contents)

## dump_modules
[[Return to contents]](#Contents)

## error_with_pos
[[Return to contents]](#Contents)

## find_invalidated_modules_by_files
[[Return to contents]](#Contents)

## find_module_path
[[Return to contents]](#Contents)

## front_and_middle_stages
[[Return to contents]](#Contents)

## front_stages
[[Return to contents]](#Contents)

## get_builtin_files
[[Return to contents]](#Contents)

## get_compile_args
[[Return to contents]](#Contents)

## get_linker_args
[[Return to contents]](#Contents)

## get_user_files
[[Return to contents]](#Contents)

## get_vtmp_filename
[[Return to contents]](#Contents)

## import_graph
[[Return to contents]](#Contents)

## info
[[Return to contents]](#Contents)

## interpret_text
[[Return to contents]](#Contents)

## log
[[Return to contents]](#Contents)

## middle_stages
[[Return to contents]](#Contents)

## parse_imports
[[Return to contents]](#Contents)

## print_warnings_and_errors
[[Return to contents]](#Contents)

## quote_compiler_name
[[Return to contents]](#Contents)

## rebuild
[[Return to contents]](#Contents)

## rebuild_modules
[[Return to contents]](#Contents)

## resolve_deps
[[Return to contents]](#Contents)

## set_module_lookup_paths
[[Return to contents]](#Contents)

## should_rebuild
[[Return to contents]](#Contents)

## show_total_warns_and_errors_stats
[[Return to contents]](#Contents)

## v_files_from_dir
[[Return to contents]](#Contents)

## CcompilerOptions
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:55
