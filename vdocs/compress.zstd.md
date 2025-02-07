# module compress.zstd


## Contents
- [check_zstd](#check_zstd)
- [compress](#compress)
- [decompress](#decompress)
- [default_c_level](#default_c_level)
- [get_error_name](#get_error_name)
- [is_error](#is_error)
- [load_array](#load_array)
- [max_c_level](#max_c_level)
- [min_c_level](#min_c_level)
- [new_cctx](#new_cctx)
- [new_dctx](#new_dctx)
- [store_array](#store_array)
- [version_number](#version_number)
- [version_string](#version_string)
- [ZSTD_CCtx](#ZSTD_CCtx)
  - [set_parameter](#set_parameter)
  - [compress_stream2](#compress_stream2)
  - [free_cctx](#free_cctx)
- [ZSTD_DCtx](#ZSTD_DCtx)
  - [set_parameter](#set_parameter)
  - [decompress_stream](#decompress_stream)
  - [free_dctx](#free_dctx)
- [ZSTD_EndDirective](#ZSTD_EndDirective)
- [ZSTD_ResetDirective](#ZSTD_ResetDirective)
- [ZSTD_cParameter](#ZSTD_cParameter)
- [ZSTD_dParameter](#ZSTD_dParameter)
- [ZSTD_strategy](#ZSTD_strategy)
- [CompressParams](#CompressParams)
- [DecompressParams](#DecompressParams)
- [ZSTD_bounds](#ZSTD_bounds)
- [ZSTD_inBuffer](#ZSTD_inBuffer)
- [ZSTD_outBuffer](#ZSTD_outBuffer)

## check_zstd
[[Return to contents]](#Contents)

## compress
Example
```v

compressed := zstd.compress(b)!

```

[[Return to contents]](#Contents)

## decompress
Example
```v

decompressed := zstd.decompress(b)!

```

[[Return to contents]](#Contents)

## default_c_level
[[Return to contents]](#Contents)

## get_error_name
[[Return to contents]](#Contents)

## is_error
[[Return to contents]](#Contents)

## load_array
[[Return to contents]](#Contents)

## max_c_level
[[Return to contents]](#Contents)

## min_c_level
[[Return to contents]](#Contents)

## new_cctx
[[Return to contents]](#Contents)

## new_dctx
[[Return to contents]](#Contents)

## store_array
[[Return to contents]](#Contents)

## version_number
[[Return to contents]](#Contents)

## version_string
[[Return to contents]](#Contents)

## ZSTD_CCtx
[[Return to contents]](#Contents)

## set_parameter
[[Return to contents]](#Contents)

## compress_stream2
[[Return to contents]](#Contents)

## free_cctx
[[Return to contents]](#Contents)

## ZSTD_DCtx
[[Return to contents]](#Contents)

## set_parameter
[[Return to contents]](#Contents)

## decompress_stream
[[Return to contents]](#Contents)

## free_dctx
[[Return to contents]](#Contents)

## ZSTD_EndDirective
[[Return to contents]](#Contents)

## ZSTD_ResetDirective
[[Return to contents]](#Contents)

## ZSTD_cParameter
[[Return to contents]](#Contents)

## ZSTD_dParameter
[[Return to contents]](#Contents)

## ZSTD_strategy
[[Return to contents]](#Contents)

## CompressParams
[[Return to contents]](#Contents)

## DecompressParams
[[Return to contents]](#Contents)

## ZSTD_bounds
[[Return to contents]](#Contents)

## ZSTD_inBuffer
[[Return to contents]](#Contents)

## ZSTD_outBuffer
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:55
