# module v.ast


## Contents
- [Constants](#Constants)
- [all_registers](#all_registers)
- [args2str](#args2str)
- [idx_to_type](#idx_to_type)
- [merge_types](#merge_types)
- [mktyp](#mktyp)
- [new_table](#new_table)
- [new_type](#new_type)
- [new_type_ptr](#new_type_ptr)
- [pref_arch_to_table_language](#pref_arch_to_table_language)
- [sharetype_from_flags](#sharetype_from_flags)
- [type_can_start_with_token](#type_can_start_with_token)
- [validate_type_string_is_pure_literal](#validate_type_string_is_pure_literal)
- [AsmArg](#AsmArg)
- [ComptTimeConstValue](#ComptTimeConstValue)
  - [i8](#i8)
  - [i16](#i16)
  - [int](#int)
  - [i32](#i32)
  - [voidptr](#voidptr)
  - [i64](#i64)
  - [u8](#u8)
  - [u16](#u16)
  - [u32](#u32)
  - [u64](#u64)
  - [f32](#f32)
  - [f64](#f64)
  - [string](#string)
- [EmptyExpr](#EmptyExpr)
- [Expr](#Expr)
  - [get_pure_type](#get_pure_type)
  - [has_fn_call](#has_fn_call)
  - [is_as_cast](#is_as_cast)
  - [is_auto_deref_var](#is_auto_deref_var)
  - [is_blank_ident](#is_blank_ident)
  - [is_expr](#is_expr)
  - [is_literal](#is_literal)
  - [is_lockable](#is_lockable)
  - [is_lvalue](#is_lvalue)
  - [is_nil](#is_nil)
  - [is_pure_literal](#is_pure_literal)
  - [is_reference](#is_reference)
  - [pos](#pos)
  - [str](#str)
- [FnPanicHandler](#FnPanicHandler)
- [IdentInfo](#IdentInfo)
- [Node](#Node)
  - [pos](#pos)
  - [children](#children)
- [ScopeObject](#ScopeObject)
  - [is_simple_define_const](#is_simple_define_const)
- [Stmt](#Stmt)
  - [str](#str)
- [Type](#Type)
  - [atomic_typename](#atomic_typename)
  - [share](#share)
  - [idx](#idx)
  - [is_void](#is_void)
  - [is_full](#is_full)
  - [nr_muls](#nr_muls)
  - [is_ptr](#is_ptr)
  - [is_pointer](#is_pointer)
  - [is_voidptr](#is_voidptr)
  - [is_any_kind_of_pointer](#is_any_kind_of_pointer)
  - [set_nr_muls](#set_nr_muls)
  - [ref](#ref)
  - [deref](#deref)
  - [has_flag](#has_flag)
  - [set_flag](#set_flag)
  - [clear_flag](#clear_flag)
  - [clear_flags](#clear_flags)
  - [clear_option_and_result](#clear_option_and_result)
  - [has_option_or_result](#has_option_or_result)
  - [str](#str)
  - [debug](#debug)
  - [derive](#derive)
  - [derive_add_muls](#derive_add_muls)
  - [idx_type](#idx_type)
  - [is_float](#is_float)
  - [is_int](#is_int)
  - [is_int_valptr](#is_int_valptr)
  - [is_float_valptr](#is_float_valptr)
  - [is_pure_int](#is_pure_int)
  - [is_pure_float](#is_pure_float)
  - [is_signed](#is_signed)
  - [is_unsigned](#is_unsigned)
  - [flip_signedness](#flip_signedness)
  - [is_int_literal](#is_int_literal)
  - [is_number](#is_number)
  - [is_string](#is_string)
  - [is_bool](#is_bool)
- [TypeDecl](#TypeDecl)
- [TypeInfo](#TypeInfo)
- [[]Attr](#[]Attr)
  - [contains](#contains)
  - [contains_arg](#contains_arg)
  - [find_first](#find_first)
  - [find_last](#find_last)
  - [find_comptime_define](#find_comptime_define)
- [[]Kind](#[]Kind)
  - [str](#str)
- [AddressingMode](#AddressingMode)
- [AttrKind](#AttrKind)
- [ComptimeForKind](#ComptimeForKind)
  - [str](#str)
- [ComptimeTypeKind](#ComptimeTypeKind)
- [ComptimeVarKind](#ComptimeVarKind)
- [GenericKindField](#GenericKindField)
- [IdentKind](#IdentKind)
- [Kind](#Kind)
  - [str](#str)
- [Language](#Language)
- [OrKind](#OrKind)
- [ShareType](#ShareType)
  - [str](#str)
- [SqlExprKind](#SqlExprKind)
- [SqlStmtKind](#SqlStmtKind)
- [StructInitKind](#StructInitKind)
- [TypeFlag](#TypeFlag)
- [Aggregate](#Aggregate)
- [Alias](#Alias)
- [AliasTypeDecl](#AliasTypeDecl)
- [AnonFn](#AnonFn)
- [Array](#Array)
- [ArrayDecompose](#ArrayDecompose)
- [ArrayFixed](#ArrayFixed)
  - [is_compatible](#is_compatible)
- [ArrayInit](#ArrayInit)
- [AsCast](#AsCast)
- [AsmAddressing](#AsmAddressing)
- [AsmAlias](#AsmAlias)
- [AsmClobbered](#AsmClobbered)
- [AsmDisp](#AsmDisp)
- [AsmIO](#AsmIO)
- [AsmRegister](#AsmRegister)
- [AsmStmt](#AsmStmt)
- [AsmTemplate](#AsmTemplate)
- [AssertStmt](#AssertStmt)
- [AssignStmt](#AssignStmt)
- [Assoc](#Assoc)
- [AtExpr](#AtExpr)
- [Attr](#Attr)
  - [debug](#debug)
  - [str](#str)
- [Block](#Block)
- [BoolLiteral](#BoolLiteral)
- [BranchStmt](#BranchStmt)
  - [str](#str)
- [CTempVar](#CTempVar)
- [CallArg](#CallArg)
  - [str](#str)
- [CallExpr](#CallExpr)
  - [fkey](#fkey)
  - [get_name](#get_name)
- [CastExpr](#CastExpr)
- [Chan](#Chan)
- [ChanInit](#ChanInit)
- [CharLiteral](#CharLiteral)
- [Comment](#Comment)
- [ComptimeCall](#ComptimeCall)
  - [resolve_compile_value](#resolve_compile_value)
  - [expr_str](#expr_str)
- [ComptimeFor](#ComptimeFor)
- [ComptimeSelector](#ComptimeSelector)
- [ComptimeType](#ComptimeType)
  - [str](#str)
- [ConcatExpr](#ConcatExpr)
- [ConstDecl](#ConstDecl)
- [ConstField](#ConstField)
  - [comptime_expr_value](#comptime_expr_value)
  - [is_simple_define_const](#is_simple_define_const)
- [DebuggerStmt](#DebuggerStmt)
- [DeferStmt](#DeferStmt)
- [DumpExpr](#DumpExpr)
- [Embed](#Embed)
- [EmbeddedFile](#EmbeddedFile)
  - [hash](#hash)
- [EmptyNode](#EmptyNode)
- [EmptyStmt](#EmptyStmt)
- [Enum](#Enum)
- [EnumDecl](#EnumDecl)
- [EnumField](#EnumField)
- [EnumVal](#EnumVal)
- [ExprStmt](#ExprStmt)
- [File](#File)
  - [free](#free)
- [FloatLiteral](#FloatLiteral)
- [Fn](#Fn)
  - [fkey](#fkey)
  - [new_method_with_receiver_type](#new_method_with_receiver_type)
- [FnDecl](#FnDecl)
  - [fkey](#fkey)
  - [get_name](#get_name)
  - [modname](#modname)
  - [new_method_with_receiver_type](#new_method_with_receiver_type)
- [FnSignatureOpts](#FnSignatureOpts)
- [FnTrace](#FnTrace)
- [FnType](#FnType)
- [FnTypeDecl](#FnTypeDecl)
- [ForCStmt](#ForCStmt)
- [ForInStmt](#ForInStmt)
- [ForStmt](#ForStmt)
- [GenericInst](#GenericInst)
- [GetEmbedsOptions](#GetEmbedsOptions)
- [GlobalDecl](#GlobalDecl)
- [GlobalField](#GlobalField)
- [GoExpr](#GoExpr)
- [GotoLabel](#GotoLabel)
- [GotoStmt](#GotoStmt)
- [HashStmt](#HashStmt)
- [Ident](#Ident)
  - [full_name](#full_name)
  - [is_auto_heap](#is_auto_heap)
  - [is_mut](#is_mut)
  - [var_info](#var_info)
- [IdentFn](#IdentFn)
- [IdentVar](#IdentVar)
- [IfBranch](#IfBranch)
- [IfExpr](#IfExpr)
- [IfGuardExpr](#IfGuardExpr)
- [IfGuardVar](#IfGuardVar)
- [Import](#Import)
- [ImportSymbol](#ImportSymbol)
- [IndexExpr](#IndexExpr)
  - [recursive_mapset_is_setter](#recursive_mapset_is_setter)
  - [recursive_arraymap_set_is_setter](#recursive_arraymap_set_is_setter)
- [InfixExpr](#InfixExpr)
- [IntegerLiteral](#IntegerLiteral)
- [Interface](#Interface)
  - [find_field](#find_field)
  - [find_method](#find_method)
  - [has_method](#has_method)
  - [defines_method](#defines_method)
  - [get_methods](#get_methods)
- [InterfaceDecl](#InterfaceDecl)
- [InterfaceEmbedding](#InterfaceEmbedding)
- [IsRefType](#IsRefType)
- [LambdaExpr](#LambdaExpr)
- [Likely](#Likely)
- [LockExpr](#LockExpr)
- [Map](#Map)
- [MapInit](#MapInit)
- [MatchBranch](#MatchBranch)
- [MatchExpr](#MatchExpr)
- [Module](#Module)
- [MultiReturn](#MultiReturn)
- [Nil](#Nil)
- [NodeError](#NodeError)
- [None](#None)
- [OffsetOf](#OffsetOf)
- [OrExpr](#OrExpr)
- [ParExpr](#ParExpr)
- [Param](#Param)
  - [specifier](#specifier)
- [PostfixExpr](#PostfixExpr)
- [PrefixExpr](#PrefixExpr)
- [RangeExpr](#RangeExpr)
- [Return](#Return)
- [Scope](#Scope)
  - [free](#free)
  - [find](#find)
  - [find_struct_field](#find_struct_field)
  - [find_var](#find_var)
  - [find_global](#find_global)
  - [find_const](#find_const)
  - [known_var](#known_var)
  - [known_global](#known_global)
  - [known_const](#known_const)
  - [update_var_type](#update_var_type)
  - [update_ct_var_kind](#update_ct_var_kind)
  - [update_smartcasts](#update_smartcasts)
  - [register_struct_field](#register_struct_field)
  - [register](#register)
  - [innermost](#innermost)
  - [get_all_vars](#get_all_vars)
  - [contains](#contains)
  - [has_inherited_vars](#has_inherited_vars)
  - [is_inherited_var](#is_inherited_var)
  - [show](#show)
  - [mark_var_as_used](#mark_var_as_used)
  - [str](#str)
- [ScopeStructField](#ScopeStructField)
- [SelectBranch](#SelectBranch)
- [SelectExpr](#SelectExpr)
- [SelectorExpr](#SelectorExpr)
  - [root_ident](#root_ident)
- [SemicolonStmt](#SemicolonStmt)
- [SizeOf](#SizeOf)
- [SpawnExpr](#SpawnExpr)
- [SqlExpr](#SqlExpr)
- [SqlStmt](#SqlStmt)
- [SqlStmtLine](#SqlStmtLine)
- [StringInterLiteral](#StringInterLiteral)
  - [get_fspec_braces](#get_fspec_braces)
- [StringLiteral](#StringLiteral)
- [Struct](#Struct)
  - [is_empty_struct](#is_empty_struct)
  - [is_unresolved_generic](#is_unresolved_generic)
  - [find_field](#find_field)
  - [get_field](#get_field)
- [StructDecl](#StructDecl)
- [StructField](#StructField)
  - [equals](#equals)
- [StructInit](#StructInit)
- [StructInitField](#StructInitField)
- [SumType](#SumType)
  - [find_sum_type_field](#find_sum_type_field)
- [SumTypeDecl](#SumTypeDecl)
- [Table](#Table)
  - [add_placeholder_type](#add_placeholder_type)
  - [array_cname](#array_cname)
  - [array_fixed_cname](#array_fixed_cname)
  - [array_fixed_name](#array_fixed_name)
  - [array_name](#array_name)
  - [bitsize_to_type](#bitsize_to_type)
  - [chan_cname](#chan_cname)
  - [chan_name](#chan_name)
  - [check_if_elements_need_unwrap](#check_if_elements_need_unwrap)
  - [clean_generics_type_str](#clean_generics_type_str)
  - [complete_interface_check](#complete_interface_check)
  - [convert_generic_static_type_name](#convert_generic_static_type_name)
  - [convert_generic_type](#convert_generic_type)
  - [dependent_names_in_expr](#dependent_names_in_expr)
  - [dependent_names_in_stmt](#dependent_names_in_stmt)
  - [does_type_implement_interface](#does_type_implement_interface)
  - [final_sym](#final_sym)
  - [final_type](#final_type)
  - [find_enum_field_val](#find_enum_field_val)
  - [find_field](#find_field)
  - [find_field_from_embeds](#find_field_from_embeds)
  - [find_field_with_embeds](#find_field_with_embeds)
  - [find_fn](#find_fn)
  - [find_method](#find_method)
  - [find_method_from_embeds](#find_method_from_embeds)
  - [find_method_with_embeds](#find_method_with_embeds)
  - [find_missing_variants](#find_missing_variants)
  - [find_or_register_array](#find_or_register_array)
  - [find_or_register_array_fixed](#find_or_register_array_fixed)
  - [find_or_register_array_with_dims](#find_or_register_array_with_dims)
  - [find_or_register_chan](#find_or_register_chan)
  - [find_or_register_fn_type](#find_or_register_fn_type)
  - [find_or_register_map](#find_or_register_map)
  - [find_or_register_multi_return](#find_or_register_multi_return)
  - [find_or_register_promise](#find_or_register_promise)
  - [find_or_register_thread](#find_or_register_thread)
  - [find_sym](#find_sym)
  - [find_sym_and_type_idx](#find_sym_and_type_idx)
  - [find_type](#find_type)
  - [find_type_idx](#find_type_idx)
  - [find_type_idx_fn_scoped](#find_type_idx_fn_scoped)
  - [fn_signature](#fn_signature)
  - [fn_signature_using_aliases](#fn_signature_using_aliases)
  - [fn_type_signature](#fn_type_signature)
  - [fn_type_source_signature](#fn_type_source_signature)
  - [free](#free)
  - [generic_insts_to_concrete](#generic_insts_to_concrete)
  - [generic_type_names](#generic_type_names)
  - [get_anon_fn_name](#get_anon_fn_name)
  - [get_array_dims](#get_array_dims)
  - [get_attrs](#get_attrs)
  - [get_embed_methods](#get_embed_methods)
  - [get_embeds](#get_embeds)
  - [get_enum_field_names](#get_enum_field_names)
  - [get_enum_field_vals](#get_enum_field_vals)
  - [get_final_type_name](#get_final_type_name)
  - [get_generic_names](#get_generic_names)
  - [get_trace_fn_name](#get_trace_fn_name)
  - [get_type_name](#get_type_name)
  - [get_veb_result_type_idx](#get_veb_result_type_idx)
  - [has_cflag](#has_cflag)
  - [has_deep_child_no_ref](#has_deep_child_no_ref)
  - [has_method](#has_method)
  - [is_interface_smartcast](#is_interface_smartcast)
  - [is_interface_var](#is_interface_var)
  - [is_same_method](#is_same_method)
  - [is_sumtype_or_in_variant](#is_sumtype_or_in_variant)
  - [known_fn](#known_fn)
  - [known_type](#known_type)
  - [known_type_idx](#known_type_idx)
  - [known_type_names](#known_type_names)
  - [map_cname](#map_cname)
  - [map_name](#map_name)
  - [panic](#panic)
  - [parse_cflag](#parse_cflag)
  - [promise_cname](#promise_cname)
  - [promise_name](#promise_name)
  - [register_aggregate_method](#register_aggregate_method)
  - [register_anon_struct](#register_anon_struct)
  - [register_anon_union](#register_anon_union)
  - [register_builtin_type_symbols](#register_builtin_type_symbols)
  - [register_enum_decl](#register_enum_decl)
  - [register_fn](#register_fn)
  - [register_fn_concrete_types](#register_fn_concrete_types)
  - [register_fn_generic_types](#register_fn_generic_types)
  - [register_interface](#register_interface)
  - [register_sumtype](#register_sumtype)
  - [register_sym](#register_sym)
  - [reset_parsing_type](#reset_parsing_type)
  - [resolve_common_sumtype_fields](#resolve_common_sumtype_fields)
  - [resolve_init](#resolve_init)
  - [start_parsing_type](#start_parsing_type)
  - [stringify_anon_decl](#stringify_anon_decl)
  - [stringify_fn_decl](#stringify_fn_decl)
  - [struct_fields](#struct_fields)
  - [struct_has_field](#struct_has_field)
  - [sumtype_has_variant](#sumtype_has_variant)
  - [sym](#sym)
  - [sym_by_idx](#sym_by_idx)
  - [thread_cname](#thread_cname)
  - [thread_name](#thread_name)
  - [type_is_for_pointer_arithmetic](#type_is_for_pointer_arithmetic)
  - [type_kind](#type_kind)
  - [type_size](#type_size)
  - [type_str](#type_str)
  - [type_to_code](#type_to_code)
  - [type_to_str](#type_to_str)
  - [type_to_str_using_aliases](#type_to_str_using_aliases)
  - [unalias_num_type](#unalias_num_type)
  - [unaliased_type](#unaliased_type)
  - [unwrap_generic_type](#unwrap_generic_type)
  - [unwrap_generic_type_ex](#unwrap_generic_type_ex)
  - [value_type](#value_type)
- [Thread](#Thread)
- [TypeNode](#TypeNode)
- [TypeOf](#TypeOf)
- [TypeSymbol](#TypeSymbol)
  - [array_fixed_info](#array_fixed_info)
  - [array_info](#array_info)
  - [chan_info](#chan_info)
  - [dbg](#dbg)
  - [debug](#debug)
  - [embed_name](#embed_name)
  - [enum_info](#enum_info)
  - [find_field](#find_field)
  - [find_method](#find_method)
  - [find_method_with_generic_parent](#find_method_with_generic_parent)
  - [get_methods](#get_methods)
  - [has_field](#has_field)
  - [has_method](#has_method)
  - [has_method_with_generic_parent](#has_method_with_generic_parent)
  - [is_array_fixed](#is_array_fixed)
  - [is_array_fixed_ret](#is_array_fixed_ret)
  - [is_bool](#is_bool)
  - [is_builtin](#is_builtin)
  - [is_c_struct](#is_c_struct)
  - [is_empty_struct_array](#is_empty_struct_array)
  - [is_float](#is_float)
  - [is_heap](#is_heap)
  - [is_int](#is_int)
  - [is_js_compatible](#is_js_compatible)
  - [is_number](#is_number)
  - [is_pointer](#is_pointer)
  - [is_primitive](#is_primitive)
  - [is_primitive_fixed_array](#is_primitive_fixed_array)
  - [is_string](#is_string)
  - [map_info](#map_info)
  - [mr_info](#mr_info)
  - [nr_dims](#nr_dims)
  - [register_method](#register_method)
  - [scoped_cname](#scoped_cname)
  - [scoped_name](#scoped_name)
  - [str](#str)
  - [str_method_info](#str_method_info)
  - [struct_info](#struct_info)
  - [sumtype_info](#sumtype_info)
  - [symbol_name_except_generic](#symbol_name_except_generic)
  - [thread_info](#thread_info)
  - [update_method](#update_method)
- [UnknownTypeInfo](#UnknownTypeInfo)
- [UnsafeExpr](#UnsafeExpr)
- [UsedFeatures](#UsedFeatures)
  - [free](#free)
- [Var](#Var)

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

## all_registers
[[Return to contents]](#Contents)

## args2str
[[Return to contents]](#Contents)

## idx_to_type
[[Return to contents]](#Contents)

## merge_types
[[Return to contents]](#Contents)

## mktyp
[[Return to contents]](#Contents)

## new_table
[[Return to contents]](#Contents)

## new_type
[[Return to contents]](#Contents)

## new_type_ptr
[[Return to contents]](#Contents)

## pref_arch_to_table_language
[[Return to contents]](#Contents)

## sharetype_from_flags
[[Return to contents]](#Contents)

## type_can_start_with_token
[[Return to contents]](#Contents)

## validate_type_string_is_pure_literal
[[Return to contents]](#Contents)

## AsmArg
[[Return to contents]](#Contents)

## ComptTimeConstValue
[[Return to contents]](#Contents)

## i8
[[Return to contents]](#Contents)

## i16
[[Return to contents]](#Contents)

## int
[[Return to contents]](#Contents)

## i32
[[Return to contents]](#Contents)

## voidptr
[[Return to contents]](#Contents)

## i64
[[Return to contents]](#Contents)

## u8
[[Return to contents]](#Contents)

## u16
[[Return to contents]](#Contents)

## u32
[[Return to contents]](#Contents)

## u64
[[Return to contents]](#Contents)

## f32
[[Return to contents]](#Contents)

## f64
[[Return to contents]](#Contents)

## string
[[Return to contents]](#Contents)

## EmptyExpr
[[Return to contents]](#Contents)

## Expr
[[Return to contents]](#Contents)

## get_pure_type
[[Return to contents]](#Contents)

## has_fn_call
[[Return to contents]](#Contents)

## is_as_cast
[[Return to contents]](#Contents)

## is_auto_deref_var
[[Return to contents]](#Contents)

## is_blank_ident
[[Return to contents]](#Contents)

## is_expr
[[Return to contents]](#Contents)

## is_literal
[[Return to contents]](#Contents)

## is_lockable
[[Return to contents]](#Contents)

## is_lvalue
[[Return to contents]](#Contents)

## is_nil
[[Return to contents]](#Contents)

## is_pure_literal
[[Return to contents]](#Contents)

## is_reference
[[Return to contents]](#Contents)

## pos
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## FnPanicHandler
[[Return to contents]](#Contents)

## IdentInfo
[[Return to contents]](#Contents)

## Node
[[Return to contents]](#Contents)

## pos
[[Return to contents]](#Contents)

## children
[[Return to contents]](#Contents)

## ScopeObject
[[Return to contents]](#Contents)

## is_simple_define_const
[[Return to contents]](#Contents)

## Stmt
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## Type
[[Return to contents]](#Contents)

## atomic_typename
[[Return to contents]](#Contents)

## share
[[Return to contents]](#Contents)

## idx
[[Return to contents]](#Contents)

## is_void
[[Return to contents]](#Contents)

## is_full
[[Return to contents]](#Contents)

## nr_muls
[[Return to contents]](#Contents)

## is_ptr
[[Return to contents]](#Contents)

## is_pointer
[[Return to contents]](#Contents)

## is_voidptr
[[Return to contents]](#Contents)

## is_any_kind_of_pointer
[[Return to contents]](#Contents)

## set_nr_muls
[[Return to contents]](#Contents)

## ref
[[Return to contents]](#Contents)

## deref
[[Return to contents]](#Contents)

## has_flag
[[Return to contents]](#Contents)

## set_flag
[[Return to contents]](#Contents)

## clear_flag
[[Return to contents]](#Contents)

## clear_flags
[[Return to contents]](#Contents)

## clear_option_and_result
[[Return to contents]](#Contents)

## has_option_or_result
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## debug
[[Return to contents]](#Contents)

## derive
[[Return to contents]](#Contents)

## derive_add_muls
[[Return to contents]](#Contents)

## idx_type
[[Return to contents]](#Contents)

## is_float
[[Return to contents]](#Contents)

## is_int
[[Return to contents]](#Contents)

## is_int_valptr
[[Return to contents]](#Contents)

## is_float_valptr
[[Return to contents]](#Contents)

## is_pure_int
[[Return to contents]](#Contents)

## is_pure_float
[[Return to contents]](#Contents)

## is_signed
[[Return to contents]](#Contents)

## is_unsigned
[[Return to contents]](#Contents)

## flip_signedness
[[Return to contents]](#Contents)

## is_int_literal
[[Return to contents]](#Contents)

## is_number
[[Return to contents]](#Contents)

## is_string
[[Return to contents]](#Contents)

## is_bool
[[Return to contents]](#Contents)

## TypeDecl
[[Return to contents]](#Contents)

## TypeInfo
[[Return to contents]](#Contents)

## []Attr
## contains
[[Return to contents]](#Contents)

## contains_arg
[[Return to contents]](#Contents)

## find_first
[[Return to contents]](#Contents)

## find_last
[[Return to contents]](#Contents)

## find_comptime_define
[[Return to contents]](#Contents)

## []Kind
## str
[[Return to contents]](#Contents)

## AddressingMode
[[Return to contents]](#Contents)

## AttrKind
[[Return to contents]](#Contents)

## ComptimeForKind
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## ComptimeTypeKind
[[Return to contents]](#Contents)

## ComptimeVarKind
[[Return to contents]](#Contents)

## GenericKindField
[[Return to contents]](#Contents)

## IdentKind
[[Return to contents]](#Contents)

## Kind
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## Language
[[Return to contents]](#Contents)

## OrKind
[[Return to contents]](#Contents)

## ShareType
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## SqlExprKind
[[Return to contents]](#Contents)

## SqlStmtKind
[[Return to contents]](#Contents)

## StructInitKind
[[Return to contents]](#Contents)

## TypeFlag
[[Return to contents]](#Contents)

## Aggregate
[[Return to contents]](#Contents)

## Alias
[[Return to contents]](#Contents)

## AliasTypeDecl
[[Return to contents]](#Contents)

## AnonFn
[[Return to contents]](#Contents)

## Array
[[Return to contents]](#Contents)

## ArrayDecompose
[[Return to contents]](#Contents)

## ArrayFixed
[[Return to contents]](#Contents)

## is_compatible
[[Return to contents]](#Contents)

## ArrayInit
[[Return to contents]](#Contents)

## AsCast
[[Return to contents]](#Contents)

## AsmAddressing
[[Return to contents]](#Contents)

## AsmAlias
[[Return to contents]](#Contents)

## AsmClobbered
[[Return to contents]](#Contents)

## AsmDisp
[[Return to contents]](#Contents)

## AsmIO
[[Return to contents]](#Contents)

## AsmRegister
[[Return to contents]](#Contents)

## AsmStmt
[[Return to contents]](#Contents)

## AsmTemplate
[[Return to contents]](#Contents)

## AssertStmt
[[Return to contents]](#Contents)

## AssignStmt
[[Return to contents]](#Contents)

## Assoc
[[Return to contents]](#Contents)

## AtExpr
[[Return to contents]](#Contents)

## Attr
[[Return to contents]](#Contents)

## debug
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## Block
[[Return to contents]](#Contents)

## BoolLiteral
[[Return to contents]](#Contents)

## BranchStmt
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## CTempVar
[[Return to contents]](#Contents)

## CallArg
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## CallExpr
[[Return to contents]](#Contents)

## fkey
[[Return to contents]](#Contents)

## get_name
[[Return to contents]](#Contents)

## CastExpr
[[Return to contents]](#Contents)

## Chan
[[Return to contents]](#Contents)

## ChanInit
[[Return to contents]](#Contents)

## CharLiteral
[[Return to contents]](#Contents)

## Comment
[[Return to contents]](#Contents)

## ComptimeCall
[[Return to contents]](#Contents)

## resolve_compile_value
[[Return to contents]](#Contents)

## expr_str
[[Return to contents]](#Contents)

## ComptimeFor
[[Return to contents]](#Contents)

## ComptimeSelector
[[Return to contents]](#Contents)

## ComptimeType
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## ConcatExpr
[[Return to contents]](#Contents)

## ConstDecl
[[Return to contents]](#Contents)

## ConstField
[[Return to contents]](#Contents)

## comptime_expr_value
[[Return to contents]](#Contents)

## is_simple_define_const
[[Return to contents]](#Contents)

## DebuggerStmt
[[Return to contents]](#Contents)

## DeferStmt
[[Return to contents]](#Contents)

## DumpExpr
[[Return to contents]](#Contents)

## Embed
[[Return to contents]](#Contents)

## EmbeddedFile
[[Return to contents]](#Contents)

## hash
[[Return to contents]](#Contents)

## EmptyNode
[[Return to contents]](#Contents)

## EmptyStmt
[[Return to contents]](#Contents)

## Enum
[[Return to contents]](#Contents)

## EnumDecl
[[Return to contents]](#Contents)

## EnumField
[[Return to contents]](#Contents)

## EnumVal
[[Return to contents]](#Contents)

## ExprStmt
[[Return to contents]](#Contents)

## File
[[Return to contents]](#Contents)

## free
[[Return to contents]](#Contents)

## FloatLiteral
[[Return to contents]](#Contents)

## Fn
[[Return to contents]](#Contents)

## fkey
[[Return to contents]](#Contents)

## new_method_with_receiver_type
[[Return to contents]](#Contents)

## FnDecl
[[Return to contents]](#Contents)

## fkey
[[Return to contents]](#Contents)

## get_name
[[Return to contents]](#Contents)

## modname
[[Return to contents]](#Contents)

## new_method_with_receiver_type
[[Return to contents]](#Contents)

## FnSignatureOpts
[[Return to contents]](#Contents)

## FnTrace
[[Return to contents]](#Contents)

## FnType
[[Return to contents]](#Contents)

## FnTypeDecl
[[Return to contents]](#Contents)

## ForCStmt
[[Return to contents]](#Contents)

## ForInStmt
[[Return to contents]](#Contents)

## ForStmt
[[Return to contents]](#Contents)

## GenericInst
[[Return to contents]](#Contents)

## GetEmbedsOptions
[[Return to contents]](#Contents)

## GlobalDecl
[[Return to contents]](#Contents)

## GlobalField
[[Return to contents]](#Contents)

## GoExpr
[[Return to contents]](#Contents)

## GotoLabel
[[Return to contents]](#Contents)

## GotoStmt
[[Return to contents]](#Contents)

## HashStmt
[[Return to contents]](#Contents)

## Ident
[[Return to contents]](#Contents)

## full_name
[[Return to contents]](#Contents)

## is_auto_heap
[[Return to contents]](#Contents)

## is_mut
[[Return to contents]](#Contents)

## var_info
[[Return to contents]](#Contents)

## IdentFn
[[Return to contents]](#Contents)

## IdentVar
[[Return to contents]](#Contents)

## IfBranch
[[Return to contents]](#Contents)

## IfExpr
[[Return to contents]](#Contents)

## IfGuardExpr
[[Return to contents]](#Contents)

## IfGuardVar
[[Return to contents]](#Contents)

## Import
[[Return to contents]](#Contents)

## ImportSymbol
[[Return to contents]](#Contents)

## IndexExpr
[[Return to contents]](#Contents)

## recursive_mapset_is_setter
[[Return to contents]](#Contents)

## recursive_arraymap_set_is_setter
[[Return to contents]](#Contents)

## InfixExpr
[[Return to contents]](#Contents)

## IntegerLiteral
[[Return to contents]](#Contents)

## Interface
[[Return to contents]](#Contents)

## find_field
[[Return to contents]](#Contents)

## find_method
[[Return to contents]](#Contents)

## has_method
[[Return to contents]](#Contents)

## defines_method
[[Return to contents]](#Contents)

## get_methods
[[Return to contents]](#Contents)

## InterfaceDecl
[[Return to contents]](#Contents)

## InterfaceEmbedding
[[Return to contents]](#Contents)

## IsRefType
[[Return to contents]](#Contents)

## LambdaExpr
[[Return to contents]](#Contents)

## Likely
[[Return to contents]](#Contents)

## LockExpr
[[Return to contents]](#Contents)

## Map
[[Return to contents]](#Contents)

## MapInit
[[Return to contents]](#Contents)

## MatchBranch
[[Return to contents]](#Contents)

## MatchExpr
[[Return to contents]](#Contents)

## Module
[[Return to contents]](#Contents)

## MultiReturn
[[Return to contents]](#Contents)

## Nil
[[Return to contents]](#Contents)

## NodeError
[[Return to contents]](#Contents)

## None
[[Return to contents]](#Contents)

## OffsetOf
[[Return to contents]](#Contents)

## OrExpr
[[Return to contents]](#Contents)

## ParExpr
[[Return to contents]](#Contents)

## Param
[[Return to contents]](#Contents)

## specifier
[[Return to contents]](#Contents)

## PostfixExpr
[[Return to contents]](#Contents)

## PrefixExpr
[[Return to contents]](#Contents)

## RangeExpr
[[Return to contents]](#Contents)

## Return
[[Return to contents]](#Contents)

## Scope
[[Return to contents]](#Contents)

## free
[[Return to contents]](#Contents)

## find
[[Return to contents]](#Contents)

## find_struct_field
[[Return to contents]](#Contents)

## find_var
[[Return to contents]](#Contents)

## find_global
[[Return to contents]](#Contents)

## find_const
[[Return to contents]](#Contents)

## known_var
[[Return to contents]](#Contents)

## known_global
[[Return to contents]](#Contents)

## known_const
[[Return to contents]](#Contents)

## update_var_type
[[Return to contents]](#Contents)

## update_ct_var_kind
[[Return to contents]](#Contents)

## update_smartcasts
[[Return to contents]](#Contents)

## register_struct_field
[[Return to contents]](#Contents)

## register
[[Return to contents]](#Contents)

## innermost
[[Return to contents]](#Contents)

## get_all_vars
[[Return to contents]](#Contents)

## contains
[[Return to contents]](#Contents)

## has_inherited_vars
[[Return to contents]](#Contents)

## is_inherited_var
[[Return to contents]](#Contents)

## show
[[Return to contents]](#Contents)

## mark_var_as_used
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## ScopeStructField
[[Return to contents]](#Contents)

## SelectBranch
[[Return to contents]](#Contents)

## SelectExpr
[[Return to contents]](#Contents)

## SelectorExpr
[[Return to contents]](#Contents)

## root_ident
[[Return to contents]](#Contents)

## SemicolonStmt
[[Return to contents]](#Contents)

## SizeOf
[[Return to contents]](#Contents)

## SpawnExpr
[[Return to contents]](#Contents)

## SqlExpr
[[Return to contents]](#Contents)

## SqlStmt
[[Return to contents]](#Contents)

## SqlStmtLine
[[Return to contents]](#Contents)

## StringInterLiteral
[[Return to contents]](#Contents)

## get_fspec_braces
[[Return to contents]](#Contents)

## StringLiteral
[[Return to contents]](#Contents)

## Struct
[[Return to contents]](#Contents)

## is_empty_struct
[[Return to contents]](#Contents)

## is_unresolved_generic
[[Return to contents]](#Contents)

## find_field
[[Return to contents]](#Contents)

## get_field
[[Return to contents]](#Contents)

## StructDecl
[[Return to contents]](#Contents)

## StructField
[[Return to contents]](#Contents)

## equals
[[Return to contents]](#Contents)

## StructInit
[[Return to contents]](#Contents)

## StructInitField
[[Return to contents]](#Contents)

## SumType
[[Return to contents]](#Contents)

## find_sum_type_field
[[Return to contents]](#Contents)

## SumTypeDecl
[[Return to contents]](#Contents)

## Table
[[Return to contents]](#Contents)

## add_placeholder_type
[[Return to contents]](#Contents)

## array_cname
[[Return to contents]](#Contents)

## array_fixed_cname
[[Return to contents]](#Contents)

## array_fixed_name
[[Return to contents]](#Contents)

## array_name
[[Return to contents]](#Contents)

## bitsize_to_type
[[Return to contents]](#Contents)

## chan_cname
[[Return to contents]](#Contents)

## chan_name
[[Return to contents]](#Contents)

## check_if_elements_need_unwrap
[[Return to contents]](#Contents)

## clean_generics_type_str
[[Return to contents]](#Contents)

## complete_interface_check
[[Return to contents]](#Contents)

## convert_generic_static_type_name
[[Return to contents]](#Contents)

## convert_generic_type
[[Return to contents]](#Contents)

## dependent_names_in_expr
[[Return to contents]](#Contents)

## dependent_names_in_stmt
[[Return to contents]](#Contents)

## does_type_implement_interface
[[Return to contents]](#Contents)

## final_sym
[[Return to contents]](#Contents)

## final_type
[[Return to contents]](#Contents)

## find_enum_field_val
[[Return to contents]](#Contents)

## find_field
[[Return to contents]](#Contents)

## find_field_from_embeds
[[Return to contents]](#Contents)

## find_field_with_embeds
[[Return to contents]](#Contents)

## find_fn
[[Return to contents]](#Contents)

## find_method
[[Return to contents]](#Contents)

## find_method_from_embeds
[[Return to contents]](#Contents)

## find_method_with_embeds
[[Return to contents]](#Contents)

## find_missing_variants
[[Return to contents]](#Contents)

## find_or_register_array
[[Return to contents]](#Contents)

## find_or_register_array_fixed
[[Return to contents]](#Contents)

## find_or_register_array_with_dims
[[Return to contents]](#Contents)

## find_or_register_chan
[[Return to contents]](#Contents)

## find_or_register_fn_type
[[Return to contents]](#Contents)

## find_or_register_map
[[Return to contents]](#Contents)

## find_or_register_multi_return
[[Return to contents]](#Contents)

## find_or_register_promise
[[Return to contents]](#Contents)

## find_or_register_thread
[[Return to contents]](#Contents)

## find_sym
[[Return to contents]](#Contents)

## find_sym_and_type_idx
[[Return to contents]](#Contents)

## find_type
[[Return to contents]](#Contents)

## find_type_idx
[[Return to contents]](#Contents)

## find_type_idx_fn_scoped
[[Return to contents]](#Contents)

## fn_signature
[[Return to contents]](#Contents)

## fn_signature_using_aliases
[[Return to contents]](#Contents)

## fn_type_signature
[[Return to contents]](#Contents)

## fn_type_source_signature
[[Return to contents]](#Contents)

## free
[[Return to contents]](#Contents)

## generic_insts_to_concrete
[[Return to contents]](#Contents)

## generic_type_names
[[Return to contents]](#Contents)

## get_anon_fn_name
[[Return to contents]](#Contents)

## get_array_dims
[[Return to contents]](#Contents)

## get_attrs
[[Return to contents]](#Contents)

## get_embed_methods
[[Return to contents]](#Contents)

## get_embeds
[[Return to contents]](#Contents)

## get_enum_field_names
[[Return to contents]](#Contents)

## get_enum_field_vals
[[Return to contents]](#Contents)

## get_final_type_name
[[Return to contents]](#Contents)

## get_generic_names
[[Return to contents]](#Contents)

## get_trace_fn_name
[[Return to contents]](#Contents)

## get_type_name
[[Return to contents]](#Contents)

## get_veb_result_type_idx
[[Return to contents]](#Contents)

## has_cflag
[[Return to contents]](#Contents)

## has_deep_child_no_ref
[[Return to contents]](#Contents)

## has_method
[[Return to contents]](#Contents)

## is_interface_smartcast
[[Return to contents]](#Contents)

## is_interface_var
[[Return to contents]](#Contents)

## is_same_method
[[Return to contents]](#Contents)

## is_sumtype_or_in_variant
[[Return to contents]](#Contents)

## known_fn
[[Return to contents]](#Contents)

## known_type
[[Return to contents]](#Contents)

## known_type_idx
[[Return to contents]](#Contents)

## known_type_names
[[Return to contents]](#Contents)

## map_cname
[[Return to contents]](#Contents)

## map_name
[[Return to contents]](#Contents)

## panic
[[Return to contents]](#Contents)

## parse_cflag
[[Return to contents]](#Contents)

## promise_cname
[[Return to contents]](#Contents)

## promise_name
[[Return to contents]](#Contents)

## register_aggregate_method
[[Return to contents]](#Contents)

## register_anon_struct
[[Return to contents]](#Contents)

## register_anon_union
[[Return to contents]](#Contents)

## register_builtin_type_symbols
[[Return to contents]](#Contents)

## register_enum_decl
[[Return to contents]](#Contents)

## register_fn
[[Return to contents]](#Contents)

## register_fn_concrete_types
[[Return to contents]](#Contents)

## register_fn_generic_types
[[Return to contents]](#Contents)

## register_interface
[[Return to contents]](#Contents)

## register_sumtype
[[Return to contents]](#Contents)

## register_sym
[[Return to contents]](#Contents)

## reset_parsing_type
[[Return to contents]](#Contents)

## resolve_common_sumtype_fields
[[Return to contents]](#Contents)

## resolve_init
[[Return to contents]](#Contents)

## start_parsing_type
[[Return to contents]](#Contents)

## stringify_anon_decl
[[Return to contents]](#Contents)

## stringify_fn_decl
[[Return to contents]](#Contents)

## struct_fields
[[Return to contents]](#Contents)

## struct_has_field
[[Return to contents]](#Contents)

## sumtype_has_variant
[[Return to contents]](#Contents)

## sym
[[Return to contents]](#Contents)

## sym_by_idx
[[Return to contents]](#Contents)

## thread_cname
[[Return to contents]](#Contents)

## thread_name
[[Return to contents]](#Contents)

## type_is_for_pointer_arithmetic
[[Return to contents]](#Contents)

## type_kind
[[Return to contents]](#Contents)

## type_size
[[Return to contents]](#Contents)

## type_str
[[Return to contents]](#Contents)

## type_to_code
[[Return to contents]](#Contents)

## type_to_str
[[Return to contents]](#Contents)

## type_to_str_using_aliases
[[Return to contents]](#Contents)

## unalias_num_type
[[Return to contents]](#Contents)

## unaliased_type
[[Return to contents]](#Contents)

## unwrap_generic_type
[[Return to contents]](#Contents)

## unwrap_generic_type_ex
[[Return to contents]](#Contents)

## value_type
[[Return to contents]](#Contents)

## Thread
[[Return to contents]](#Contents)

## TypeNode
[[Return to contents]](#Contents)

## TypeOf
[[Return to contents]](#Contents)

## TypeSymbol
[[Return to contents]](#Contents)

## array_fixed_info
[[Return to contents]](#Contents)

## array_info
[[Return to contents]](#Contents)

## chan_info
[[Return to contents]](#Contents)

## dbg
[[Return to contents]](#Contents)

## debug
[[Return to contents]](#Contents)

## embed_name
[[Return to contents]](#Contents)

## enum_info
[[Return to contents]](#Contents)

## find_field
[[Return to contents]](#Contents)

## find_method
[[Return to contents]](#Contents)

## find_method_with_generic_parent
[[Return to contents]](#Contents)

## get_methods
[[Return to contents]](#Contents)

## has_field
[[Return to contents]](#Contents)

## has_method
[[Return to contents]](#Contents)

## has_method_with_generic_parent
[[Return to contents]](#Contents)

## is_array_fixed
[[Return to contents]](#Contents)

## is_array_fixed_ret
[[Return to contents]](#Contents)

## is_bool
[[Return to contents]](#Contents)

## is_builtin
[[Return to contents]](#Contents)

## is_c_struct
[[Return to contents]](#Contents)

## is_empty_struct_array
[[Return to contents]](#Contents)

## is_float
[[Return to contents]](#Contents)

## is_heap
[[Return to contents]](#Contents)

## is_int
[[Return to contents]](#Contents)

## is_js_compatible
[[Return to contents]](#Contents)

## is_number
[[Return to contents]](#Contents)

## is_pointer
[[Return to contents]](#Contents)

## is_primitive
[[Return to contents]](#Contents)

## is_primitive_fixed_array
[[Return to contents]](#Contents)

## is_string
[[Return to contents]](#Contents)

## map_info
[[Return to contents]](#Contents)

## mr_info
[[Return to contents]](#Contents)

## nr_dims
[[Return to contents]](#Contents)

## register_method
[[Return to contents]](#Contents)

## scoped_cname
[[Return to contents]](#Contents)

## scoped_name
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## str_method_info
[[Return to contents]](#Contents)

## struct_info
[[Return to contents]](#Contents)

## sumtype_info
[[Return to contents]](#Contents)

## symbol_name_except_generic
[[Return to contents]](#Contents)

## thread_info
[[Return to contents]](#Contents)

## update_method
[[Return to contents]](#Contents)

## UnknownTypeInfo
[[Return to contents]](#Contents)

## UnsafeExpr
[[Return to contents]](#Contents)

## UsedFeatures
[[Return to contents]](#Contents)

## free
[[Return to contents]](#Contents)

## Var
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:55
