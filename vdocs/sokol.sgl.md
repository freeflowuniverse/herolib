# module sokol.sgl


## Contents
- [Constants](#Constants)
- [begin_line_strip](#begin_line_strip)
- [begin_lines](#begin_lines)
- [begin_points](#begin_points)
- [begin_quads](#begin_quads)
- [begin_triangle_strip](#begin_triangle_strip)
- [begin_triangles](#begin_triangles)
- [c1i](#c1i)
- [c3b](#c3b)
- [c3f](#c3f)
- [c4b](#c4b)
- [c4f](#c4f)
- [context_draw](#context_draw)
- [context_error](#context_error)
- [context_make_pipeline](#context_make_pipeline)
- [default_context](#default_context)
- [default_pipeline](#default_pipeline)
- [defaults](#defaults)
- [deg](#deg)
- [destroy_context](#destroy_context)
- [destroy_pipeline](#destroy_pipeline)
- [disable_texture](#disable_texture)
- [draw](#draw)
- [enable_texture](#enable_texture)
- [end](#end)
- [error](#error)
- [frustum](#frustum)
- [get_context](#get_context)
- [load_default_pipeline](#load_default_pipeline)
- [load_identity](#load_identity)
- [load_matrix](#load_matrix)
- [load_pipeline](#load_pipeline)
- [load_transpose_matrix](#load_transpose_matrix)
- [lookat](#lookat)
- [make_context](#make_context)
- [make_pipeline](#make_pipeline)
- [matrix_mode_modelview](#matrix_mode_modelview)
- [matrix_mode_projection](#matrix_mode_projection)
- [matrix_mode_texture](#matrix_mode_texture)
- [mult_matrix](#mult_matrix)
- [mult_transpose_matrix](#mult_transpose_matrix)
- [ortho](#ortho)
- [perspective](#perspective)
- [point_size](#point_size)
- [pop_matrix](#pop_matrix)
- [pop_pipeline](#pop_pipeline)
- [push_matrix](#push_matrix)
- [push_pipeline](#push_pipeline)
- [rad](#rad)
- [rotate](#rotate)
- [scale](#scale)
- [scissor_rect](#scissor_rect)
- [scissor_rectf](#scissor_rectf)
- [set_context](#set_context)
- [setup](#setup)
- [shutdown](#shutdown)
- [t2f](#t2f)
- [texture](#texture)
- [translate](#translate)
- [v2f](#v2f)
- [v2f_c1i](#v2f_c1i)
- [v2f_c3b](#v2f_c3b)
- [v2f_c3f](#v2f_c3f)
- [v2f_c4b](#v2f_c4b)
- [v2f_c4f](#v2f_c4f)
- [v2f_t2f](#v2f_t2f)
- [v2f_t2f_c1i](#v2f_t2f_c1i)
- [v2f_t2f_c3b](#v2f_t2f_c3b)
- [v2f_t2f_c3f](#v2f_t2f_c3f)
- [v2f_t2f_c4b](#v2f_t2f_c4b)
- [v2f_t2f_c4f](#v2f_t2f_c4f)
- [v3f](#v3f)
- [v3f_c1i](#v3f_c1i)
- [v3f_c3b](#v3f_c3b)
- [v3f_c3f](#v3f_c3f)
- [v3f_c4b](#v3f_c4b)
- [v3f_c4f](#v3f_c4f)
- [v3f_t2f](#v3f_t2f)
- [v3f_t2f_c1i](#v3f_t2f_c1i)
- [v3f_t2f_c3b](#v3f_t2f_c3b)
- [v3f_t2f_c3f](#v3f_t2f_c3f)
- [v3f_t2f_c4b](#v3f_t2f_c4b)
- [v3f_t2f_c4f](#v3f_t2f_c4f)
- [viewport](#viewport)
- [Context](#Context)
- [ContextDesc](#ContextDesc)
- [Desc](#Desc)
- [Pipeline](#Pipeline)
- [SglError](#SglError)
- [C.sgl_allocator_t](#C.sgl_allocator_t)
- [C.sgl_context](#C.sgl_context)
- [C.sgl_context_desc_t](#C.sgl_context_desc_t)
- [C.sgl_desc_t](#C.sgl_desc_t)
- [C.sgl_logger_t](#C.sgl_logger_t)
- [C.sgl_pipeline](#C.sgl_pipeline)

## Constants
[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

## begin_line_strip
[[Return to contents]](#Contents)

## begin_lines
[[Return to contents]](#Contents)

## begin_points
[[Return to contents]](#Contents)

## begin_quads
[[Return to contents]](#Contents)

## begin_triangle_strip
[[Return to contents]](#Contents)

## begin_triangles
[[Return to contents]](#Contents)

## c1i
[[Return to contents]](#Contents)

## c3b
[[Return to contents]](#Contents)

## c3f
[[Return to contents]](#Contents)

## c4b
[[Return to contents]](#Contents)

## c4f
[[Return to contents]](#Contents)

## context_draw
[[Return to contents]](#Contents)

## context_error
[[Return to contents]](#Contents)

## context_make_pipeline
[[Return to contents]](#Contents)

## default_context
[[Return to contents]](#Contents)

## default_pipeline
[[Return to contents]](#Contents)

## defaults
[[Return to contents]](#Contents)

## deg
[[Return to contents]](#Contents)

## destroy_context
[[Return to contents]](#Contents)

## destroy_pipeline
[[Return to contents]](#Contents)

## disable_texture
[[Return to contents]](#Contents)

## draw
[[Return to contents]](#Contents)

## enable_texture
[[Return to contents]](#Contents)

## end
[[Return to contents]](#Contents)

## error
[[Return to contents]](#Contents)

## frustum
[[Return to contents]](#Contents)

## get_context
[[Return to contents]](#Contents)

## load_default_pipeline
[[Return to contents]](#Contents)

## load_identity
[[Return to contents]](#Contents)

## load_matrix
[[Return to contents]](#Contents)

## load_pipeline
[[Return to contents]](#Contents)

## load_transpose_matrix
[[Return to contents]](#Contents)

## lookat
[[Return to contents]](#Contents)

## make_context
[[Return to contents]](#Contents)

## make_pipeline
[[Return to contents]](#Contents)

## matrix_mode_modelview
[[Return to contents]](#Contents)

## matrix_mode_projection
[[Return to contents]](#Contents)

## matrix_mode_texture
[[Return to contents]](#Contents)

## mult_matrix
[[Return to contents]](#Contents)

## mult_transpose_matrix
[[Return to contents]](#Contents)

## ortho
[[Return to contents]](#Contents)

## perspective
[[Return to contents]](#Contents)

## point_size
[[Return to contents]](#Contents)

## pop_matrix
[[Return to contents]](#Contents)

## pop_pipeline
[[Return to contents]](#Contents)

## push_matrix
[[Return to contents]](#Contents)

## push_pipeline
[[Return to contents]](#Contents)

## rad
[[Return to contents]](#Contents)

## rotate
[[Return to contents]](#Contents)

## scale
[[Return to contents]](#Contents)

## scissor_rect
[[Return to contents]](#Contents)

## scissor_rectf
[[Return to contents]](#Contents)

## set_context
[[Return to contents]](#Contents)

## setup
[[Return to contents]](#Contents)

## shutdown
[[Return to contents]](#Contents)

## t2f
[[Return to contents]](#Contents)

## texture
[[Return to contents]](#Contents)

## translate
[[Return to contents]](#Contents)

## v2f
[[Return to contents]](#Contents)

## v2f_c1i
[[Return to contents]](#Contents)

## v2f_c3b
[[Return to contents]](#Contents)

## v2f_c3f
[[Return to contents]](#Contents)

## v2f_c4b
[[Return to contents]](#Contents)

## v2f_c4f
[[Return to contents]](#Contents)

## v2f_t2f
[[Return to contents]](#Contents)

## v2f_t2f_c1i
[[Return to contents]](#Contents)

## v2f_t2f_c3b
[[Return to contents]](#Contents)

## v2f_t2f_c3f
[[Return to contents]](#Contents)

## v2f_t2f_c4b
[[Return to contents]](#Contents)

## v2f_t2f_c4f
[[Return to contents]](#Contents)

## v3f
[[Return to contents]](#Contents)

## v3f_c1i
[[Return to contents]](#Contents)

## v3f_c3b
[[Return to contents]](#Contents)

## v3f_c3f
[[Return to contents]](#Contents)

## v3f_c4b
[[Return to contents]](#Contents)

## v3f_c4f
[[Return to contents]](#Contents)

## v3f_t2f
[[Return to contents]](#Contents)

## v3f_t2f_c1i
[[Return to contents]](#Contents)

## v3f_t2f_c3b
[[Return to contents]](#Contents)

## v3f_t2f_c3f
[[Return to contents]](#Contents)

## v3f_t2f_c4b
[[Return to contents]](#Contents)

## v3f_t2f_c4f
[[Return to contents]](#Contents)

## viewport
[[Return to contents]](#Contents)

## Context
[[Return to contents]](#Contents)

## ContextDesc
[[Return to contents]](#Contents)

## Desc
[[Return to contents]](#Contents)

## Pipeline
[[Return to contents]](#Contents)

## SglError
[[Return to contents]](#Contents)

## C.sgl_allocator_t
[[Return to contents]](#Contents)

## C.sgl_context
[[Return to contents]](#Contents)

## C.sgl_context_desc_t
[[Return to contents]](#Contents)

## C.sgl_desc_t
[[Return to contents]](#Contents)

## C.sgl_logger_t
[[Return to contents]](#Contents)

## C.sgl_pipeline
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:55
