# module sokol.sapp


## Contents
- [android_get_native_activity](#android_get_native_activity)
- [cancel_quit](#cancel_quit)
- [color_format](#color_format)
- [consume_event](#consume_event)
- [create_default_pass](#create_default_pass)
- [create_desc](#create_desc)
- [d3d11_get_depth_stencil_view](#d3d11_get_depth_stencil_view)
- [d3d11_get_device](#d3d11_get_device)
- [d3d11_get_device_context](#d3d11_get_device_context)
- [d3d11_get_render_view](#d3d11_get_render_view)
- [d3d11_get_resolve_view](#d3d11_get_resolve_view)
- [depth_format](#depth_format)
- [dpi_scale](#dpi_scale)
- [frame_count](#frame_count)
- [frame_duration](#frame_duration)
- [get_clipboard_string](#get_clipboard_string)
- [get_dropped_file_path](#get_dropped_file_path)
- [get_num_dropped_files](#get_num_dropped_files)
- [gl_get_framebuffer](#gl_get_framebuffer)
- [glue_environment](#glue_environment)
- [glue_swapchain](#glue_swapchain)
- [height](#height)
- [high_dpi](#high_dpi)
- [html5_ask_leave_site](#html5_ask_leave_site)
- [ios_get_window](#ios_get_window)
- [is_fullscreen](#is_fullscreen)
- [isvalid](#isvalid)
- [keyboard_shown](#keyboard_shown)
- [lock_mouse](#lock_mouse)
- [macos_get_window](#macos_get_window)
- [metal_get_current_drawable](#metal_get_current_drawable)
- [metal_get_depth_stencil_texture](#metal_get_depth_stencil_texture)
- [metal_get_device](#metal_get_device)
- [metal_get_msaa_color_texture](#metal_get_msaa_color_texture)
- [mouse_locked](#mouse_locked)
- [mouse_shown](#mouse_shown)
- [query_desc](#query_desc)
- [quit](#quit)
- [request_quit](#request_quit)
- [run](#run)
- [sample_count](#sample_count)
- [screenshot](#screenshot)
- [screenshot_png](#screenshot_png)
- [screenshot_ppm](#screenshot_ppm)
- [screenshot_window](#screenshot_window)
- [set_clipboard_string](#set_clipboard_string)
- [set_mouse_cursor](#set_mouse_cursor)
- [show_keyboard](#show_keyboard)
- [show_mouse](#show_mouse)
- [toggle_fullscreen](#toggle_fullscreen)
- [userdata](#userdata)
- [wgpu_get_depth_stencil_view](#wgpu_get_depth_stencil_view)
- [wgpu_get_device](#wgpu_get_device)
- [wgpu_get_render_view](#wgpu_get_render_view)
- [wgpu_get_resolve_view](#wgpu_get_resolve_view)
- [width](#width)
- [win32_get_hwnd](#win32_get_hwnd)
- [Desc](#Desc)
- [Event](#Event)
- [IconDesc](#IconDesc)
- [ImageDesc](#ImageDesc)
- [Range](#Range)
- [TouchPoint](#TouchPoint)
- [EventType](#EventType)
- [KeyCode](#KeyCode)
- [Modifier](#Modifier)
- [MouseButton](#MouseButton)
- [MouseCursor](#MouseCursor)
- [TouchToolType](#TouchToolType)
- [C.sapp_allocator](#C.sapp_allocator)
- [C.sapp_desc](#C.sapp_desc)
- [C.sapp_event](#C.sapp_event)
  - [str](#str)
- [C.sapp_icon_desc](#C.sapp_icon_desc)
- [C.sapp_image_desc](#C.sapp_image_desc)
- [C.sapp_logger](#C.sapp_logger)
- [C.sapp_range](#C.sapp_range)
- [C.sapp_touchpoint](#C.sapp_touchpoint)
- [Screenshot](#Screenshot)
  - [free](#free)
  - [destroy](#destroy)

## android_get_native_activity
[[Return to contents]](#Contents)

## cancel_quit
[[Return to contents]](#Contents)

## color_format
[[Return to contents]](#Contents)

## consume_event
[[Return to contents]](#Contents)

## create_default_pass
[[Return to contents]](#Contents)

## create_desc
[[Return to contents]](#Contents)

## d3d11_get_depth_stencil_view
[[Return to contents]](#Contents)

## d3d11_get_device
[[Return to contents]](#Contents)

## d3d11_get_device_context
[[Return to contents]](#Contents)

## d3d11_get_render_view
[[Return to contents]](#Contents)

## d3d11_get_resolve_view
[[Return to contents]](#Contents)

## depth_format
[[Return to contents]](#Contents)

## dpi_scale
[[Return to contents]](#Contents)

## frame_count
[[Return to contents]](#Contents)

## frame_duration
[[Return to contents]](#Contents)

## get_clipboard_string
[[Return to contents]](#Contents)

## get_dropped_file_path
[[Return to contents]](#Contents)

## get_num_dropped_files
[[Return to contents]](#Contents)

## gl_get_framebuffer
[[Return to contents]](#Contents)

## glue_environment
[[Return to contents]](#Contents)

## glue_swapchain
[[Return to contents]](#Contents)

## height
[[Return to contents]](#Contents)

## high_dpi
[[Return to contents]](#Contents)

## html5_ask_leave_site
[[Return to contents]](#Contents)

## ios_get_window
[[Return to contents]](#Contents)

## is_fullscreen
[[Return to contents]](#Contents)

## isvalid
[[Return to contents]](#Contents)

## keyboard_shown
[[Return to contents]](#Contents)

## lock_mouse
[[Return to contents]](#Contents)

## macos_get_window
[[Return to contents]](#Contents)

## metal_get_current_drawable
[[Return to contents]](#Contents)

## metal_get_depth_stencil_texture
[[Return to contents]](#Contents)

## metal_get_device
[[Return to contents]](#Contents)

## metal_get_msaa_color_texture
[[Return to contents]](#Contents)

## mouse_locked
[[Return to contents]](#Contents)

## mouse_shown
[[Return to contents]](#Contents)

## query_desc
[[Return to contents]](#Contents)

## quit
[[Return to contents]](#Contents)

## request_quit
[[Return to contents]](#Contents)

## run
[[Return to contents]](#Contents)

## sample_count
[[Return to contents]](#Contents)

## screenshot
[[Return to contents]](#Contents)

## screenshot_png
[[Return to contents]](#Contents)

## screenshot_ppm
[[Return to contents]](#Contents)

## screenshot_window
[[Return to contents]](#Contents)

## set_clipboard_string
[[Return to contents]](#Contents)

## set_mouse_cursor
[[Return to contents]](#Contents)

## show_keyboard
[[Return to contents]](#Contents)

## show_mouse
[[Return to contents]](#Contents)

## toggle_fullscreen
[[Return to contents]](#Contents)

## userdata
[[Return to contents]](#Contents)

## wgpu_get_depth_stencil_view
[[Return to contents]](#Contents)

## wgpu_get_device
[[Return to contents]](#Contents)

## wgpu_get_render_view
[[Return to contents]](#Contents)

## wgpu_get_resolve_view
[[Return to contents]](#Contents)

## width
[[Return to contents]](#Contents)

## win32_get_hwnd
[[Return to contents]](#Contents)

## Desc
[[Return to contents]](#Contents)

## Event
[[Return to contents]](#Contents)

## IconDesc
[[Return to contents]](#Contents)

## ImageDesc
[[Return to contents]](#Contents)

## Range
[[Return to contents]](#Contents)

## TouchPoint
[[Return to contents]](#Contents)

## EventType
[[Return to contents]](#Contents)

## KeyCode
[[Return to contents]](#Contents)

## Modifier
[[Return to contents]](#Contents)

## MouseButton
[[Return to contents]](#Contents)

## MouseCursor
[[Return to contents]](#Contents)

## TouchToolType
[[Return to contents]](#Contents)

## C.sapp_allocator
[[Return to contents]](#Contents)

## C.sapp_desc
[[Return to contents]](#Contents)

## C.sapp_event
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## C.sapp_icon_desc
[[Return to contents]](#Contents)

## C.sapp_image_desc
[[Return to contents]](#Contents)

## C.sapp_logger
[[Return to contents]](#Contents)

## C.sapp_range
[[Return to contents]](#Contents)

## C.sapp_touchpoint
[[Return to contents]](#Contents)

## Screenshot
[[Return to contents]](#Contents)

## free
[[Return to contents]](#Contents)

## destroy
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:55
