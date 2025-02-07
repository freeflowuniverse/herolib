# module v.gen.wasm


## Contents
- [calc_align](#calc_align)
- [calc_padding](#calc_padding)
- [gen](#gen)
- [log2](#log2)
- [unpack_literal_int](#unpack_literal_int)
- [Gen](#Gen)
  - [as_numtype](#as_numtype)
  - [asm_call](#asm_call)
  - [asm_global_get_or_set](#asm_global_get_or_set)
  - [asm_literal_arg](#asm_literal_arg)
  - [asm_load_or_store](#asm_load_or_store)
  - [asm_local_get_set_or_tee](#asm_local_get_set_or_tee)
  - [asm_parse_align_offset](#asm_parse_align_offset)
  - [asm_stmt](#asm_stmt)
  - [asm_template](#asm_template)
  - [bare_function_end](#bare_function_end)
  - [bare_function_frame](#bare_function_frame)
  - [bp](#bp)
  - [calculate_enum_fields](#calculate_enum_fields)
  - [call_expr](#call_expr)
  - [cast](#cast)
  - [comptime_cond](#comptime_cond)
  - [comptime_if_expr](#comptime_if_expr)
  - [comptime_if_to_ifdef](#comptime_if_to_ifdef)
  - [dbg_type_name](#dbg_type_name)
  - [expr](#expr)
  - [expr_stmt](#expr_stmt)
  - [expr_stmts](#expr_stmts)
  - [expr_with_cast](#expr_with_cast)
  - [field_offset](#field_offset)
  - [file_pos](#file_pos)
  - [fn_decl](#fn_decl)
  - [fn_external_import](#fn_external_import)
  - [get](#get)
  - [get_field_offset](#get_field_offset)
  - [get_ns_plus_name](#get_ns_plus_name)
  - [get_var_from_expr](#get_var_from_expr)
  - [get_var_from_ident](#get_var_from_ident)
  - [get_var_or_make_from_expr](#get_var_or_make_from_expr)
  - [get_wasm_type](#get_wasm_type)
  - [get_wasm_type_int_literal](#get_wasm_type_int_literal)
  - [handle_ptr_arithmetic](#handle_ptr_arithmetic)
  - [housekeeping](#housekeeping)
  - [hp](#hp)
  - [if_branch](#if_branch)
  - [if_expr](#if_expr)
  - [infix_expr](#infix_expr)
  - [infix_from_typ](#infix_from_typ)
  - [is_param](#is_param)
  - [is_param_type](#is_param_type)
  - [is_pure_type](#is_pure_type)
  - [literal](#literal)
  - [literal_to_constant_expression](#literal_to_constant_expression)
  - [literalint](#literalint)
  - [load](#load)
  - [load_field](#load_field)
  - [make_vinit](#make_vinit)
  - [mov](#mov)
  - [new_global](#new_global)
  - [new_local](#new_local)
  - [offset](#offset)
  - [prefix_expr](#prefix_expr)
  - [ref](#ref)
  - [ref_ignore_offset](#ref_ignore_offset)
  - [rvar_expr_stmts](#rvar_expr_stmts)
  - [set](#set)
  - [set_prepare](#set_prepare)
  - [set_set](#set_set)
  - [set_with_expr](#set_with_expr)
  - [set_with_multi_expr](#set_with_multi_expr)
  - [sp](#sp)
  - [store](#store)
  - [store_field](#store_field)
  - [tee](#tee)
  - [toplevel_stmt](#toplevel_stmt)
  - [toplevel_stmts](#toplevel_stmts)
  - [unpack_type](#unpack_type)
  - [v_error](#v_error)
  - [w_error](#w_error)
  - [warning](#warning)
  - [zero_fill](#zero_fill)
- [LoopBreakpoint](#LoopBreakpoint)
- [Var](#Var)

## calc_align
[[Return to contents]](#Contents)

## calc_padding
[[Return to contents]](#Contents)

## gen
[[Return to contents]](#Contents)

## log2
[[Return to contents]](#Contents)

## unpack_literal_int
[[Return to contents]](#Contents)

## Gen
[[Return to contents]](#Contents)

## as_numtype
[[Return to contents]](#Contents)

## asm_call
[[Return to contents]](#Contents)

## asm_global_get_or_set
[[Return to contents]](#Contents)

## asm_literal_arg
[[Return to contents]](#Contents)

## asm_load_or_store
[[Return to contents]](#Contents)

## asm_local_get_set_or_tee
[[Return to contents]](#Contents)

## asm_parse_align_offset
[[Return to contents]](#Contents)

## asm_stmt
[[Return to contents]](#Contents)

## asm_template
[[Return to contents]](#Contents)

## bare_function_end
[[Return to contents]](#Contents)

## bare_function_frame
[[Return to contents]](#Contents)

## bp
[[Return to contents]](#Contents)

## calculate_enum_fields
[[Return to contents]](#Contents)

## call_expr
[[Return to contents]](#Contents)

## cast
[[Return to contents]](#Contents)

## comptime_cond
[[Return to contents]](#Contents)

## comptime_if_expr
[[Return to contents]](#Contents)

## comptime_if_to_ifdef
[[Return to contents]](#Contents)

## dbg_type_name
[[Return to contents]](#Contents)

## expr
[[Return to contents]](#Contents)

## expr_stmt
[[Return to contents]](#Contents)

## expr_stmts
[[Return to contents]](#Contents)

## expr_with_cast
[[Return to contents]](#Contents)

## field_offset
[[Return to contents]](#Contents)

## file_pos
[[Return to contents]](#Contents)

## fn_decl
[[Return to contents]](#Contents)

## fn_external_import
[[Return to contents]](#Contents)

## get
[[Return to contents]](#Contents)

## get_field_offset
[[Return to contents]](#Contents)

## get_ns_plus_name
[[Return to contents]](#Contents)

## get_var_from_expr
[[Return to contents]](#Contents)

## get_var_from_ident
[[Return to contents]](#Contents)

## get_var_or_make_from_expr
[[Return to contents]](#Contents)

## get_wasm_type
[[Return to contents]](#Contents)

## get_wasm_type_int_literal
[[Return to contents]](#Contents)

## handle_ptr_arithmetic
[[Return to contents]](#Contents)

## housekeeping
[[Return to contents]](#Contents)

## hp
[[Return to contents]](#Contents)

## if_branch
[[Return to contents]](#Contents)

## if_expr
[[Return to contents]](#Contents)

## infix_expr
[[Return to contents]](#Contents)

## infix_from_typ
[[Return to contents]](#Contents)

## is_param
[[Return to contents]](#Contents)

## is_param_type
[[Return to contents]](#Contents)

## is_pure_type
[[Return to contents]](#Contents)

## literal
[[Return to contents]](#Contents)

## literal_to_constant_expression
[[Return to contents]](#Contents)

## literalint
[[Return to contents]](#Contents)

## load
[[Return to contents]](#Contents)

## load_field
[[Return to contents]](#Contents)

## make_vinit
[[Return to contents]](#Contents)

## mov
[[Return to contents]](#Contents)

## new_global
[[Return to contents]](#Contents)

## new_local
[[Return to contents]](#Contents)

## offset
[[Return to contents]](#Contents)

## prefix_expr
[[Return to contents]](#Contents)

## ref
[[Return to contents]](#Contents)

## ref_ignore_offset
[[Return to contents]](#Contents)

## rvar_expr_stmts
[[Return to contents]](#Contents)

## set
[[Return to contents]](#Contents)

## set_prepare
[[Return to contents]](#Contents)

## set_set
[[Return to contents]](#Contents)

## set_with_expr
[[Return to contents]](#Contents)

## set_with_multi_expr
[[Return to contents]](#Contents)

## sp
[[Return to contents]](#Contents)

## store
[[Return to contents]](#Contents)

## store_field
[[Return to contents]](#Contents)

## tee
[[Return to contents]](#Contents)

## toplevel_stmt
[[Return to contents]](#Contents)

## toplevel_stmts
[[Return to contents]](#Contents)

## unpack_type
[[Return to contents]](#Contents)

## v_error
[[Return to contents]](#Contents)

## w_error
[[Return to contents]](#Contents)

## warning
[[Return to contents]](#Contents)

## zero_fill
[[Return to contents]](#Contents)

## LoopBreakpoint
[[Return to contents]](#Contents)

## Var
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:56
