# module math


## Contents
- [Constants](#Constants)
- [abs](#abs)
- [acos](#acos)
- [acosh](#acosh)
- [alike](#alike)
- [angle_diff](#angle_diff)
- [aprox_cos](#aprox_cos)
- [aprox_sin](#aprox_sin)
- [asin](#asin)
- [asinh](#asinh)
- [atan](#atan)
- [atan2](#atan2)
- [atanh](#atanh)
- [cbrt](#cbrt)
- [ceil](#ceil)
- [clamp](#clamp)
- [clip](#clip)
- [close](#close)
- [copysign](#copysign)
- [cos](#cos)
- [cosf](#cosf)
- [cosh](#cosh)
- [cot](#cot)
- [count_digits](#count_digits)
- [cube](#cube)
- [cubic_bezier](#cubic_bezier)
- [cubic_bezier_a](#cubic_bezier_a)
- [cubic_bezier_coords](#cubic_bezier_coords)
- [cubic_bezier_fa](#cubic_bezier_fa)
- [degrees](#degrees)
- [digits](#digits)
- [divide_euclid](#divide_euclid)
- [divide_floored](#divide_floored)
- [divide_truncated](#divide_truncated)
- [egcd](#egcd)
- [erf](#erf)
- [erfc](#erfc)
- [exp](#exp)
- [exp2](#exp2)
- [expm1](#expm1)
- [f32_bits](#f32_bits)
- [f32_from_bits](#f32_from_bits)
- [f64_bits](#f64_bits)
- [f64_from_bits](#f64_from_bits)
- [factorial](#factorial)
- [factoriali](#factoriali)
- [floor](#floor)
- [floorf](#floorf)
- [fmod](#fmod)
- [frexp](#frexp)
- [gamma](#gamma)
- [gcd](#gcd)
- [get_high_word](#get_high_word)
- [hypot](#hypot)
- [ilog_b](#ilog_b)
- [inf](#inf)
- [is_finite](#is_finite)
- [is_inf](#is_inf)
- [is_nan](#is_nan)
- [lcm](#lcm)
- [ldexp](#ldexp)
- [log](#log)
- [log10](#log10)
- [log1p](#log1p)
- [log2](#log2)
- [log_b](#log_b)
- [log_factorial](#log_factorial)
- [log_gamma](#log_gamma)
- [log_gamma_sign](#log_gamma_sign)
- [log_n](#log_n)
- [logf](#logf)
- [max](#max)
- [maxof](#maxof)
- [min](#min)
- [minmax](#minmax)
- [minof](#minof)
- [mix](#mix)
- [mod](#mod)
- [modf](#modf)
- [modulo_euclid](#modulo_euclid)
- [modulo_floored](#modulo_floored)
- [modulo_truncated](#modulo_truncated)
- [nan](#nan)
- [nextafter](#nextafter)
- [nextafter32](#nextafter32)
- [normalize](#normalize)
- [pow](#pow)
- [pow10](#pow10)
- [powf](#powf)
- [powi](#powi)
- [q_rsqrt](#q_rsqrt)
- [radians](#radians)
- [round](#round)
- [round_sig](#round_sig)
- [round_to_even](#round_to_even)
- [scalbn](#scalbn)
- [sign](#sign)
- [signbit](#signbit)
- [signi](#signi)
- [sin](#sin)
- [sincos](#sincos)
- [sinf](#sinf)
- [sinh](#sinh)
- [sqrt](#sqrt)
- [sqrtf](#sqrtf)
- [sqrti](#sqrti)
- [square](#square)
- [tan](#tan)
- [tanf](#tanf)
- [tanh](#tanh)
- [tolerance](#tolerance)
- [trunc](#trunc)
- [veryclose](#veryclose)
- [with_set_high_word](#with_set_high_word)
- [with_set_low_word](#with_set_low_word)
- [BezierPoint](#BezierPoint)
- [DigitParams](#DigitParams)
- [DivResult](#DivResult)

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

## abs
[[Return to contents]](#Contents)

## acos
[[Return to contents]](#Contents)

## acosh
[[Return to contents]](#Contents)

## alike
[[Return to contents]](#Contents)

## angle_diff
[[Return to contents]](#Contents)

## aprox_cos
[[Return to contents]](#Contents)

## aprox_sin
[[Return to contents]](#Contents)

## asin
[[Return to contents]](#Contents)

## asinh
[[Return to contents]](#Contents)

## atan
[[Return to contents]](#Contents)

## atan2
[[Return to contents]](#Contents)

## atanh
[[Return to contents]](#Contents)

## cbrt
[[Return to contents]](#Contents)

## ceil
[[Return to contents]](#Contents)

## clamp
[[Return to contents]](#Contents)

## clip
[[Return to contents]](#Contents)

## close
[[Return to contents]](#Contents)

## copysign
[[Return to contents]](#Contents)

## cos
[[Return to contents]](#Contents)

## cosf
[[Return to contents]](#Contents)

## cosh
[[Return to contents]](#Contents)

## cot
[[Return to contents]](#Contents)

## count_digits
[[Return to contents]](#Contents)

## cube
[[Return to contents]](#Contents)

## cubic_bezier
[[Return to contents]](#Contents)

## cubic_bezier_a
[[Return to contents]](#Contents)

## cubic_bezier_coords
[[Return to contents]](#Contents)

## cubic_bezier_fa
[[Return to contents]](#Contents)

## degrees
[[Return to contents]](#Contents)

## digits
Examples
```v

assert math.digits(12345, base: 10) == [5,4,3,2,1]

assert math.digits(12345, reverse: true) == [1,2,3,4,5]

```

[[Return to contents]](#Contents)

## divide_euclid
[[Return to contents]](#Contents)

## divide_floored
[[Return to contents]](#Contents)

## divide_truncated
[[Return to contents]](#Contents)

## egcd
[[Return to contents]](#Contents)

## erf
[[Return to contents]](#Contents)

## erfc
[[Return to contents]](#Contents)

## exp
[[Return to contents]](#Contents)

## exp2
[[Return to contents]](#Contents)

## expm1
[[Return to contents]](#Contents)

## f32_bits
[[Return to contents]](#Contents)

## f32_from_bits
[[Return to contents]](#Contents)

## f64_bits
[[Return to contents]](#Contents)

## f64_from_bits
[[Return to contents]](#Contents)

## factorial
[[Return to contents]](#Contents)

## factoriali
[[Return to contents]](#Contents)

## floor
[[Return to contents]](#Contents)

## floorf
[[Return to contents]](#Contents)

## fmod
[[Return to contents]](#Contents)

## frexp
[[Return to contents]](#Contents)

## gamma
[[Return to contents]](#Contents)

## gcd
[[Return to contents]](#Contents)

## get_high_word
[[Return to contents]](#Contents)

## hypot
[[Return to contents]](#Contents)

## ilog_b
[[Return to contents]](#Contents)

## inf
[[Return to contents]](#Contents)

## is_finite
[[Return to contents]](#Contents)

## is_inf
[[Return to contents]](#Contents)

## is_nan
[[Return to contents]](#Contents)

## lcm
[[Return to contents]](#Contents)

## ldexp
[[Return to contents]](#Contents)

## log
[[Return to contents]](#Contents)

## log10
[[Return to contents]](#Contents)

## log1p
[[Return to contents]](#Contents)

## log2
[[Return to contents]](#Contents)

## log_b
[[Return to contents]](#Contents)

## log_factorial
[[Return to contents]](#Contents)

## log_gamma
[[Return to contents]](#Contents)

## log_gamma_sign
[[Return to contents]](#Contents)

## log_n
[[Return to contents]](#Contents)

## logf
[[Return to contents]](#Contents)

## max
[[Return to contents]](#Contents)

## maxof
[[Return to contents]](#Contents)

## min
[[Return to contents]](#Contents)

## minmax
[[Return to contents]](#Contents)

## minof
[[Return to contents]](#Contents)

## mix
[[Return to contents]](#Contents)

## mod
[[Return to contents]](#Contents)

## modf
[[Return to contents]](#Contents)

## modulo_euclid
[[Return to contents]](#Contents)

## modulo_floored
[[Return to contents]](#Contents)

## modulo_truncated
[[Return to contents]](#Contents)

## nan
[[Return to contents]](#Contents)

## nextafter
[[Return to contents]](#Contents)

## nextafter32
[[Return to contents]](#Contents)

## normalize
[[Return to contents]](#Contents)

## pow
[[Return to contents]](#Contents)

## pow10
[[Return to contents]](#Contents)

## powf
[[Return to contents]](#Contents)

## powi
[[Return to contents]](#Contents)

## q_rsqrt
[[Return to contents]](#Contents)

## radians
[[Return to contents]](#Contents)

## round
[[Return to contents]](#Contents)

## round_sig
[[Return to contents]](#Contents)

## round_to_even
[[Return to contents]](#Contents)

## scalbn
[[Return to contents]](#Contents)

## sign
[[Return to contents]](#Contents)

## signbit
[[Return to contents]](#Contents)

## signi
[[Return to contents]](#Contents)

## sin
[[Return to contents]](#Contents)

## sincos
[[Return to contents]](#Contents)

## sinf
[[Return to contents]](#Contents)

## sinh
[[Return to contents]](#Contents)

## sqrt
[[Return to contents]](#Contents)

## sqrtf
[[Return to contents]](#Contents)

## sqrti
[[Return to contents]](#Contents)

## square
[[Return to contents]](#Contents)

## tan
[[Return to contents]](#Contents)

## tanf
[[Return to contents]](#Contents)

## tanh
[[Return to contents]](#Contents)

## tolerance
[[Return to contents]](#Contents)

## trunc
[[Return to contents]](#Contents)

## veryclose
[[Return to contents]](#Contents)

## with_set_high_word
[[Return to contents]](#Contents)

## with_set_low_word
[[Return to contents]](#Contents)

## BezierPoint
[[Return to contents]](#Contents)

## DigitParams
[[Return to contents]](#Contents)

## DivResult
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:55
