# module v.gen.native


## Contents
- [Constants](#Constants)
- [escape_string](#escape_string)
- [gen](#gen)
- [macho_test_new_gen](#macho_test_new_gen)
- [Amd64](#Amd64)
  - [pop](#pop)
  - [sub8](#sub8)
  - [sub](#sub)
  - [add](#add)
  - [add8](#add8)
  - [var_zero](#var_zero)
  - [rep_stosb](#rep_stosb)
  - [std](#std)
  - [cld](#cld)
  - [cld_repne_scasb](#cld_repne_scasb)
  - [xor](#xor)
  - [test_reg](#test_reg)
  - [inline_strlen](#inline_strlen)
  - [get_dllcall_addr](#get_dllcall_addr)
  - [dllcall](#dllcall)
  - [gen_print_reg](#gen_print_reg)
  - [gen_exit](#gen_exit)
  - [call_fn](#call_fn)
  - [builtin_decl](#builtin_decl)
  - [allocate_var_two_step](#allocate_var_two_step)
  - [allocate_var](#allocate_var)
- [Arm64](#Arm64)
  - [fn_decl](#fn_decl)
  - [call_fn](#call_fn)
  - [gen_exit](#gen_exit)
  - [gen_arm64_exit](#gen_arm64_exit)
  - [add](#add)
- [Gen](#Gen)
  - [ast_fetch_external_deps](#ast_fetch_external_deps)
  - [calculate_all_size_align](#calculate_all_size_align)
  - [calculate_enum_fields](#calculate_enum_fields)
  - [call_builtin](#call_builtin)
  - [create_executable](#create_executable)
  - [elf_string_table](#elf_string_table)
  - [find_o_path](#find_o_path)
  - [gen_dos_header](#gen_dos_header)
  - [gen_dos_stub](#gen_dos_stub)
  - [gen_pe_header](#gen_pe_header)
  - [gen_rela_section](#gen_rela_section)
  - [generate_builtins](#generate_builtins)
  - [generate_elf_footer](#generate_elf_footer)
  - [generate_footer](#generate_footer)
  - [generate_header](#generate_header)
  - [generate_linkable_elf_header](#generate_linkable_elf_header)
  - [generate_macho_footer](#generate_macho_footer)
  - [generate_macho_header](#generate_macho_header)
  - [generate_macho_object_header](#generate_macho_object_header)
  - [generate_pe_footer](#generate_pe_footer)
  - [generate_pe_header](#generate_pe_header)
  - [generate_simple_elf_header](#generate_simple_elf_header)
  - [get_builtin_arg_reg](#get_builtin_arg_reg)
  - [get_lpaths](#get_lpaths)
  - [has_external_deps](#has_external_deps)
  - [init_builtins](#init_builtins)
  - [link](#link)
  - [link_elf_file](#link_elf_file)
  - [n_error](#n_error)
  - [pos](#pos)
  - [prepend_vobjpath](#prepend_vobjpath)
  - [register_function_address](#register_function_address)
  - [stmts](#stmts)
  - [styp](#styp)
  - [symtab_get_index](#symtab_get_index)
  - [v_error](#v_error)
  - [warning](#warning)
  - [zeroes](#zeroes)

## Constants
[[Return to contents]](#Contents)

## escape_string
[[Return to contents]](#Contents)

## gen
[[Return to contents]](#Contents)

## macho_test_new_gen
[[Return to contents]](#Contents)

## Amd64
[[Return to contents]](#Contents)

## pop
[[Return to contents]](#Contents)

## sub8
[[Return to contents]](#Contents)

## sub
[[Return to contents]](#Contents)

## add
[[Return to contents]](#Contents)

## add8
[[Return to contents]](#Contents)

## var_zero
[[Return to contents]](#Contents)

## rep_stosb
[[Return to contents]](#Contents)

## std
[[Return to contents]](#Contents)

## cld
[[Return to contents]](#Contents)

## cld_repne_scasb
[[Return to contents]](#Contents)

## xor
[[Return to contents]](#Contents)

## test_reg
[[Return to contents]](#Contents)

## inline_strlen
[[Return to contents]](#Contents)

## get_dllcall_addr
[[Return to contents]](#Contents)

## dllcall
[[Return to contents]](#Contents)

## gen_print_reg
[[Return to contents]](#Contents)

## gen_exit
[[Return to contents]](#Contents)

## call_fn
[[Return to contents]](#Contents)

## builtin_decl
[[Return to contents]](#Contents)

## allocate_var_two_step
[[Return to contents]](#Contents)

## allocate_var
[[Return to contents]](#Contents)

## Arm64
[[Return to contents]](#Contents)

## fn_decl
[[Return to contents]](#Contents)

## call_fn
[[Return to contents]](#Contents)

## gen_exit
[[Return to contents]](#Contents)

## gen_arm64_exit
[[Return to contents]](#Contents)

## add
[[Return to contents]](#Contents)

## Gen
[[Return to contents]](#Contents)

## ast_fetch_external_deps
[[Return to contents]](#Contents)

## calculate_all_size_align
[[Return to contents]](#Contents)

## calculate_enum_fields
[[Return to contents]](#Contents)

## call_builtin
[[Return to contents]](#Contents)

## create_executable
[[Return to contents]](#Contents)

## elf_string_table
[[Return to contents]](#Contents)

## find_o_path
[[Return to contents]](#Contents)

## gen_dos_header
[[Return to contents]](#Contents)

## gen_dos_stub
[[Return to contents]](#Contents)

## gen_pe_header
[[Return to contents]](#Contents)

## gen_rela_section
[[Return to contents]](#Contents)

## generate_builtins
[[Return to contents]](#Contents)

## generate_elf_footer
[[Return to contents]](#Contents)

## generate_footer
[[Return to contents]](#Contents)

## generate_header
[[Return to contents]](#Contents)

## generate_linkable_elf_header
[[Return to contents]](#Contents)

## generate_macho_footer
[[Return to contents]](#Contents)

## generate_macho_header
[[Return to contents]](#Contents)

## generate_macho_object_header
[[Return to contents]](#Contents)

## generate_pe_footer
[[Return to contents]](#Contents)

## generate_pe_header
[[Return to contents]](#Contents)

## generate_simple_elf_header
[[Return to contents]](#Contents)

## get_builtin_arg_reg
[[Return to contents]](#Contents)

## get_lpaths
[[Return to contents]](#Contents)

## has_external_deps
[[Return to contents]](#Contents)

## init_builtins
[[Return to contents]](#Contents)

## link
[[Return to contents]](#Contents)

## link_elf_file
[[Return to contents]](#Contents)

## n_error
[[Return to contents]](#Contents)

## pos
[[Return to contents]](#Contents)

## prepend_vobjpath
[[Return to contents]](#Contents)

## register_function_address
[[Return to contents]](#Contents)

## stmts
[[Return to contents]](#Contents)

## styp
[[Return to contents]](#Contents)

## symtab_get_index
[[Return to contents]](#Contents)

## v_error
[[Return to contents]](#Contents)

## warning
[[Return to contents]](#Contents)

## zeroes
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:56
