# module rand


## Contents
- [ascii](#ascii)
- [bernoulli](#bernoulli)
- [binomial](#binomial)
- [bytes](#bytes)
- [choose](#choose)
- [element](#element)
- [exponential](#exponential)
- [f32](#f32)
- [f32_in_range](#f32_in_range)
- [f32cp](#f32cp)
- [f32n](#f32n)
- [f64](#f64)
- [f64_in_range](#f64_in_range)
- [f64cp](#f64cp)
- [f64n](#f64n)
- [fill_buffer_from_set](#fill_buffer_from_set)
- [get_current_rng](#get_current_rng)
- [hex](#hex)
- [i16](#i16)
- [i32](#i32)
- [i32_in_range](#i32_in_range)
- [i32n](#i32n)
- [i64](#i64)
- [i64_in_range](#i64_in_range)
- [i64n](#i64n)
- [int](#int)
- [int31](#int31)
- [int63](#int63)
- [int_in_range](#int_in_range)
- [intn](#intn)
- [new_default](#new_default)
- [normal](#normal)
- [normal_pair](#normal_pair)
- [read](#read)
- [sample](#sample)
- [seed](#seed)
- [set_rng](#set_rng)
- [shuffle](#shuffle)
- [shuffle_clone](#shuffle_clone)
- [string](#string)
- [string_from_set](#string_from_set)
- [u16](#u16)
- [u32](#u32)
- [u32_in_range](#u32_in_range)
- [u32n](#u32n)
- [u64](#u64)
- [u64_in_range](#u64_in_range)
- [u64n](#u64n)
- [u8](#u8)
- [ulid](#ulid)
- [ulid_at_millisecond](#ulid_at_millisecond)
- [uuid_v4](#uuid_v4)
- [PRNG](#PRNG)
  - [bytes](#bytes)
  - [read](#read)
  - [i32n](#i32n)
  - [u32n](#u32n)
  - [u64n](#u64n)
  - [u32_in_range](#u32_in_range)
  - [u64_in_range](#u64_in_range)
  - [i8](#i8)
  - [i16](#i16)
  - [i32](#i32)
  - [int](#int)
  - [i64](#i64)
  - [int31](#int31)
  - [int63](#int63)
  - [intn](#intn)
  - [i64n](#i64n)
  - [int_in_range](#int_in_range)
  - [i32_in_range](#i32_in_range)
  - [i64_in_range](#i64_in_range)
  - [f32](#f32)
  - [f32cp](#f32cp)
  - [f64](#f64)
  - [f64cp](#f64cp)
  - [f32n](#f32n)
  - [f64n](#f64n)
  - [f32_in_range](#f32_in_range)
  - [f64_in_range](#f64_in_range)
  - [ulid](#ulid)
  - [ulid_at_millisecond](#ulid_at_millisecond)
  - [string_from_set](#string_from_set)
  - [string](#string)
  - [hex](#hex)
  - [ascii](#ascii)
  - [fill_buffer_from_set](#fill_buffer_from_set)
  - [bernoulli](#bernoulli)
  - [normal](#normal)
  - [normal_pair](#normal_pair)
  - [binomial](#binomial)
  - [exponential](#exponential)
  - [shuffle](#shuffle)
  - [shuffle_clone](#shuffle_clone)
  - [choose](#choose)
  - [element](#element)
  - [sample](#sample)

## ascii
[[Return to contents]](#Contents)

## bernoulli
[[Return to contents]](#Contents)

## binomial
[[Return to contents]](#Contents)

## bytes
[[Return to contents]](#Contents)

## choose
[[Return to contents]](#Contents)

## element
[[Return to contents]](#Contents)

## exponential
[[Return to contents]](#Contents)

## f32
[[Return to contents]](#Contents)

## f32_in_range
[[Return to contents]](#Contents)

## f32cp
[[Return to contents]](#Contents)

## f32n
[[Return to contents]](#Contents)

## f64
[[Return to contents]](#Contents)

## f64_in_range
[[Return to contents]](#Contents)

## f64cp
[[Return to contents]](#Contents)

## f64n
[[Return to contents]](#Contents)

## fill_buffer_from_set
[[Return to contents]](#Contents)

## get_current_rng
[[Return to contents]](#Contents)

## hex
[[Return to contents]](#Contents)

## i16
[[Return to contents]](#Contents)

## i32
[[Return to contents]](#Contents)

## i32_in_range
[[Return to contents]](#Contents)

## i32n
[[Return to contents]](#Contents)

## i64
[[Return to contents]](#Contents)

## i64_in_range
[[Return to contents]](#Contents)

## i64n
[[Return to contents]](#Contents)

## int
[[Return to contents]](#Contents)

## int31
[[Return to contents]](#Contents)

## int63
[[Return to contents]](#Contents)

## int_in_range
[[Return to contents]](#Contents)

## intn
[[Return to contents]](#Contents)

## new_default
[[Return to contents]](#Contents)

## normal
[[Return to contents]](#Contents)

## normal_pair
[[Return to contents]](#Contents)

## read
[[Return to contents]](#Contents)

## sample
[[Return to contents]](#Contents)

## seed
[[Return to contents]](#Contents)

## set_rng
[[Return to contents]](#Contents)

## shuffle
[[Return to contents]](#Contents)

## shuffle_clone
[[Return to contents]](#Contents)

## string
[[Return to contents]](#Contents)

## string_from_set
[[Return to contents]](#Contents)

## u16
[[Return to contents]](#Contents)

## u32
[[Return to contents]](#Contents)

## u32_in_range
[[Return to contents]](#Contents)

## u32n
[[Return to contents]](#Contents)

## u64
[[Return to contents]](#Contents)

## u64_in_range
[[Return to contents]](#Contents)

## u64n
[[Return to contents]](#Contents)

## u8
[[Return to contents]](#Contents)

## ulid
[[Return to contents]](#Contents)

## ulid_at_millisecond
[[Return to contents]](#Contents)

## uuid_v4
[[Return to contents]](#Contents)

## PRNG
[[Return to contents]](#Contents)

## bytes
[[Return to contents]](#Contents)

## read
[[Return to contents]](#Contents)

## i32n
[[Return to contents]](#Contents)

## u32n
[[Return to contents]](#Contents)

## u64n
[[Return to contents]](#Contents)

## u32_in_range
[[Return to contents]](#Contents)

## u64_in_range
[[Return to contents]](#Contents)

## i8
[[Return to contents]](#Contents)

## i16
[[Return to contents]](#Contents)

## i32
[[Return to contents]](#Contents)

## int
[[Return to contents]](#Contents)

## i64
[[Return to contents]](#Contents)

## int31
[[Return to contents]](#Contents)

## int63
[[Return to contents]](#Contents)

## intn
[[Return to contents]](#Contents)

## i64n
[[Return to contents]](#Contents)

## int_in_range
[[Return to contents]](#Contents)

## i32_in_range
[[Return to contents]](#Contents)

## i64_in_range
[[Return to contents]](#Contents)

## f32
[[Return to contents]](#Contents)

## f32cp
[[Return to contents]](#Contents)

## f64
[[Return to contents]](#Contents)

## f64cp
[[Return to contents]](#Contents)

## f32n
[[Return to contents]](#Contents)

## f64n
[[Return to contents]](#Contents)

## f32_in_range
[[Return to contents]](#Contents)

## f64_in_range
[[Return to contents]](#Contents)

## ulid
[[Return to contents]](#Contents)

## ulid_at_millisecond
[[Return to contents]](#Contents)

## string_from_set
[[Return to contents]](#Contents)

## string
[[Return to contents]](#Contents)

## hex
[[Return to contents]](#Contents)

## ascii
[[Return to contents]](#Contents)

## fill_buffer_from_set
[[Return to contents]](#Contents)

## bernoulli
[[Return to contents]](#Contents)

## normal
[[Return to contents]](#Contents)

## normal_pair
[[Return to contents]](#Contents)

## binomial
[[Return to contents]](#Contents)

## exponential
[[Return to contents]](#Contents)

## shuffle
[[Return to contents]](#Contents)

## shuffle_clone
[[Return to contents]](#Contents)

## choose
[[Return to contents]](#Contents)

## element
[[Return to contents]](#Contents)

## sample
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:55
