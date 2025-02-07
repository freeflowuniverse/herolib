# module strings


## Contents
- [dice_coefficient](#dice_coefficient)
- [find_between_pair_rune](#find_between_pair_rune)
- [find_between_pair_string](#find_between_pair_string)
- [find_between_pair_u8](#find_between_pair_u8)
- [hamming_distance](#hamming_distance)
- [hamming_similarity](#hamming_similarity)
- [jaro_similarity](#jaro_similarity)
- [jaro_winkler_similarity](#jaro_winkler_similarity)
- [levenshtein_distance](#levenshtein_distance)
- [levenshtein_distance_percentage](#levenshtein_distance_percentage)
- [new_builder](#new_builder)
- [repeat](#repeat)
- [repeat_string](#repeat_string)
- [split_capital](#split_capital)
- [Builder](#Builder)
  - [reuse_as_plain_u8_array](#reuse_as_plain_u8_array)
  - [write_ptr](#write_ptr)
  - [write_rune](#write_rune)
  - [write_runes](#write_runes)
  - [clear](#clear)
  - [write_u8](#write_u8)
  - [write_byte](#write_byte)
  - [write_decimal](#write_decimal)
  - [write](#write)
  - [drain_builder](#drain_builder)
  - [byte_at](#byte_at)
  - [write_string](#write_string)
  - [write_string2](#write_string2)
  - [go_back](#go_back)
  - [spart](#spart)
  - [cut_last](#cut_last)
  - [cut_to](#cut_to)
  - [go_back_to](#go_back_to)
  - [writeln](#writeln)
  - [writeln2](#writeln2)
  - [last_n](#last_n)
  - [after](#after)
  - [str](#str)
  - [ensure_cap](#ensure_cap)
  - [grow_len](#grow_len)
  - [free](#free)

## dice_coefficient
[[Return to contents]](#Contents)

## find_between_pair_rune
Examples
```v

assert strings.find_between_pair_rune('(V) (NOT V)',`(`,`)`) == 'V'

assert strings.find_between_pair_rune('s {X{Y}} s',`{`,`}`) == 'X{Y}'

```

[[Return to contents]](#Contents)

## find_between_pair_string
Examples
```v

assert strings.find_between_pair_string('/*V*/ /*NOT V*/','/*','*/') == 'V'

assert strings.find_between_pair_string('s {{X{{Y}}}} s','{{','}}') == 'X{{Y}}'

```

[[Return to contents]](#Contents)

## find_between_pair_u8
Examples
```v

assert strings.find_between_pair_u8('(V) (NOT V)',`(`,`)`) == 'V'

assert strings.find_between_pair_u8('s {X{Y}} s',`{`,`}`) == 'X{Y}'

```

[[Return to contents]](#Contents)

## hamming_distance
[[Return to contents]](#Contents)

## hamming_similarity
[[Return to contents]](#Contents)

## jaro_similarity
[[Return to contents]](#Contents)

## jaro_winkler_similarity
[[Return to contents]](#Contents)

## levenshtein_distance
[[Return to contents]](#Contents)

## levenshtein_distance_percentage
[[Return to contents]](#Contents)

## new_builder
[[Return to contents]](#Contents)

## repeat
[[Return to contents]](#Contents)

## repeat_string
[[Return to contents]](#Contents)

## split_capital
Examples
```v

assert strings.split_capital('XYZ') == ['X', 'Y', 'Z']

assert strings.split_capital('XYStar') == ['X', 'Y', 'Star']

```

[[Return to contents]](#Contents)

## Builder
[[Return to contents]](#Contents)

## reuse_as_plain_u8_array
[[Return to contents]](#Contents)

## write_ptr
[[Return to contents]](#Contents)

## write_rune
[[Return to contents]](#Contents)

## write_runes
[[Return to contents]](#Contents)

## clear
[[Return to contents]](#Contents)

## write_u8
[[Return to contents]](#Contents)

## write_byte
[[Return to contents]](#Contents)

## write_decimal
[[Return to contents]](#Contents)

## write
[[Return to contents]](#Contents)

## drain_builder
[[Return to contents]](#Contents)

## byte_at
[[Return to contents]](#Contents)

## write_string
[[Return to contents]](#Contents)

## write_string2
[[Return to contents]](#Contents)

## go_back
[[Return to contents]](#Contents)

## spart
[[Return to contents]](#Contents)

## cut_last
[[Return to contents]](#Contents)

## cut_to
[[Return to contents]](#Contents)

## go_back_to
[[Return to contents]](#Contents)

## writeln
[[Return to contents]](#Contents)

## writeln2
[[Return to contents]](#Contents)

## last_n
[[Return to contents]](#Contents)

## after
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## ensure_cap
[[Return to contents]](#Contents)

## grow_len
[[Return to contents]](#Contents)

## free
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:55
