# module v.gen.golang


## Contents
- [gen](#gen)
- [AttrsOptions](#AttrsOptions)
- [Gen](#Gen)
  - [alias_type_decl](#alias_type_decl)
  - [anon_fn](#anon_fn)
  - [array_decompose](#array_decompose)
  - [array_init](#array_init)
  - [as_cast](#as_cast)
  - [assert_stmt](#assert_stmt)
  - [assign_stmt](#assign_stmt)
  - [assoc](#assoc)
  - [at_expr](#at_expr)
  - [attrs](#attrs)
  - [block](#block)
  - [branch_stmt](#branch_stmt)
  - [call_args](#call_args)
  - [call_expr](#call_expr)
  - [cast_expr](#cast_expr)
  - [chan_init](#chan_init)
  - [char_literal](#char_literal)
  - [comptime_call](#comptime_call)
  - [comptime_for](#comptime_for)
  - [comptime_selector](#comptime_selector)
  - [concat_expr](#concat_expr)
  - [const_decl](#const_decl)
  - [defer_stmt](#defer_stmt)
  - [dump_expr](#dump_expr)
  - [enum_decl](#enum_decl)
  - [enum_val](#enum_val)
  - [error](#error)
  - [expr](#expr)
  - [expr_stmt](#expr_stmt)
  - [fn_decl](#fn_decl)
  - [fn_type_decl](#fn_type_decl)
  - [for_c_stmt](#for_c_stmt)
  - [for_in_stmt](#for_in_stmt)
  - [for_stmt](#for_stmt)
  - [global_decl](#global_decl)
  - [go_expr](#go_expr)
  - [goto_label](#goto_label)
  - [goto_stmt](#goto_stmt)
  - [hash_stmt](#hash_stmt)
  - [ident](#ident)
  - [if_expr](#if_expr)
  - [if_guard_expr](#if_guard_expr)
  - [imp_stmt_str](#imp_stmt_str)
  - [imports](#imports)
  - [index_expr](#index_expr)
  - [infix_expr](#infix_expr)
  - [interface_decl](#interface_decl)
  - [interface_field](#interface_field)
  - [interface_method](#interface_method)
  - [is_ref_type](#is_ref_type)
  - [likely](#likely)
  - [lock_expr](#lock_expr)
  - [map_init](#map_init)
  - [mark_import_as_used](#mark_import_as_used)
  - [mark_types_import_as_used](#mark_types_import_as_used)
  - [match_expr](#match_expr)
  - [module_stmt](#module_stmt)
  - [no_cur_mod](#no_cur_mod)
  - [node_str](#node_str)
  - [offset_of](#offset_of)
  - [or_expr](#or_expr)
  - [par_expr](#par_expr)
  - [postfix_expr](#postfix_expr)
  - [prefix_expr](#prefix_expr)
  - [process_file_imports](#process_file_imports)
  - [range_expr](#range_expr)
  - [remove_new_line](#remove_new_line)
  - [return_stmt](#return_stmt)
  - [select_expr](#select_expr)
  - [selector_expr](#selector_expr)
  - [set_current_module_name](#set_current_module_name)
  - [short_module](#short_module)
  - [single_line_attrs](#single_line_attrs)
  - [size_of](#size_of)
  - [spawn_expr](#spawn_expr)
  - [sql_expr](#sql_expr)
  - [sql_stmt](#sql_stmt)
  - [sql_stmt_line](#sql_stmt_line)
  - [stmt](#stmt)
  - [stmts](#stmts)
  - [string_inter_literal](#string_inter_literal)
  - [string_literal](#string_literal)
  - [struct_decl](#struct_decl)
  - [struct_init](#struct_init)
  - [sum_type_decl](#sum_type_decl)
  - [type_decl](#type_decl)
  - [type_expr](#type_expr)
  - [type_of](#type_of)
  - [unsafe_expr](#unsafe_expr)
  - [wrap_infix](#wrap_infix)
  - [wrap_long_line](#wrap_long_line)
  - [write](#write)
  - [writeln](#writeln)
- [RemoveNewLineConfig](#RemoveNewLineConfig)

## gen
[[Return to contents]](#Contents)

## AttrsOptions
[[Return to contents]](#Contents)

## Gen
[[Return to contents]](#Contents)

## alias_type_decl
[[Return to contents]](#Contents)

## anon_fn
[[Return to contents]](#Contents)

## array_decompose
[[Return to contents]](#Contents)

## array_init
[[Return to contents]](#Contents)

## as_cast
[[Return to contents]](#Contents)

## assert_stmt
[[Return to contents]](#Contents)

## assign_stmt
[[Return to contents]](#Contents)

## assoc
[[Return to contents]](#Contents)

## at_expr
[[Return to contents]](#Contents)

## attrs
[[Return to contents]](#Contents)

## block
[[Return to contents]](#Contents)

## branch_stmt
[[Return to contents]](#Contents)

## call_args
[[Return to contents]](#Contents)

## call_expr
[[Return to contents]](#Contents)

## cast_expr
[[Return to contents]](#Contents)

## chan_init
[[Return to contents]](#Contents)

## char_literal
[[Return to contents]](#Contents)

## comptime_call
[[Return to contents]](#Contents)

## comptime_for
[[Return to contents]](#Contents)

## comptime_selector
[[Return to contents]](#Contents)

## concat_expr
[[Return to contents]](#Contents)

## const_decl
[[Return to contents]](#Contents)

## defer_stmt
[[Return to contents]](#Contents)

## dump_expr
[[Return to contents]](#Contents)

## enum_decl
[[Return to contents]](#Contents)

## enum_val
[[Return to contents]](#Contents)

## error
[[Return to contents]](#Contents)

## expr
[[Return to contents]](#Contents)

## expr_stmt
[[Return to contents]](#Contents)

## fn_decl
[[Return to contents]](#Contents)

## fn_type_decl
[[Return to contents]](#Contents)

## for_c_stmt
[[Return to contents]](#Contents)

## for_in_stmt
[[Return to contents]](#Contents)

## for_stmt
[[Return to contents]](#Contents)

## global_decl
[[Return to contents]](#Contents)

## go_expr
[[Return to contents]](#Contents)

## goto_label
[[Return to contents]](#Contents)

## goto_stmt
[[Return to contents]](#Contents)

## hash_stmt
[[Return to contents]](#Contents)

## ident
[[Return to contents]](#Contents)

## if_expr
[[Return to contents]](#Contents)

## if_guard_expr
[[Return to contents]](#Contents)

## imp_stmt_str
[[Return to contents]](#Contents)

## imports
[[Return to contents]](#Contents)

## index_expr
[[Return to contents]](#Contents)

## infix_expr
[[Return to contents]](#Contents)

## interface_decl
[[Return to contents]](#Contents)

## interface_field
[[Return to contents]](#Contents)

## interface_method
[[Return to contents]](#Contents)

## is_ref_type
[[Return to contents]](#Contents)

## likely
[[Return to contents]](#Contents)

## lock_expr
[[Return to contents]](#Contents)

## map_init
[[Return to contents]](#Contents)

## mark_import_as_used
[[Return to contents]](#Contents)

## mark_types_import_as_used
[[Return to contents]](#Contents)

## match_expr
[[Return to contents]](#Contents)

## module_stmt
[[Return to contents]](#Contents)

## no_cur_mod
[[Return to contents]](#Contents)

## node_str
[[Return to contents]](#Contents)

## offset_of
[[Return to contents]](#Contents)

## or_expr
[[Return to contents]](#Contents)

## par_expr
[[Return to contents]](#Contents)

## postfix_expr
[[Return to contents]](#Contents)

## prefix_expr
[[Return to contents]](#Contents)

## process_file_imports
[[Return to contents]](#Contents)

## range_expr
[[Return to contents]](#Contents)

## remove_new_line
[[Return to contents]](#Contents)

## return_stmt
[[Return to contents]](#Contents)

## select_expr
[[Return to contents]](#Contents)

## selector_expr
[[Return to contents]](#Contents)

## set_current_module_name
[[Return to contents]](#Contents)

## short_module
[[Return to contents]](#Contents)

## single_line_attrs
[[Return to contents]](#Contents)

## size_of
[[Return to contents]](#Contents)

## spawn_expr
[[Return to contents]](#Contents)

## sql_expr
[[Return to contents]](#Contents)

## sql_stmt
[[Return to contents]](#Contents)

## sql_stmt_line
[[Return to contents]](#Contents)

## stmt
[[Return to contents]](#Contents)

## stmts
[[Return to contents]](#Contents)

## string_inter_literal
[[Return to contents]](#Contents)

## string_literal
[[Return to contents]](#Contents)

## struct_decl
[[Return to contents]](#Contents)

## struct_init
[[Return to contents]](#Contents)

## sum_type_decl
[[Return to contents]](#Contents)

## type_decl
[[Return to contents]](#Contents)

## type_expr
[[Return to contents]](#Contents)

## type_of
[[Return to contents]](#Contents)

## unsafe_expr
[[Return to contents]](#Contents)

## wrap_infix
[[Return to contents]](#Contents)

## wrap_long_line
[[Return to contents]](#Contents)

## write
[[Return to contents]](#Contents)

## writeln
[[Return to contents]](#Contents)

## RemoveNewLineConfig
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:56
