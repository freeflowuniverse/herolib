# module v.gen.c


## Contents
- [Constants](#Constants)
- [fix_reset_dbg_line](#fix_reset_dbg_line)
- [gen](#gen)
- [get_guarded_include_text](#get_guarded_include_text)
- [Gen](#Gen)
  - [contains_ptr](#contains_ptr)
  - [current_tmp_var](#current_tmp_var)
  - [filter_only_matching_fn_names](#filter_only_matching_fn_names)
  - [finish](#finish)
  - [free_builders](#free_builders)
  - [gen_c_android_sokol_main](#gen_c_android_sokol_main)
  - [gen_c_main](#gen_c_main)
  - [gen_c_main_footer](#gen_c_main_footer)
  - [gen_c_main_for_tests](#gen_c_main_for_tests)
  - [gen_c_main_profile_hook](#gen_c_main_profile_hook)
  - [gen_c_main_trace_calls_hook](#gen_c_main_trace_calls_hook)
  - [gen_failing_error_propagation_for_test_fn](#gen_failing_error_propagation_for_test_fn)
  - [gen_failing_return_error_for_test_fn](#gen_failing_return_error_for_test_fn)
  - [gen_file](#gen_file)
  - [gen_vprint_profile_stats](#gen_vprint_profile_stats)
  - [get_array_depth](#get_array_depth)
  - [get_sumtype_variant_name](#get_sumtype_variant_name)
  - [get_sumtype_variant_type_name](#get_sumtype_variant_type_name)
  - [hashes](#hashes)
  - [init](#init)
  - [new_global_tmp_var](#new_global_tmp_var)
  - [new_tmp_declaration_name](#new_tmp_declaration_name)
  - [new_tmp_var](#new_tmp_var)
  - [reset_tmp_count](#reset_tmp_count)
  - [ret_styp](#ret_styp)
  - [write_alias_typesymbol_declaration](#write_alias_typesymbol_declaration)
  - [write_array_fixed_return_types](#write_array_fixed_return_types)
  - [write_fn_typesymbol_declaration](#write_fn_typesymbol_declaration)
  - [write_interface_typedef](#write_interface_typedef)
  - [write_interface_typesymbol_declaration](#write_interface_typesymbol_declaration)
  - [write_multi_return_types](#write_multi_return_types)
  - [write_tests_definitions](#write_tests_definitions)
  - [write_typedef_types](#write_typedef_types)
  - [write_typeof_functions](#write_typeof_functions)
- [GenOutput](#GenOutput)
- [ProfileCounterMeta](#ProfileCounterMeta)
- [TraceLastLinesParams](#TraceLastLinesParams)

## Constants
[[Return to contents]](#Contents)

## fix_reset_dbg_line
[[Return to contents]](#Contents)

## gen
[[Return to contents]](#Contents)

## get_guarded_include_text
[[Return to contents]](#Contents)

## Gen
[[Return to contents]](#Contents)

## contains_ptr
[[Return to contents]](#Contents)

## current_tmp_var
[[Return to contents]](#Contents)

## filter_only_matching_fn_names
[[Return to contents]](#Contents)

## finish
[[Return to contents]](#Contents)

## free_builders
[[Return to contents]](#Contents)

## gen_c_android_sokol_main
[[Return to contents]](#Contents)

## gen_c_main
[[Return to contents]](#Contents)

## gen_c_main_footer
[[Return to contents]](#Contents)

## gen_c_main_for_tests
[[Return to contents]](#Contents)

## gen_c_main_profile_hook
[[Return to contents]](#Contents)

## gen_c_main_trace_calls_hook
[[Return to contents]](#Contents)

## gen_failing_error_propagation_for_test_fn
[[Return to contents]](#Contents)

## gen_failing_return_error_for_test_fn
[[Return to contents]](#Contents)

## gen_file
[[Return to contents]](#Contents)

## gen_vprint_profile_stats
[[Return to contents]](#Contents)

## get_array_depth
[[Return to contents]](#Contents)

## get_sumtype_variant_name
[[Return to contents]](#Contents)

## get_sumtype_variant_type_name
[[Return to contents]](#Contents)

## hashes
[[Return to contents]](#Contents)

## init
[[Return to contents]](#Contents)

## new_global_tmp_var
[[Return to contents]](#Contents)

## new_tmp_declaration_name
[[Return to contents]](#Contents)

## new_tmp_var
[[Return to contents]](#Contents)

## reset_tmp_count
[[Return to contents]](#Contents)

## ret_styp
[[Return to contents]](#Contents)

## write_alias_typesymbol_declaration
[[Return to contents]](#Contents)

## write_array_fixed_return_types
[[Return to contents]](#Contents)

## write_fn_typesymbol_declaration
[[Return to contents]](#Contents)

## write_interface_typedef
[[Return to contents]](#Contents)

## write_interface_typesymbol_declaration
[[Return to contents]](#Contents)

## write_multi_return_types
[[Return to contents]](#Contents)

## write_tests_definitions
[[Return to contents]](#Contents)

## write_typedef_types
[[Return to contents]](#Contents)

## write_typeof_functions
[[Return to contents]](#Contents)

## GenOutput
[[Return to contents]](#Contents)

## ProfileCounterMeta
[[Return to contents]](#Contents)

## TraceLastLinesParams
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:56
