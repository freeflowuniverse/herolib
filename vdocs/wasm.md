# module wasm


## Contents
- [constexpr_ref_null](#constexpr_ref_null)
- [constexpr_value](#constexpr_value)
- [constexpr_value_zero](#constexpr_value_zero)
- [DataSegmentIndex](#DataSegmentIndex)
- [GlobalImportIndex](#GlobalImportIndex)
- [GlobalIndex](#GlobalIndex)
- [LabelIndex](#LabelIndex)
- [LocalIndex](#LocalIndex)
- [PatchPos](#PatchPos)
- [NumType](#NumType)
- [RefType](#RefType)
- [ValType](#ValType)
- [ConstExpression](#ConstExpression)
  - [i32_const](#i32_const)
  - [i64_const](#i64_const)
  - [f32_const](#f32_const)
  - [f64_const](#f64_const)
  - [add](#add)
  - [sub](#sub)
  - [mul](#mul)
  - [global_get](#global_get)
  - [ref_null](#ref_null)
  - [ref_func](#ref_func)
  - [ref_func_import](#ref_func_import)
- [FuncType](#FuncType)
- [Function](#Function)
  - [abs](#abs)
  - [add](#add)
  - [b_and](#b_and)
  - [b_or](#b_or)
  - [b_shl](#b_shl)
  - [b_shr](#b_shr)
  - [b_xor](#b_xor)
  - [c_block](#c_block)
  - [c_br](#c_br)
  - [c_br_if](#c_br_if)
  - [c_else](#c_else)
  - [c_end](#c_end)
  - [c_if](#c_if)
  - [c_loop](#c_loop)
  - [c_return](#c_return)
  - [c_select](#c_select)
  - [call](#call)
  - [call_import](#call_import)
  - [cast](#cast)
  - [cast_trapping](#cast_trapping)
  - [ceil](#ceil)
  - [clz](#clz)
  - [copysign](#copysign)
  - [ctz](#ctz)
  - [data_drop](#data_drop)
  - [div](#div)
  - [drop](#drop)
  - [eq](#eq)
  - [eqz](#eqz)
  - [export_name](#export_name)
  - [f32_const](#f32_const)
  - [f64_const](#f64_const)
  - [floor](#floor)
  - [ge](#ge)
  - [global_get](#global_get)
  - [global_set](#global_set)
  - [gt](#gt)
  - [i32_const](#i32_const)
  - [i64_const](#i64_const)
  - [le](#le)
  - [load](#load)
  - [load16](#load16)
  - [load32_i64](#load32_i64)
  - [load8](#load8)
  - [local_get](#local_get)
  - [local_set](#local_set)
  - [local_tee](#local_tee)
  - [lt](#lt)
  - [max](#max)
  - [memory_copy](#memory_copy)
  - [memory_fill](#memory_fill)
  - [memory_grow](#memory_grow)
  - [memory_init](#memory_init)
  - [memory_size](#memory_size)
  - [min](#min)
  - [mul](#mul)
  - [ne](#ne)
  - [nearest](#nearest)
  - [neg](#neg)
  - [new_local](#new_local)
  - [new_local_named](#new_local_named)
  - [nop](#nop)
  - [patch](#patch)
  - [patch_pos](#patch_pos)
  - [popcnt](#popcnt)
  - [ref_func](#ref_func)
  - [ref_func_import](#ref_func_import)
  - [ref_is_null](#ref_is_null)
  - [ref_null](#ref_null)
  - [reinterpret](#reinterpret)
  - [rem](#rem)
  - [rotl](#rotl)
  - [rotr](#rotr)
  - [sign_extend16](#sign_extend16)
  - [sign_extend32](#sign_extend32)
  - [sign_extend8](#sign_extend8)
  - [sqrt](#sqrt)
  - [store](#store)
  - [store16](#store16)
  - [store32_i64](#store32_i64)
  - [store8](#store8)
  - [sub](#sub)
  - [trunc](#trunc)
  - [unreachable](#unreachable)
- [Module](#Module)
  - [assign_global_init](#assign_global_init)
  - [assign_memory](#assign_memory)
  - [assign_start](#assign_start)
  - [commit](#commit)
  - [compile](#compile)
  - [enable_debug](#enable_debug)
  - [new_data_segment](#new_data_segment)
  - [new_debug_function](#new_debug_function)
  - [new_function](#new_function)
  - [new_function_import](#new_function_import)
  - [new_function_import_debug](#new_function_import_debug)
  - [new_global](#new_global)
  - [new_global_import](#new_global_import)
  - [new_passive_data_segment](#new_passive_data_segment)

## constexpr_ref_null
[[Return to contents]](#Contents)

## constexpr_value
[[Return to contents]](#Contents)

## constexpr_value_zero
[[Return to contents]](#Contents)

## DataSegmentIndex
[[Return to contents]](#Contents)

## GlobalImportIndex
[[Return to contents]](#Contents)

## GlobalIndex
[[Return to contents]](#Contents)

## LabelIndex
[[Return to contents]](#Contents)

## LocalIndex
[[Return to contents]](#Contents)

## PatchPos
[[Return to contents]](#Contents)

## NumType
[[Return to contents]](#Contents)

## RefType
[[Return to contents]](#Contents)

## ValType
[[Return to contents]](#Contents)

## ConstExpression
[[Return to contents]](#Contents)

## i32_const
[[Return to contents]](#Contents)

## i64_const
[[Return to contents]](#Contents)

## f32_const
[[Return to contents]](#Contents)

## f64_const
[[Return to contents]](#Contents)

## add
[[Return to contents]](#Contents)

## sub
[[Return to contents]](#Contents)

## mul
[[Return to contents]](#Contents)

## global_get
[[Return to contents]](#Contents)

## ref_null
[[Return to contents]](#Contents)

## ref_func
[[Return to contents]](#Contents)

## ref_func_import
[[Return to contents]](#Contents)

## FuncType
[[Return to contents]](#Contents)

## Function
[[Return to contents]](#Contents)

## abs
[[Return to contents]](#Contents)

## add
[[Return to contents]](#Contents)

## b_and
[[Return to contents]](#Contents)

## b_or
[[Return to contents]](#Contents)

## b_shl
[[Return to contents]](#Contents)

## b_shr
[[Return to contents]](#Contents)

## b_xor
[[Return to contents]](#Contents)

## c_block
[[Return to contents]](#Contents)

## c_br
[[Return to contents]](#Contents)

## c_br_if
[[Return to contents]](#Contents)

## c_else
[[Return to contents]](#Contents)

## c_end
[[Return to contents]](#Contents)

## c_if
[[Return to contents]](#Contents)

## c_loop
[[Return to contents]](#Contents)

## c_return
[[Return to contents]](#Contents)

## c_select
[[Return to contents]](#Contents)

## call
[[Return to contents]](#Contents)

## call_import
[[Return to contents]](#Contents)

## cast
[[Return to contents]](#Contents)

## cast_trapping
[[Return to contents]](#Contents)

## ceil
[[Return to contents]](#Contents)

## clz
[[Return to contents]](#Contents)

## copysign
[[Return to contents]](#Contents)

## ctz
[[Return to contents]](#Contents)

## data_drop
[[Return to contents]](#Contents)

## div
[[Return to contents]](#Contents)

## drop
[[Return to contents]](#Contents)

## eq
[[Return to contents]](#Contents)

## eqz
[[Return to contents]](#Contents)

## export_name
[[Return to contents]](#Contents)

## f32_const
[[Return to contents]](#Contents)

## f64_const
[[Return to contents]](#Contents)

## floor
[[Return to contents]](#Contents)

## ge
[[Return to contents]](#Contents)

## global_get
[[Return to contents]](#Contents)

## global_set
[[Return to contents]](#Contents)

## gt
[[Return to contents]](#Contents)

## i32_const
[[Return to contents]](#Contents)

## i64_const
[[Return to contents]](#Contents)

## le
[[Return to contents]](#Contents)

## load
[[Return to contents]](#Contents)

## load16
[[Return to contents]](#Contents)

## load32_i64
[[Return to contents]](#Contents)

## load8
[[Return to contents]](#Contents)

## local_get
[[Return to contents]](#Contents)

## local_set
[[Return to contents]](#Contents)

## local_tee
[[Return to contents]](#Contents)

## lt
[[Return to contents]](#Contents)

## max
[[Return to contents]](#Contents)

## memory_copy
[[Return to contents]](#Contents)

## memory_fill
[[Return to contents]](#Contents)

## memory_grow
[[Return to contents]](#Contents)

## memory_init
[[Return to contents]](#Contents)

## memory_size
[[Return to contents]](#Contents)

## min
[[Return to contents]](#Contents)

## mul
[[Return to contents]](#Contents)

## ne
[[Return to contents]](#Contents)

## nearest
[[Return to contents]](#Contents)

## neg
[[Return to contents]](#Contents)

## new_local
[[Return to contents]](#Contents)

## new_local_named
[[Return to contents]](#Contents)

## nop
[[Return to contents]](#Contents)

## patch
[[Return to contents]](#Contents)

## patch_pos
[[Return to contents]](#Contents)

## popcnt
[[Return to contents]](#Contents)

## ref_func
[[Return to contents]](#Contents)

## ref_func_import
[[Return to contents]](#Contents)

## ref_is_null
[[Return to contents]](#Contents)

## ref_null
[[Return to contents]](#Contents)

## reinterpret
[[Return to contents]](#Contents)

## rem
[[Return to contents]](#Contents)

## rotl
[[Return to contents]](#Contents)

## rotr
[[Return to contents]](#Contents)

## sign_extend16
[[Return to contents]](#Contents)

## sign_extend32
[[Return to contents]](#Contents)

## sign_extend8
[[Return to contents]](#Contents)

## sqrt
[[Return to contents]](#Contents)

## store
[[Return to contents]](#Contents)

## store16
[[Return to contents]](#Contents)

## store32_i64
[[Return to contents]](#Contents)

## store8
[[Return to contents]](#Contents)

## sub
[[Return to contents]](#Contents)

## trunc
[[Return to contents]](#Contents)

## unreachable
[[Return to contents]](#Contents)

## Module
[[Return to contents]](#Contents)

## assign_global_init
[[Return to contents]](#Contents)

## assign_memory
[[Return to contents]](#Contents)

## assign_start
[[Return to contents]](#Contents)

## commit
[[Return to contents]](#Contents)

## compile
[[Return to contents]](#Contents)

## enable_debug
[[Return to contents]](#Contents)

## new_data_segment
[[Return to contents]](#Contents)

## new_debug_function
[[Return to contents]](#Contents)

## new_function
[[Return to contents]](#Contents)

## new_function_import
[[Return to contents]](#Contents)

## new_function_import_debug
[[Return to contents]](#Contents)

## new_global
[[Return to contents]](#Contents)

## new_global_import
[[Return to contents]](#Contents)

## new_passive_data_segment
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:56
