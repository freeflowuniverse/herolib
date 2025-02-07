# module gg


## Contents
- [create_default_pass](#create_default_pass)
- [dpi_scale](#dpi_scale)
- [high_dpi](#high_dpi)
- [is_fullscreen](#is_fullscreen)
- [new_context](#new_context)
- [screen_size](#screen_size)
- [set_window_title](#set_window_title)
- [start](#start)
- [toggle_fullscreen](#toggle_fullscreen)
- [window_size](#window_size)
- [window_size_real_pixels](#window_size_real_pixels)
- [Color](#Color)
- [FNCb](#FNCb)
- [FNChar](#FNChar)
- [FNClick](#FNClick)
- [FNEvent](#FNEvent)
- [FNEvent2](#FNEvent2)
- [FNFail](#FNFail)
- [FNKeyDown](#FNKeyDown)
- [FNKeyUp](#FNKeyUp)
- [FNMove](#FNMove)
- [FNUnClick](#FNUnClick)
- [FT](#FT)
  - [flush](#flush)
- [TouchPoint](#TouchPoint)
- [EndEnum](#EndEnum)
- [ImageEffect](#ImageEffect)
- [KeyCode](#KeyCode)
- [Modifier](#Modifier)
- [MouseButton](#MouseButton)
- [MouseButtons](#MouseButtons)
- [PaintStyle](#PaintStyle)
- [PenLineType](#PenLineType)
- [Config](#Config)
- [Context](#Context)
  - [begin](#begin)
  - [cache_image](#cache_image)
  - [create_image](#create_image)
  - [create_image_from_byte_array](#create_image_from_byte_array)
  - [create_image_from_memory](#create_image_from_memory)
  - [create_image_with_size](#create_image_with_size)
  - [draw_arc_empty](#draw_arc_empty)
  - [draw_arc_filled](#draw_arc_filled)
  - [draw_arc_line](#draw_arc_line)
  - [draw_circle_empty](#draw_circle_empty)
  - [draw_circle_filled](#draw_circle_filled)
  - [draw_circle_line](#draw_circle_line)
  - [draw_circle_with_segments](#draw_circle_with_segments)
  - [draw_convex_poly](#draw_convex_poly)
  - [draw_cubic_bezier](#draw_cubic_bezier)
  - [draw_cubic_bezier_in_steps](#draw_cubic_bezier_in_steps)
  - [draw_cubic_bezier_recursive](#draw_cubic_bezier_recursive)
  - [draw_cubic_bezier_recursive_scalar](#draw_cubic_bezier_recursive_scalar)
  - [draw_ellipse_empty](#draw_ellipse_empty)
  - [draw_ellipse_filled](#draw_ellipse_filled)
  - [draw_image](#draw_image)
  - [draw_image_3d](#draw_image_3d)
  - [draw_image_by_id](#draw_image_by_id)
  - [draw_image_flipped](#draw_image_flipped)
  - [draw_image_part](#draw_image_part)
  - [draw_image_with_config](#draw_image_with_config)
  - [draw_line](#draw_line)
  - [draw_line_with_config](#draw_line_with_config)
  - [draw_pixel](#draw_pixel)
  - [draw_pixels](#draw_pixels)
  - [draw_poly_empty](#draw_poly_empty)
  - [draw_polygon_filled](#draw_polygon_filled)
  - [draw_rect](#draw_rect)
  - [draw_rect_empty](#draw_rect_empty)
  - [draw_rect_filled](#draw_rect_filled)
  - [draw_rounded_rect_empty](#draw_rounded_rect_empty)
  - [draw_rounded_rect_filled](#draw_rounded_rect_filled)
  - [draw_slice_empty](#draw_slice_empty)
  - [draw_slice_filled](#draw_slice_filled)
  - [draw_square_empty](#draw_square_empty)
  - [draw_square_filled](#draw_square_filled)
  - [draw_text](#draw_text)
  - [draw_text2](#draw_text2)
  - [draw_text_def](#draw_text_def)
  - [draw_text_default](#draw_text_default)
  - [draw_triangle_empty](#draw_triangle_empty)
  - [draw_triangle_filled](#draw_triangle_filled)
  - [end](#end)
  - [get_cached_image_by_idx](#get_cached_image_by_idx)
  - [has_text_style](#has_text_style)
  - [new_streaming_image](#new_streaming_image)
  - [quit](#quit)
  - [record_frame](#record_frame)
  - [refresh_ui](#refresh_ui)
  - [remove_cached_image_by_idx](#remove_cached_image_by_idx)
  - [resize](#resize)
  - [run](#run)
  - [scissor_rect](#scissor_rect)
  - [set_bg_color](#set_bg_color)
  - [set_text_cfg](#set_text_cfg)
  - [set_text_style](#set_text_style)
  - [show_fps](#show_fps)
  - [text_height](#text_height)
  - [text_size](#text_size)
  - [text_width](#text_width)
  - [update_pixel_data](#update_pixel_data)
  - [window_size](#window_size)
- [DrawImageConfig](#DrawImageConfig)
- [DrawPixelConfig](#DrawPixelConfig)
- [DrawRectParams](#DrawRectParams)
- [DrawTextParams](#DrawTextParams)
- [EndOptions](#EndOptions)
- [Event](#Event)
- [FPSConfig](#FPSConfig)
- [Image](#Image)
  - [init_sokol_image](#init_sokol_image)
  - [update_pixel_data](#update_pixel_data)
- [PenConfig](#PenConfig)
- [PipelineContainer](#PipelineContainer)
- [Rect](#Rect)
- [SSRecorderSettings](#SSRecorderSettings)
- [Size](#Size)
- [StreamingImageConfig](#StreamingImageConfig)

## create_default_pass
[[Return to contents]](#Contents)

## dpi_scale
[[Return to contents]](#Contents)

## high_dpi
[[Return to contents]](#Contents)

## is_fullscreen
[[Return to contents]](#Contents)

## new_context
[[Return to contents]](#Contents)

## screen_size
[[Return to contents]](#Contents)

## set_window_title
[[Return to contents]](#Contents)

## start
[[Return to contents]](#Contents)

## toggle_fullscreen
[[Return to contents]](#Contents)

## window_size
[[Return to contents]](#Contents)

## window_size_real_pixels
[[Return to contents]](#Contents)

## Color
[[Return to contents]](#Contents)

## FNCb
[[Return to contents]](#Contents)

## FNChar
[[Return to contents]](#Contents)

## FNClick
[[Return to contents]](#Contents)

## FNEvent
[[Return to contents]](#Contents)

## FNEvent2
[[Return to contents]](#Contents)

## FNFail
[[Return to contents]](#Contents)

## FNKeyDown
[[Return to contents]](#Contents)

## FNKeyUp
[[Return to contents]](#Contents)

## FNMove
[[Return to contents]](#Contents)

## FNUnClick
[[Return to contents]](#Contents)

## FT
## flush
[[Return to contents]](#Contents)

## TouchPoint
[[Return to contents]](#Contents)

## EndEnum
[[Return to contents]](#Contents)

## ImageEffect
[[Return to contents]](#Contents)

## KeyCode
[[Return to contents]](#Contents)

## Modifier
[[Return to contents]](#Contents)

## MouseButton
[[Return to contents]](#Contents)

## MouseButtons
[[Return to contents]](#Contents)

## PaintStyle
[[Return to contents]](#Contents)

## PenLineType
[[Return to contents]](#Contents)

## Config
[[Return to contents]](#Contents)

## Context
[[Return to contents]](#Contents)

## begin
[[Return to contents]](#Contents)

## cache_image
[[Return to contents]](#Contents)

## create_image
[[Return to contents]](#Contents)

## create_image_from_byte_array
[[Return to contents]](#Contents)

## create_image_from_memory
[[Return to contents]](#Contents)

## create_image_with_size
[[Return to contents]](#Contents)

## draw_arc_empty
[[Return to contents]](#Contents)

## draw_arc_filled
[[Return to contents]](#Contents)

## draw_arc_line
[[Return to contents]](#Contents)

## draw_circle_empty
[[Return to contents]](#Contents)

## draw_circle_filled
[[Return to contents]](#Contents)

## draw_circle_line
[[Return to contents]](#Contents)

## draw_circle_with_segments
[[Return to contents]](#Contents)

## draw_convex_poly
[[Return to contents]](#Contents)

## draw_cubic_bezier
[[Return to contents]](#Contents)

## draw_cubic_bezier_in_steps
[[Return to contents]](#Contents)

## draw_cubic_bezier_recursive
[[Return to contents]](#Contents)

## draw_cubic_bezier_recursive_scalar
[[Return to contents]](#Contents)

## draw_ellipse_empty
[[Return to contents]](#Contents)

## draw_ellipse_filled
[[Return to contents]](#Contents)

## draw_image
[[Return to contents]](#Contents)

## draw_image_3d
[[Return to contents]](#Contents)

## draw_image_by_id
[[Return to contents]](#Contents)

## draw_image_flipped
[[Return to contents]](#Contents)

## draw_image_part
[[Return to contents]](#Contents)

## draw_image_with_config
[[Return to contents]](#Contents)

## draw_line
[[Return to contents]](#Contents)

## draw_line_with_config
[[Return to contents]](#Contents)

## draw_pixel
[[Return to contents]](#Contents)

## draw_pixels
[[Return to contents]](#Contents)

## draw_poly_empty
[[Return to contents]](#Contents)

## draw_polygon_filled
[[Return to contents]](#Contents)

## draw_rect
[[Return to contents]](#Contents)

## draw_rect_empty
[[Return to contents]](#Contents)

## draw_rect_filled
[[Return to contents]](#Contents)

## draw_rounded_rect_empty
[[Return to contents]](#Contents)

## draw_rounded_rect_filled
[[Return to contents]](#Contents)

## draw_slice_empty
[[Return to contents]](#Contents)

## draw_slice_filled
[[Return to contents]](#Contents)

## draw_square_empty
[[Return to contents]](#Contents)

## draw_square_filled
[[Return to contents]](#Contents)

## draw_text
[[Return to contents]](#Contents)

## draw_text2
[[Return to contents]](#Contents)

## draw_text_def
[[Return to contents]](#Contents)

## draw_text_default
[[Return to contents]](#Contents)

## draw_triangle_empty
[[Return to contents]](#Contents)

## draw_triangle_filled
[[Return to contents]](#Contents)

## end
[[Return to contents]](#Contents)

## get_cached_image_by_idx
[[Return to contents]](#Contents)

## has_text_style
[[Return to contents]](#Contents)

## new_streaming_image
[[Return to contents]](#Contents)

## quit
[[Return to contents]](#Contents)

## record_frame
[[Return to contents]](#Contents)

## refresh_ui
[[Return to contents]](#Contents)

## remove_cached_image_by_idx
[[Return to contents]](#Contents)

## resize
[[Return to contents]](#Contents)

## run
[[Return to contents]](#Contents)

## scissor_rect
[[Return to contents]](#Contents)

## set_bg_color
[[Return to contents]](#Contents)

## set_text_cfg
[[Return to contents]](#Contents)

## set_text_style
[[Return to contents]](#Contents)

## show_fps
[[Return to contents]](#Contents)

## text_height
[[Return to contents]](#Contents)

## text_size
[[Return to contents]](#Contents)

## text_width
[[Return to contents]](#Contents)

## update_pixel_data
[[Return to contents]](#Contents)

## window_size
[[Return to contents]](#Contents)

## DrawImageConfig
[[Return to contents]](#Contents)

## DrawPixelConfig
[[Return to contents]](#Contents)

## DrawRectParams
[[Return to contents]](#Contents)

## DrawTextParams
[[Return to contents]](#Contents)

## EndOptions
[[Return to contents]](#Contents)

## Event
[[Return to contents]](#Contents)

## FPSConfig
[[Return to contents]](#Contents)

## Image
[[Return to contents]](#Contents)

## init_sokol_image
[[Return to contents]](#Contents)

## update_pixel_data
[[Return to contents]](#Contents)

## PenConfig
[[Return to contents]](#Contents)

## PipelineContainer
[[Return to contents]](#Contents)

## Rect
[[Return to contents]](#Contents)

## SSRecorderSettings
[[Return to contents]](#Contents)

## Size
[[Return to contents]](#Contents)

## StreamingImageConfig
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:55
