# module math.unsigned


## Contents
- [Constants](#Constants)
- [add_128](#add_128)
- [add_256](#add_256)
- [div_128](#div_128)
- [mul_128](#mul_128)
- [mul_256](#mul_256)
- [sub_128](#sub_128)
- [sub_256](#sub_256)
- [uint128_from_64](#uint128_from_64)
- [uint128_from_dec_str](#uint128_from_dec_str)
- [uint128_new](#uint128_new)
- [uint256_from_128](#uint256_from_128)
- [uint256_from_64](#uint256_from_64)
- [uint256_from_dec_str](#uint256_from_dec_str)
- [Uint128](#Uint128)
  - [is_zero](#is_zero)
  - [equals](#equals)
  - [equals_64](#equals_64)
  - [cmp](#cmp)
  - [cmp_64](#cmp_64)
  - [and](#and)
  - [and_64](#and_64)
  - [or_](#or_)
  - [or_64](#or_64)
  - [xor](#xor)
  - [xor_64](#xor_64)
  - [add](#add)
  - [add_64](#add_64)
  - [sub](#sub)
  - [sub_64](#sub_64)
  - [mul](#mul)
  - [mul_64](#mul_64)
  - [overflowing_mul_64](#overflowing_mul_64)
  - [overflowing_add_64](#overflowing_add_64)
  - [div](#div)
  - [mod](#mod)
  - [mod_64](#mod_64)
  - [quo_rem_64](#quo_rem_64)
  - [quo_rem](#quo_rem)
  - [lsh](#lsh)
  - [rsh](#rsh)
  - [leading_zeros](#leading_zeros)
  - [trailing_zeros](#trailing_zeros)
  - [ones_count](#ones_count)
  - [rotate_left](#rotate_left)
  - [rotate_right](#rotate_right)
  - [reverse](#reverse)
  - [reverse_bytes](#reverse_bytes)
  - [not](#not)
  - [len](#len)
  - [str](#str)
  - [put_bytes](#put_bytes)
  - [/](#/)
  - [%](#%)
  - [+](#+)
  - [-](#-)
  - [*](#*)
  - [<](#<)
- [Uint256](#Uint256)
  - [is_zero](#is_zero)
  - [equals](#equals)
  - [equals_128](#equals_128)
  - [cmp](#cmp)
  - [cmp_128](#cmp_128)
  - [not](#not)
  - [and](#and)
  - [and_128](#and_128)
  - [or_](#or_)
  - [or_128](#or_128)
  - [xor](#xor)
  - [xor_128](#xor_128)
  - [add](#add)
  - [overflowing_add](#overflowing_add)
  - [add_128](#add_128)
  - [sub](#sub)
  - [sub_128](#sub_128)
  - [mul](#mul)
  - [mul_128](#mul_128)
  - [quo_rem](#quo_rem)
  - [quo_rem_128](#quo_rem_128)
  - [quo_rem_64](#quo_rem_64)
  - [rsh](#rsh)
  - [lsh](#lsh)
  - [div](#div)
  - [div_128](#div_128)
  - [div_64](#div_64)
  - [mod](#mod)
  - [mod_128](#mod_128)
  - [mod_64](#mod_64)
  - [rotate_left](#rotate_left)
  - [rotate_right](#rotate_right)
  - [len](#len)
  - [leading_zeros](#leading_zeros)
  - [trailing_zeros](#trailing_zeros)
  - [ones_count](#ones_count)
  - [str](#str)
  - [/](#/)
  - [%](#%)
  - [+](#+)
  - [-](#-)
  - [*](#*)
  - [<](#<)

## Constants
[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

## add_128
[[Return to contents]](#Contents)

## add_256
[[Return to contents]](#Contents)

## div_128
[[Return to contents]](#Contents)

## mul_128
[[Return to contents]](#Contents)

## mul_256
[[Return to contents]](#Contents)

## sub_128
[[Return to contents]](#Contents)

## sub_256
[[Return to contents]](#Contents)

## uint128_from_64
[[Return to contents]](#Contents)

## uint128_from_dec_str
[[Return to contents]](#Contents)

## uint128_new
[[Return to contents]](#Contents)

## uint256_from_128
[[Return to contents]](#Contents)

## uint256_from_64
[[Return to contents]](#Contents)

## uint256_from_dec_str
[[Return to contents]](#Contents)

## Uint128
[[Return to contents]](#Contents)

## is_zero
[[Return to contents]](#Contents)

## equals
[[Return to contents]](#Contents)

## equals_64
[[Return to contents]](#Contents)

## cmp
[[Return to contents]](#Contents)

## cmp_64
[[Return to contents]](#Contents)

## and
[[Return to contents]](#Contents)

## and_64
[[Return to contents]](#Contents)

## or_
[[Return to contents]](#Contents)

## or_64
[[Return to contents]](#Contents)

## xor
[[Return to contents]](#Contents)

## xor_64
[[Return to contents]](#Contents)

## add
[[Return to contents]](#Contents)

## add_64
[[Return to contents]](#Contents)

## sub
[[Return to contents]](#Contents)

## sub_64
[[Return to contents]](#Contents)

## mul
[[Return to contents]](#Contents)

## mul_64
[[Return to contents]](#Contents)

## overflowing_mul_64
[[Return to contents]](#Contents)

## overflowing_add_64
[[Return to contents]](#Contents)

## div
[[Return to contents]](#Contents)

## mod
[[Return to contents]](#Contents)

## mod_64
[[Return to contents]](#Contents)

## quo_rem_64
[[Return to contents]](#Contents)

## quo_rem
[[Return to contents]](#Contents)

## lsh
[[Return to contents]](#Contents)

## rsh
[[Return to contents]](#Contents)

## leading_zeros
[[Return to contents]](#Contents)

## trailing_zeros
[[Return to contents]](#Contents)

## ones_count
[[Return to contents]](#Contents)

## rotate_left
[[Return to contents]](#Contents)

## rotate_right
[[Return to contents]](#Contents)

## reverse
[[Return to contents]](#Contents)

## reverse_bytes
[[Return to contents]](#Contents)

## not
[[Return to contents]](#Contents)

## len
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## put_bytes
[[Return to contents]](#Contents)

## /
[[Return to contents]](#Contents)

## %
[[Return to contents]](#Contents)

## +
[[Return to contents]](#Contents)

## -
[[Return to contents]](#Contents)

## *
[[Return to contents]](#Contents)

## <
[[Return to contents]](#Contents)

## Uint256
[[Return to contents]](#Contents)

## is_zero
[[Return to contents]](#Contents)

## equals
[[Return to contents]](#Contents)

## equals_128
[[Return to contents]](#Contents)

## cmp
[[Return to contents]](#Contents)

## cmp_128
[[Return to contents]](#Contents)

## not
[[Return to contents]](#Contents)

## and
[[Return to contents]](#Contents)

## and_128
[[Return to contents]](#Contents)

## or_
[[Return to contents]](#Contents)

## or_128
[[Return to contents]](#Contents)

## xor
[[Return to contents]](#Contents)

## xor_128
[[Return to contents]](#Contents)

## add
[[Return to contents]](#Contents)

## overflowing_add
[[Return to contents]](#Contents)

## add_128
[[Return to contents]](#Contents)

## sub
[[Return to contents]](#Contents)

## sub_128
[[Return to contents]](#Contents)

## mul
[[Return to contents]](#Contents)

## mul_128
[[Return to contents]](#Contents)

## quo_rem
[[Return to contents]](#Contents)

## quo_rem_128
[[Return to contents]](#Contents)

## quo_rem_64
[[Return to contents]](#Contents)

## rsh
[[Return to contents]](#Contents)

## lsh
[[Return to contents]](#Contents)

## div
[[Return to contents]](#Contents)

## div_128
[[Return to contents]](#Contents)

## div_64
[[Return to contents]](#Contents)

## mod
[[Return to contents]](#Contents)

## mod_128
[[Return to contents]](#Contents)

## mod_64
[[Return to contents]](#Contents)

## rotate_left
[[Return to contents]](#Contents)

## rotate_right
[[Return to contents]](#Contents)

## len
[[Return to contents]](#Contents)

## leading_zeros
[[Return to contents]](#Contents)

## trailing_zeros
[[Return to contents]](#Contents)

## ones_count
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## /
[[Return to contents]](#Contents)

## %
[[Return to contents]](#Contents)

## +
[[Return to contents]](#Contents)

## -
[[Return to contents]](#Contents)

## *
[[Return to contents]](#Contents)

## <
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:55
