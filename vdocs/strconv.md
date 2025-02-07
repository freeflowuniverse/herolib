# module strconv


## Contents
- [Constants](#Constants)
- [atof64](#atof64)
- [atof_quick](#atof_quick)
- [atoi](#atoi)
- [byte_to_lower](#byte_to_lower)
- [common_parse_int](#common_parse_int)
- [common_parse_uint](#common_parse_uint)
- [common_parse_uint2](#common_parse_uint2)
- [dec_digits](#dec_digits)
- [f32_to_str](#f32_to_str)
- [f32_to_str_l](#f32_to_str_l)
- [f32_to_str_l_with_dot](#f32_to_str_l_with_dot)
- [f32_to_str_pad](#f32_to_str_pad)
- [f64_to_str](#f64_to_str)
- [f64_to_str_l](#f64_to_str_l)
- [f64_to_str_l_with_dot](#f64_to_str_l_with_dot)
- [f64_to_str_lnd1](#f64_to_str_lnd1)
- [f64_to_str_pad](#f64_to_str_pad)
- [format_dec_old](#format_dec_old)
- [format_dec_sb](#format_dec_sb)
- [format_es](#format_es)
- [format_fl](#format_fl)
- [format_fl_old](#format_fl_old)
- [format_int](#format_int)
- [format_str](#format_str)
- [format_str_sb](#format_str_sb)
- [format_uint](#format_uint)
- [ftoa_32](#ftoa_32)
- [ftoa_64](#ftoa_64)
- [ftoa_long_32](#ftoa_long_32)
- [ftoa_long_64](#ftoa_long_64)
- [fxx_to_str_l_parse](#fxx_to_str_l_parse)
- [fxx_to_str_l_parse_with_dot](#fxx_to_str_l_parse_with_dot)
- [parse_int](#parse_int)
- [parse_uint](#parse_uint)
- [remove_tail_zeros](#remove_tail_zeros)
- [v_printf](#v_printf)
- [v_sprintf](#v_sprintf)
- [Dec32](#Dec32)
  - [get_string_32](#get_string_32)
- [Align_text](#Align_text)
- [BF_param](#BF_param)
- [Float32u](#Float32u)
- [Float64u](#Float64u)
- [PrepNumber](#PrepNumber)

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

## atof64
[[Return to contents]](#Contents)

## atof_quick
[[Return to contents]](#Contents)

## atoi
[[Return to contents]](#Contents)

## byte_to_lower
[[Return to contents]](#Contents)

## common_parse_int
[[Return to contents]](#Contents)

## common_parse_uint
[[Return to contents]](#Contents)

## common_parse_uint2
[[Return to contents]](#Contents)

## dec_digits
[[Return to contents]](#Contents)

## f32_to_str
[[Return to contents]](#Contents)

## f32_to_str_l
Example
```v

assert strconv.f32_to_str_l(34.1234567) == '34.12346'

```

[[Return to contents]](#Contents)

## f32_to_str_l_with_dot
Example
```v

assert strconv.f32_to_str_l_with_dot(34.) == '34.0'

```

[[Return to contents]](#Contents)

## f32_to_str_pad
[[Return to contents]](#Contents)

## f64_to_str
[[Return to contents]](#Contents)

## f64_to_str_l
Example
```v

assert strconv.f64_to_str_l(123.1234567891011121) == '123.12345678910111'

```

[[Return to contents]](#Contents)

## f64_to_str_l_with_dot
Example
```v

assert strconv.f64_to_str_l_with_dot (34.) == '34.0'

```

[[Return to contents]](#Contents)

## f64_to_str_lnd1
[[Return to contents]](#Contents)

## f64_to_str_pad
[[Return to contents]](#Contents)

## format_dec_old
[[Return to contents]](#Contents)

## format_dec_sb
[[Return to contents]](#Contents)

## format_es
[[Return to contents]](#Contents)

## format_fl
[[Return to contents]](#Contents)

## format_fl_old
[[Return to contents]](#Contents)

## format_int
[[Return to contents]](#Contents)

## format_str
[[Return to contents]](#Contents)

## format_str_sb
[[Return to contents]](#Contents)

## format_uint
[[Return to contents]](#Contents)

## ftoa_32
Example
```v

assert strconv.ftoa_32(34.1234567) == '3.4123455e+01'

```

[[Return to contents]](#Contents)

## ftoa_64
Example
```v

assert strconv.ftoa_64(123.1234567891011121) == '1.2312345678910111e+02'

```

[[Return to contents]](#Contents)

## ftoa_long_32
Example
```v

assert strconv.ftoa_long_32(34.1234567) == '34.12346'

```

[[Return to contents]](#Contents)

## ftoa_long_64
Example
```v

assert strconv.f64_to_str_l(123.1234567891011121) == '123.12345678910111'

```

[[Return to contents]](#Contents)

## fxx_to_str_l_parse
Example
```v

assert strconv.fxx_to_str_l_parse('34.22e+00') == '34.22'

```

[[Return to contents]](#Contents)

## fxx_to_str_l_parse_with_dot
Example
```v

assert strconv.fxx_to_str_l_parse_with_dot ('34.e+01') == '340.0'

```

[[Return to contents]](#Contents)

## parse_int
[[Return to contents]](#Contents)

## parse_uint
[[Return to contents]](#Contents)

## remove_tail_zeros
[[Return to contents]](#Contents)

## v_printf
[[Return to contents]](#Contents)

## v_sprintf
Example
```v

x := 3.141516
assert strconv.v_sprintf('aaa %G', x) == 'aaa 3.141516'

```

[[Return to contents]](#Contents)

## Dec32
## get_string_32
[[Return to contents]](#Contents)

## Align_text
[[Return to contents]](#Contents)

## BF_param
[[Return to contents]](#Contents)

## Float32u
[[Return to contents]](#Contents)

## Float64u
[[Return to contents]](#Contents)

## PrepNumber
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:55
