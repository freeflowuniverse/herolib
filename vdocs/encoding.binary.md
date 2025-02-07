# module encoding.binary


## Contents
- [big_endian_get_u16](#big_endian_get_u16)
- [big_endian_get_u32](#big_endian_get_u32)
- [big_endian_get_u64](#big_endian_get_u64)
- [big_endian_put_u16](#big_endian_put_u16)
- [big_endian_put_u16_at](#big_endian_put_u16_at)
- [big_endian_put_u16_end](#big_endian_put_u16_end)
- [big_endian_put_u16_fixed](#big_endian_put_u16_fixed)
- [big_endian_put_u32](#big_endian_put_u32)
- [big_endian_put_u32_at](#big_endian_put_u32_at)
- [big_endian_put_u32_end](#big_endian_put_u32_end)
- [big_endian_put_u32_fixed](#big_endian_put_u32_fixed)
- [big_endian_put_u64](#big_endian_put_u64)
- [big_endian_put_u64_at](#big_endian_put_u64_at)
- [big_endian_put_u64_end](#big_endian_put_u64_end)
- [big_endian_put_u64_fixed](#big_endian_put_u64_fixed)
- [big_endian_u16](#big_endian_u16)
- [big_endian_u16_at](#big_endian_u16_at)
- [big_endian_u16_end](#big_endian_u16_end)
- [big_endian_u16_fixed](#big_endian_u16_fixed)
- [big_endian_u32](#big_endian_u32)
- [big_endian_u32_at](#big_endian_u32_at)
- [big_endian_u32_end](#big_endian_u32_end)
- [big_endian_u32_fixed](#big_endian_u32_fixed)
- [big_endian_u64](#big_endian_u64)
- [big_endian_u64_at](#big_endian_u64_at)
- [big_endian_u64_end](#big_endian_u64_end)
- [big_endian_u64_fixed](#big_endian_u64_fixed)
- [little_endian_f32_at](#little_endian_f32_at)
- [little_endian_get_u16](#little_endian_get_u16)
- [little_endian_get_u32](#little_endian_get_u32)
- [little_endian_get_u64](#little_endian_get_u64)
- [little_endian_put_u16](#little_endian_put_u16)
- [little_endian_put_u16_at](#little_endian_put_u16_at)
- [little_endian_put_u16_end](#little_endian_put_u16_end)
- [little_endian_put_u16_fixed](#little_endian_put_u16_fixed)
- [little_endian_put_u32](#little_endian_put_u32)
- [little_endian_put_u32_at](#little_endian_put_u32_at)
- [little_endian_put_u32_end](#little_endian_put_u32_end)
- [little_endian_put_u32_fixed](#little_endian_put_u32_fixed)
- [little_endian_put_u64](#little_endian_put_u64)
- [little_endian_put_u64_at](#little_endian_put_u64_at)
- [little_endian_put_u64_end](#little_endian_put_u64_end)
- [little_endian_put_u64_fixed](#little_endian_put_u64_fixed)
- [little_endian_u16](#little_endian_u16)
- [little_endian_u16_at](#little_endian_u16_at)
- [little_endian_u16_end](#little_endian_u16_end)
- [little_endian_u16_fixed](#little_endian_u16_fixed)
- [little_endian_u32](#little_endian_u32)
- [little_endian_u32_at](#little_endian_u32_at)
- [little_endian_u32_end](#little_endian_u32_end)
- [little_endian_u32_fixed](#little_endian_u32_fixed)
- [little_endian_u64](#little_endian_u64)
- [little_endian_u64_at](#little_endian_u64_at)
- [little_endian_u64_end](#little_endian_u64_end)
- [little_endian_u64_fixed](#little_endian_u64_fixed)

## big_endian_get_u16
[[Return to contents]](#Contents)

## big_endian_get_u32
[[Return to contents]](#Contents)

## big_endian_get_u64
[[Return to contents]](#Contents)

## big_endian_put_u16
[[Return to contents]](#Contents)

## big_endian_put_u16_at
[[Return to contents]](#Contents)

## big_endian_put_u16_end
[[Return to contents]](#Contents)

## big_endian_put_u16_fixed
[[Return to contents]](#Contents)

## big_endian_put_u32
[[Return to contents]](#Contents)

## big_endian_put_u32_at
[[Return to contents]](#Contents)

## big_endian_put_u32_end
[[Return to contents]](#Contents)

## big_endian_put_u32_fixed
[[Return to contents]](#Contents)

## big_endian_put_u64
[[Return to contents]](#Contents)

## big_endian_put_u64_at
[[Return to contents]](#Contents)

## big_endian_put_u64_end
[[Return to contents]](#Contents)

## big_endian_put_u64_fixed
[[Return to contents]](#Contents)

## big_endian_u16
[[Return to contents]](#Contents)

## big_endian_u16_at
[[Return to contents]](#Contents)

## big_endian_u16_end
[[Return to contents]](#Contents)

## big_endian_u16_fixed
[[Return to contents]](#Contents)

## big_endian_u32
[[Return to contents]](#Contents)

## big_endian_u32_at
[[Return to contents]](#Contents)

## big_endian_u32_end
[[Return to contents]](#Contents)

## big_endian_u32_fixed
[[Return to contents]](#Contents)

## big_endian_u64
[[Return to contents]](#Contents)

## big_endian_u64_at
[[Return to contents]](#Contents)

## big_endian_u64_end
[[Return to contents]](#Contents)

## big_endian_u64_fixed
[[Return to contents]](#Contents)

## little_endian_f32_at
[[Return to contents]](#Contents)

## little_endian_get_u16
[[Return to contents]](#Contents)

## little_endian_get_u32
[[Return to contents]](#Contents)

## little_endian_get_u64
[[Return to contents]](#Contents)

## little_endian_put_u16
[[Return to contents]](#Contents)

## little_endian_put_u16_at
[[Return to contents]](#Contents)

## little_endian_put_u16_end
[[Return to contents]](#Contents)

## little_endian_put_u16_fixed
[[Return to contents]](#Contents)

## little_endian_put_u32
[[Return to contents]](#Contents)

## little_endian_put_u32_at
[[Return to contents]](#Contents)

## little_endian_put_u32_end
[[Return to contents]](#Contents)

## little_endian_put_u32_fixed
[[Return to contents]](#Contents)

## little_endian_put_u64
[[Return to contents]](#Contents)

## little_endian_put_u64_at
[[Return to contents]](#Contents)

## little_endian_put_u64_end
[[Return to contents]](#Contents)

## little_endian_put_u64_fixed
[[Return to contents]](#Contents)

## little_endian_u16
[[Return to contents]](#Contents)

## little_endian_u16_at
[[Return to contents]](#Contents)

## little_endian_u16_end
[[Return to contents]](#Contents)

## little_endian_u16_fixed
[[Return to contents]](#Contents)

## little_endian_u32
[[Return to contents]](#Contents)

## little_endian_u32_at
[[Return to contents]](#Contents)

## little_endian_u32_end
[[Return to contents]](#Contents)

## little_endian_u32_fixed
[[Return to contents]](#Contents)

## little_endian_u64
[[Return to contents]](#Contents)

## little_endian_u64_at
[[Return to contents]](#Contents)

## little_endian_u64_end
[[Return to contents]](#Contents)

## little_endian_u64_fixed
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:55
