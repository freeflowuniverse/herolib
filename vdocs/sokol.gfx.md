# module sokol.gfx


## Contents
- [Constants](#Constants)
- [append_buffer](#append_buffer)
- [apply_bindings](#apply_bindings)
- [apply_pipeline](#apply_pipeline)
- [apply_scissor_rect](#apply_scissor_rect)
- [apply_uniforms](#apply_uniforms)
- [apply_viewport](#apply_viewport)
- [begin_pass](#begin_pass)
- [commit](#commit)
- [create_clear_pass_action](#create_clear_pass_action)
- [destroy_attachments](#destroy_attachments)
- [destroy_buffer](#destroy_buffer)
- [destroy_image](#destroy_image)
- [destroy_pipeline](#destroy_pipeline)
- [destroy_sampler](#destroy_sampler)
- [destroy_shader](#destroy_shader)
- [disable_frame_stats](#disable_frame_stats)
- [draw](#draw)
- [enable_frame_stats](#enable_frame_stats)
- [end_pass](#end_pass)
- [frame_stats_enabled](#frame_stats_enabled)
- [is_valid](#is_valid)
- [make_attachments](#make_attachments)
- [make_buffer](#make_buffer)
- [make_image](#make_image)
- [make_pipeline](#make_pipeline)
- [make_sampler](#make_sampler)
- [make_shader](#make_shader)
- [query_attachments_defaults](#query_attachments_defaults)
- [query_attachments_info](#query_attachments_info)
- [query_attachments_state](#query_attachments_state)
- [query_backend](#query_backend)
- [query_buffer_defaults](#query_buffer_defaults)
- [query_buffer_info](#query_buffer_info)
- [query_buffer_overflow](#query_buffer_overflow)
- [query_buffer_state](#query_buffer_state)
- [query_desc](#query_desc)
- [query_features](#query_features)
- [query_frame_stats](#query_frame_stats)
- [query_image_defaults](#query_image_defaults)
- [query_image_info](#query_image_info)
- [query_image_state](#query_image_state)
- [query_limits](#query_limits)
- [query_pipeline_defaults](#query_pipeline_defaults)
- [query_pipeline_info](#query_pipeline_info)
- [query_pipeline_state](#query_pipeline_state)
- [query_pixelformat](#query_pixelformat)
- [query_shader_defaults](#query_shader_defaults)
- [query_shader_info](#query_shader_info)
- [query_shader_state](#query_shader_state)
- [reset_state_cache](#reset_state_cache)
- [setup](#setup)
- [shutdown](#shutdown)
- [update_buffer](#update_buffer)
- [update_image](#update_image)
- [AttachmentDesc](#AttachmentDesc)
- [Attachments](#Attachments)
- [AttachmentsDesc](#AttachmentsDesc)
- [AttachmentsInfo](#AttachmentsInfo)
- [Bindings](#Bindings)
  - [set_vert_image](#set_vert_image)
  - [set_frag_image](#set_frag_image)
  - [update_vert_buffer](#update_vert_buffer)
  - [append_vert_buffer](#append_vert_buffer)
  - [update_index_buffer](#update_index_buffer)
  - [append_index_buffer](#append_index_buffer)
- [BlendState](#BlendState)
- [Buffer](#Buffer)
  - [free](#free)
- [BufferDesc](#BufferDesc)
- [BufferInfo](#BufferInfo)
- [Color](#Color)
- [ColorAttachmentAction](#ColorAttachmentAction)
- [ColorTargetState](#ColorTargetState)
- [CommitListener](#CommitListener)
- [D3d11Environment](#D3d11Environment)
- [D3d11Swapchain](#D3d11Swapchain)
- [DepthAttachmentAction](#DepthAttachmentAction)
- [DepthState](#DepthState)
- [Desc](#Desc)
- [Environment](#Environment)
- [EnvironmentDefaults](#EnvironmentDefaults)
- [Features](#Features)
- [FrameStats](#FrameStats)
- [FrameStatsD3D11](#FrameStatsD3D11)
- [FrameStatsD3D11Bindings](#FrameStatsD3D11Bindings)
- [FrameStatsD3D11Draw](#FrameStatsD3D11Draw)
- [FrameStatsD3D11Pass](#FrameStatsD3D11Pass)
- [FrameStatsD3D11Pipeline](#FrameStatsD3D11Pipeline)
- [FrameStatsD3D11Uniforms](#FrameStatsD3D11Uniforms)
- [FrameStatsGL](#FrameStatsGL)
- [FrameStatsMetal](#FrameStatsMetal)
- [FrameStatsMetalBindings](#FrameStatsMetalBindings)
- [FrameStatsMetalIdpool](#FrameStatsMetalIdpool)
- [FrameStatsMetalPipeline](#FrameStatsMetalPipeline)
- [FrameStatsMetalUniforms](#FrameStatsMetalUniforms)
- [FrameStatsWGPU](#FrameStatsWGPU)
- [FrameStatsWGPUBindings](#FrameStatsWGPUBindings)
- [FrameStatsWGPUUniforms](#FrameStatsWGPUUniforms)
- [GlSwapchain](#GlSwapchain)
- [Image](#Image)
  - [free](#free)
- [ImageData](#ImageData)
- [ImageDesc](#ImageDesc)
- [ImageInfo](#ImageInfo)
- [Limits](#Limits)
- [MetalEnvironment](#MetalEnvironment)
- [MetalSwapchain](#MetalSwapchain)
- [Pass](#Pass)
- [PassAction](#PassAction)
- [Pipeline](#Pipeline)
- [PipelineDesc](#PipelineDesc)
- [PipelineInfo](#PipelineInfo)
- [PixelFormatInfo](#PixelFormatInfo)
- [Range](#Range)
- [Sampler](#Sampler)
- [SamplerDesc](#SamplerDesc)
- [Shader](#Shader)
  - [free](#free)
- [ShaderAttrDesc](#ShaderAttrDesc)
- [ShaderDesc](#ShaderDesc)
  - [make_shader](#make_shader)
- [ShaderImageDesc](#ShaderImageDesc)
- [ShaderImageSamplerPairDesc](#ShaderImageSamplerPairDesc)
- [ShaderInfo](#ShaderInfo)
- [ShaderSamplerDesc](#ShaderSamplerDesc)
- [ShaderStageDesc](#ShaderStageDesc)
  - [set_image](#set_image)
- [ShaderStorageBufferDesc](#ShaderStorageBufferDesc)
- [ShaderUniformBlockDesc](#ShaderUniformBlockDesc)
- [ShaderUniformDesc](#ShaderUniformDesc)
- [SlotInfo](#SlotInfo)
- [StageBindings](#StageBindings)
- [StencilAttachmentAction](#StencilAttachmentAction)
- [StencilFaceState](#StencilFaceState)
- [StencilState](#StencilState)
- [Swapchain](#Swapchain)
- [VertexAttrDesc](#VertexAttrDesc)
- [VertexBufferLayoutState](#VertexBufferLayoutState)
- [VertexLayoutState](#VertexLayoutState)
- [WgpuEnvironment](#WgpuEnvironment)
- [WgpuSwapchain](#WgpuSwapchain)
- [Backend](#Backend)
- [BlendFactor](#BlendFactor)
- [BlendOp](#BlendOp)
- [BorderColor](#BorderColor)
- [BufferType](#BufferType)
- [ColorMask](#ColorMask)
- [CompareFunc](#CompareFunc)
- [CubeFace](#CubeFace)
- [CullMode](#CullMode)
- [FaceWinding](#FaceWinding)
- [Filter](#Filter)
- [ImageSampleType](#ImageSampleType)
- [ImageType](#ImageType)
- [IndexType](#IndexType)
- [LoadAction](#LoadAction)
- [PixelFormat](#PixelFormat)
- [PrimitiveType](#PrimitiveType)
- [ResourceState](#ResourceState)
- [SamplerType](#SamplerType)
- [ShaderStage](#ShaderStage)
- [StencilOp](#StencilOp)
- [StoreAction](#StoreAction)
- [UniformLayout](#UniformLayout)
- [UniformType](#UniformType)
- [Usage](#Usage)
- [VertexFormat](#VertexFormat)
- [VertexStep](#VertexStep)
- [Wrap](#Wrap)
- [C.sg_allocator](#C.sg_allocator)
- [C.sg_attachment_desc](#C.sg_attachment_desc)
- [C.sg_attachments](#C.sg_attachments)
  - [free](#free)
- [C.sg_attachments_desc](#C.sg_attachments_desc)
- [C.sg_attachments_info](#C.sg_attachments_info)
- [C.sg_bindings](#C.sg_bindings)
- [C.sg_blend_state](#C.sg_blend_state)
- [C.sg_buffer](#C.sg_buffer)
- [C.sg_buffer_desc](#C.sg_buffer_desc)
- [C.sg_buffer_info](#C.sg_buffer_info)
- [C.sg_color](#C.sg_color)
- [C.sg_color_attachment_action](#C.sg_color_attachment_action)
- [C.sg_color_target_state](#C.sg_color_target_state)
- [C.sg_commit_listener](#C.sg_commit_listener)
- [C.sg_d3d11_environment](#C.sg_d3d11_environment)
- [C.sg_d3d11_swapchain](#C.sg_d3d11_swapchain)
- [C.sg_depth_attachment_action](#C.sg_depth_attachment_action)
- [C.sg_depth_state](#C.sg_depth_state)
- [C.sg_desc](#C.sg_desc)
- [C.sg_environment](#C.sg_environment)
- [C.sg_environment_defaults](#C.sg_environment_defaults)
- [C.sg_features](#C.sg_features)
- [C.sg_frame_stats](#C.sg_frame_stats)
- [C.sg_frame_stats_d3d11](#C.sg_frame_stats_d3d11)
- [C.sg_frame_stats_d3d11_bindings](#C.sg_frame_stats_d3d11_bindings)
- [C.sg_frame_stats_d3d11_draw](#C.sg_frame_stats_d3d11_draw)
- [C.sg_frame_stats_d3d11_pass](#C.sg_frame_stats_d3d11_pass)
- [C.sg_frame_stats_d3d11_pipeline](#C.sg_frame_stats_d3d11_pipeline)
- [C.sg_frame_stats_d3d11_uniforms](#C.sg_frame_stats_d3d11_uniforms)
- [C.sg_frame_stats_gl](#C.sg_frame_stats_gl)
- [C.sg_frame_stats_metal](#C.sg_frame_stats_metal)
- [C.sg_frame_stats_metal_bindings](#C.sg_frame_stats_metal_bindings)
- [C.sg_frame_stats_metal_idpool](#C.sg_frame_stats_metal_idpool)
- [C.sg_frame_stats_metal_pipeline](#C.sg_frame_stats_metal_pipeline)
- [C.sg_frame_stats_metal_uniforms](#C.sg_frame_stats_metal_uniforms)
- [C.sg_frame_stats_wgpu](#C.sg_frame_stats_wgpu)
- [C.sg_frame_stats_wgpu_bindings](#C.sg_frame_stats_wgpu_bindings)
- [C.sg_frame_stats_wgpu_uniforms](#C.sg_frame_stats_wgpu_uniforms)
- [C.sg_gl_swapchain](#C.sg_gl_swapchain)
- [C.sg_image](#C.sg_image)
- [C.sg_image_data](#C.sg_image_data)
- [C.sg_image_desc](#C.sg_image_desc)
- [C.sg_image_info](#C.sg_image_info)
- [C.sg_limits](#C.sg_limits)
- [C.sg_logger](#C.sg_logger)
- [C.sg_metal_environment](#C.sg_metal_environment)
- [C.sg_metal_swapchain](#C.sg_metal_swapchain)
- [C.sg_pass](#C.sg_pass)
- [C.sg_pass_action](#C.sg_pass_action)
- [C.sg_pipeline](#C.sg_pipeline)
  - [free](#free)
- [C.sg_pipeline_desc](#C.sg_pipeline_desc)
- [C.sg_pipeline_info](#C.sg_pipeline_info)
- [C.sg_pixelformat_info](#C.sg_pixelformat_info)
- [C.sg_range](#C.sg_range)
- [C.sg_sampler](#C.sg_sampler)
- [C.sg_sampler_desc](#C.sg_sampler_desc)
- [C.sg_sampler_info](#C.sg_sampler_info)
- [C.sg_shader](#C.sg_shader)
- [C.sg_shader_attr_desc](#C.sg_shader_attr_desc)
- [C.sg_shader_desc](#C.sg_shader_desc)
  - [set_vert_src](#set_vert_src)
  - [set_frag_src](#set_frag_src)
  - [set_vert_image](#set_vert_image)
  - [set_frag_image](#set_frag_image)
  - [set_vert_uniform_block_size](#set_vert_uniform_block_size)
  - [set_frag_uniform_block_size](#set_frag_uniform_block_size)
  - [set_vert_uniform](#set_vert_uniform)
  - [set_frag_uniform](#set_frag_uniform)
- [C.sg_shader_image_desc](#C.sg_shader_image_desc)
- [C.sg_shader_image_sampler_pair_desc](#C.sg_shader_image_sampler_pair_desc)
- [C.sg_shader_info](#C.sg_shader_info)
- [C.sg_shader_sampler_desc](#C.sg_shader_sampler_desc)
- [C.sg_shader_stage_desc](#C.sg_shader_stage_desc)
- [C.sg_shader_storage_buffer_desc](#C.sg_shader_storage_buffer_desc)
- [C.sg_shader_uniform_block_desc](#C.sg_shader_uniform_block_desc)
- [C.sg_shader_uniform_desc](#C.sg_shader_uniform_desc)
- [C.sg_slot_info](#C.sg_slot_info)
- [C.sg_stage_bindings](#C.sg_stage_bindings)
- [C.sg_stencil_attachment_action](#C.sg_stencil_attachment_action)
- [C.sg_stencil_face_state](#C.sg_stencil_face_state)
- [C.sg_stencil_state](#C.sg_stencil_state)
- [C.sg_swapchain](#C.sg_swapchain)
- [C.sg_trace_hooks](#C.sg_trace_hooks)
- [C.sg_vertex_attr_state](#C.sg_vertex_attr_state)
- [C.sg_vertex_buffer_layout_state](#C.sg_vertex_buffer_layout_state)
- [C.sg_vertex_layout_state](#C.sg_vertex_layout_state)
- [C.sg_wgpu_environment](#C.sg_wgpu_environment)
- [C.sg_wgpu_swapchain](#C.sg_wgpu_swapchain)

## Constants
[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

## append_buffer
[[Return to contents]](#Contents)

## apply_bindings
[[Return to contents]](#Contents)

## apply_pipeline
[[Return to contents]](#Contents)

## apply_scissor_rect
[[Return to contents]](#Contents)

## apply_uniforms
[[Return to contents]](#Contents)

## apply_viewport
[[Return to contents]](#Contents)

## begin_pass
[[Return to contents]](#Contents)

## commit
[[Return to contents]](#Contents)

## create_clear_pass_action
[[Return to contents]](#Contents)

## destroy_attachments
[[Return to contents]](#Contents)

## destroy_buffer
[[Return to contents]](#Contents)

## destroy_image
[[Return to contents]](#Contents)

## destroy_pipeline
[[Return to contents]](#Contents)

## destroy_sampler
[[Return to contents]](#Contents)

## destroy_shader
[[Return to contents]](#Contents)

## disable_frame_stats
[[Return to contents]](#Contents)

## draw
[[Return to contents]](#Contents)

## enable_frame_stats
[[Return to contents]](#Contents)

## end_pass
[[Return to contents]](#Contents)

## frame_stats_enabled
[[Return to contents]](#Contents)

## is_valid
[[Return to contents]](#Contents)

## make_attachments
[[Return to contents]](#Contents)

## make_buffer
[[Return to contents]](#Contents)

## make_image
[[Return to contents]](#Contents)

## make_pipeline
[[Return to contents]](#Contents)

## make_sampler
[[Return to contents]](#Contents)

## make_shader
[[Return to contents]](#Contents)

## query_attachments_defaults
[[Return to contents]](#Contents)

## query_attachments_info
[[Return to contents]](#Contents)

## query_attachments_state
[[Return to contents]](#Contents)

## query_backend
[[Return to contents]](#Contents)

## query_buffer_defaults
[[Return to contents]](#Contents)

## query_buffer_info
[[Return to contents]](#Contents)

## query_buffer_overflow
[[Return to contents]](#Contents)

## query_buffer_state
[[Return to contents]](#Contents)

## query_desc
[[Return to contents]](#Contents)

## query_features
[[Return to contents]](#Contents)

## query_frame_stats
[[Return to contents]](#Contents)

## query_image_defaults
[[Return to contents]](#Contents)

## query_image_info
[[Return to contents]](#Contents)

## query_image_state
[[Return to contents]](#Contents)

## query_limits
[[Return to contents]](#Contents)

## query_pipeline_defaults
[[Return to contents]](#Contents)

## query_pipeline_info
[[Return to contents]](#Contents)

## query_pipeline_state
[[Return to contents]](#Contents)

## query_pixelformat
[[Return to contents]](#Contents)

## query_shader_defaults
[[Return to contents]](#Contents)

## query_shader_info
[[Return to contents]](#Contents)

## query_shader_state
[[Return to contents]](#Contents)

## reset_state_cache
[[Return to contents]](#Contents)

## setup
[[Return to contents]](#Contents)

## shutdown
[[Return to contents]](#Contents)

## update_buffer
[[Return to contents]](#Contents)

## update_image
[[Return to contents]](#Contents)

## AttachmentDesc
[[Return to contents]](#Contents)

## Attachments
[[Return to contents]](#Contents)

## AttachmentsDesc
[[Return to contents]](#Contents)

## AttachmentsInfo
[[Return to contents]](#Contents)

## Bindings
[[Return to contents]](#Contents)

## set_vert_image
[[Return to contents]](#Contents)

## set_frag_image
[[Return to contents]](#Contents)

## update_vert_buffer
[[Return to contents]](#Contents)

## append_vert_buffer
[[Return to contents]](#Contents)

## update_index_buffer
[[Return to contents]](#Contents)

## append_index_buffer
[[Return to contents]](#Contents)

## BlendState
[[Return to contents]](#Contents)

## Buffer
[[Return to contents]](#Contents)

## free
[[Return to contents]](#Contents)

## BufferDesc
[[Return to contents]](#Contents)

## BufferInfo
[[Return to contents]](#Contents)

## Color
[[Return to contents]](#Contents)

## ColorAttachmentAction
[[Return to contents]](#Contents)

## ColorTargetState
[[Return to contents]](#Contents)

## CommitListener
[[Return to contents]](#Contents)

## D3d11Environment
[[Return to contents]](#Contents)

## D3d11Swapchain
[[Return to contents]](#Contents)

## DepthAttachmentAction
[[Return to contents]](#Contents)

## DepthState
[[Return to contents]](#Contents)

## Desc
[[Return to contents]](#Contents)

## Environment
[[Return to contents]](#Contents)

## EnvironmentDefaults
[[Return to contents]](#Contents)

## Features
[[Return to contents]](#Contents)

## FrameStats
[[Return to contents]](#Contents)

## FrameStatsD3D11
[[Return to contents]](#Contents)

## FrameStatsD3D11Bindings
[[Return to contents]](#Contents)

## FrameStatsD3D11Draw
[[Return to contents]](#Contents)

## FrameStatsD3D11Pass
[[Return to contents]](#Contents)

## FrameStatsD3D11Pipeline
[[Return to contents]](#Contents)

## FrameStatsD3D11Uniforms
[[Return to contents]](#Contents)

## FrameStatsGL
[[Return to contents]](#Contents)

## FrameStatsMetal
[[Return to contents]](#Contents)

## FrameStatsMetalBindings
[[Return to contents]](#Contents)

## FrameStatsMetalIdpool
[[Return to contents]](#Contents)

## FrameStatsMetalPipeline
[[Return to contents]](#Contents)

## FrameStatsMetalUniforms
[[Return to contents]](#Contents)

## FrameStatsWGPU
[[Return to contents]](#Contents)

## FrameStatsWGPUBindings
[[Return to contents]](#Contents)

## FrameStatsWGPUUniforms
[[Return to contents]](#Contents)

## GlSwapchain
[[Return to contents]](#Contents)

## Image
[[Return to contents]](#Contents)

## free
[[Return to contents]](#Contents)

## ImageData
[[Return to contents]](#Contents)

## ImageDesc
[[Return to contents]](#Contents)

## ImageInfo
[[Return to contents]](#Contents)

## Limits
[[Return to contents]](#Contents)

## MetalEnvironment
[[Return to contents]](#Contents)

## MetalSwapchain
[[Return to contents]](#Contents)

## Pass
[[Return to contents]](#Contents)

## PassAction
[[Return to contents]](#Contents)

## Pipeline
[[Return to contents]](#Contents)

## PipelineDesc
[[Return to contents]](#Contents)

## PipelineInfo
[[Return to contents]](#Contents)

## PixelFormatInfo
[[Return to contents]](#Contents)

## Range
[[Return to contents]](#Contents)

## Sampler
[[Return to contents]](#Contents)

## SamplerDesc
[[Return to contents]](#Contents)

## Shader
[[Return to contents]](#Contents)

## free
[[Return to contents]](#Contents)

## ShaderAttrDesc
[[Return to contents]](#Contents)

## ShaderDesc
[[Return to contents]](#Contents)

## make_shader
[[Return to contents]](#Contents)

## ShaderImageDesc
[[Return to contents]](#Contents)

## ShaderImageSamplerPairDesc
[[Return to contents]](#Contents)

## ShaderInfo
[[Return to contents]](#Contents)

## ShaderSamplerDesc
[[Return to contents]](#Contents)

## ShaderStageDesc
[[Return to contents]](#Contents)

## set_image
[[Return to contents]](#Contents)

## ShaderStorageBufferDesc
[[Return to contents]](#Contents)

## ShaderUniformBlockDesc
[[Return to contents]](#Contents)

## ShaderUniformDesc
[[Return to contents]](#Contents)

## SlotInfo
[[Return to contents]](#Contents)

## StageBindings
[[Return to contents]](#Contents)

## StencilAttachmentAction
[[Return to contents]](#Contents)

## StencilFaceState
[[Return to contents]](#Contents)

## StencilState
[[Return to contents]](#Contents)

## Swapchain
[[Return to contents]](#Contents)

## VertexAttrDesc
[[Return to contents]](#Contents)

## VertexBufferLayoutState
[[Return to contents]](#Contents)

## VertexLayoutState
[[Return to contents]](#Contents)

## WgpuEnvironment
[[Return to contents]](#Contents)

## WgpuSwapchain
[[Return to contents]](#Contents)

## Backend
[[Return to contents]](#Contents)

## BlendFactor
[[Return to contents]](#Contents)

## BlendOp
[[Return to contents]](#Contents)

## BorderColor
[[Return to contents]](#Contents)

## BufferType
[[Return to contents]](#Contents)

## ColorMask
[[Return to contents]](#Contents)

## CompareFunc
[[Return to contents]](#Contents)

## CubeFace
[[Return to contents]](#Contents)

## CullMode
[[Return to contents]](#Contents)

## FaceWinding
[[Return to contents]](#Contents)

## Filter
[[Return to contents]](#Contents)

## ImageSampleType
[[Return to contents]](#Contents)

## ImageType
[[Return to contents]](#Contents)

## IndexType
[[Return to contents]](#Contents)

## LoadAction
[[Return to contents]](#Contents)

## PixelFormat
[[Return to contents]](#Contents)

## PrimitiveType
[[Return to contents]](#Contents)

## ResourceState
[[Return to contents]](#Contents)

## SamplerType
[[Return to contents]](#Contents)

## ShaderStage
[[Return to contents]](#Contents)

## StencilOp
[[Return to contents]](#Contents)

## StoreAction
[[Return to contents]](#Contents)

## UniformLayout
[[Return to contents]](#Contents)

## UniformType
[[Return to contents]](#Contents)

## Usage
[[Return to contents]](#Contents)

## VertexFormat
[[Return to contents]](#Contents)

## VertexStep
[[Return to contents]](#Contents)

## Wrap
[[Return to contents]](#Contents)

## C.sg_allocator
[[Return to contents]](#Contents)

## C.sg_attachment_desc
[[Return to contents]](#Contents)

## C.sg_attachments
[[Return to contents]](#Contents)

## free
[[Return to contents]](#Contents)

## C.sg_attachments_desc
[[Return to contents]](#Contents)

## C.sg_attachments_info
[[Return to contents]](#Contents)

## C.sg_bindings
[[Return to contents]](#Contents)

## C.sg_blend_state
[[Return to contents]](#Contents)

## C.sg_buffer
[[Return to contents]](#Contents)

## C.sg_buffer_desc
[[Return to contents]](#Contents)

## C.sg_buffer_info
[[Return to contents]](#Contents)

## C.sg_color
[[Return to contents]](#Contents)

## C.sg_color_attachment_action
[[Return to contents]](#Contents)

## C.sg_color_target_state
[[Return to contents]](#Contents)

## C.sg_commit_listener
[[Return to contents]](#Contents)

## C.sg_d3d11_environment
[[Return to contents]](#Contents)

## C.sg_d3d11_swapchain
[[Return to contents]](#Contents)

## C.sg_depth_attachment_action
[[Return to contents]](#Contents)

## C.sg_depth_state
[[Return to contents]](#Contents)

## C.sg_desc
[[Return to contents]](#Contents)

## C.sg_environment
[[Return to contents]](#Contents)

## C.sg_environment_defaults
[[Return to contents]](#Contents)

## C.sg_features
[[Return to contents]](#Contents)

## C.sg_frame_stats
[[Return to contents]](#Contents)

## C.sg_frame_stats_d3d11
[[Return to contents]](#Contents)

## C.sg_frame_stats_d3d11_bindings
[[Return to contents]](#Contents)

## C.sg_frame_stats_d3d11_draw
[[Return to contents]](#Contents)

## C.sg_frame_stats_d3d11_pass
[[Return to contents]](#Contents)

## C.sg_frame_stats_d3d11_pipeline
[[Return to contents]](#Contents)

## C.sg_frame_stats_d3d11_uniforms
[[Return to contents]](#Contents)

## C.sg_frame_stats_gl
[[Return to contents]](#Contents)

## C.sg_frame_stats_metal
[[Return to contents]](#Contents)

## C.sg_frame_stats_metal_bindings
[[Return to contents]](#Contents)

## C.sg_frame_stats_metal_idpool
[[Return to contents]](#Contents)

## C.sg_frame_stats_metal_pipeline
[[Return to contents]](#Contents)

## C.sg_frame_stats_metal_uniforms
[[Return to contents]](#Contents)

## C.sg_frame_stats_wgpu
[[Return to contents]](#Contents)

## C.sg_frame_stats_wgpu_bindings
[[Return to contents]](#Contents)

## C.sg_frame_stats_wgpu_uniforms
[[Return to contents]](#Contents)

## C.sg_gl_swapchain
[[Return to contents]](#Contents)

## C.sg_image
[[Return to contents]](#Contents)

## C.sg_image_data
[[Return to contents]](#Contents)

## C.sg_image_desc
[[Return to contents]](#Contents)

## C.sg_image_info
[[Return to contents]](#Contents)

## C.sg_limits
[[Return to contents]](#Contents)

## C.sg_logger
[[Return to contents]](#Contents)

## C.sg_metal_environment
[[Return to contents]](#Contents)

## C.sg_metal_swapchain
[[Return to contents]](#Contents)

## C.sg_pass
[[Return to contents]](#Contents)

## C.sg_pass_action
[[Return to contents]](#Contents)

## C.sg_pipeline
[[Return to contents]](#Contents)

## free
[[Return to contents]](#Contents)

## C.sg_pipeline_desc
[[Return to contents]](#Contents)

## C.sg_pipeline_info
[[Return to contents]](#Contents)

## C.sg_pixelformat_info
[[Return to contents]](#Contents)

## C.sg_range
[[Return to contents]](#Contents)

## C.sg_sampler
[[Return to contents]](#Contents)

## C.sg_sampler_desc
[[Return to contents]](#Contents)

## C.sg_sampler_info
[[Return to contents]](#Contents)

## C.sg_shader
[[Return to contents]](#Contents)

## C.sg_shader_attr_desc
[[Return to contents]](#Contents)

## C.sg_shader_desc
[[Return to contents]](#Contents)

## set_vert_src
[[Return to contents]](#Contents)

## set_frag_src
[[Return to contents]](#Contents)

## set_vert_image
[[Return to contents]](#Contents)

## set_frag_image
[[Return to contents]](#Contents)

## set_vert_uniform_block_size
[[Return to contents]](#Contents)

## set_frag_uniform_block_size
[[Return to contents]](#Contents)

## set_vert_uniform
[[Return to contents]](#Contents)

## set_frag_uniform
[[Return to contents]](#Contents)

## C.sg_shader_image_desc
[[Return to contents]](#Contents)

## C.sg_shader_image_sampler_pair_desc
[[Return to contents]](#Contents)

## C.sg_shader_info
[[Return to contents]](#Contents)

## C.sg_shader_sampler_desc
[[Return to contents]](#Contents)

## C.sg_shader_stage_desc
[[Return to contents]](#Contents)

## C.sg_shader_storage_buffer_desc
[[Return to contents]](#Contents)

## C.sg_shader_uniform_block_desc
[[Return to contents]](#Contents)

## C.sg_shader_uniform_desc
[[Return to contents]](#Contents)

## C.sg_slot_info
[[Return to contents]](#Contents)

## C.sg_stage_bindings
[[Return to contents]](#Contents)

## C.sg_stencil_attachment_action
[[Return to contents]](#Contents)

## C.sg_stencil_face_state
[[Return to contents]](#Contents)

## C.sg_stencil_state
[[Return to contents]](#Contents)

## C.sg_swapchain
[[Return to contents]](#Contents)

## C.sg_trace_hooks
[[Return to contents]](#Contents)

## C.sg_vertex_attr_state
[[Return to contents]](#Contents)

## C.sg_vertex_buffer_layout_state
[[Return to contents]](#Contents)

## C.sg_vertex_layout_state
[[Return to contents]](#Contents)

## C.sg_wgpu_environment
[[Return to contents]](#Contents)

## C.sg_wgpu_swapchain
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:55
