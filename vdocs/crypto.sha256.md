# module crypto.sha256


## Contents
- [Constants](#Constants)
- [hexhash](#hexhash)
- [hexhash_224](#hexhash_224)
- [new](#new)
- [new224](#new224)
- [sum](#sum)
- [sum224](#sum224)
- [sum256](#sum256)
- [Digest](#Digest)
  - [free](#free)
  - [reset](#reset)
  - [write](#write)
  - [sum](#sum)
  - [size](#size)
  - [block_size](#block_size)

## Constants
[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

## hexhash
Example
```v

assert sha256.hexhash('V') == 'de5a6f78116eca62d7fc5ce159d23ae6b889b365a1739ad2cf36f925a140d0cc'

```

[[Return to contents]](#Contents)

## hexhash_224
[[Return to contents]](#Contents)

## new
[[Return to contents]](#Contents)

## new224
[[Return to contents]](#Contents)

## sum
Example
```v

assert sha256.sum('V'.bytes()).len > 0 == true

```

[[Return to contents]](#Contents)

## sum224
[[Return to contents]](#Contents)

## sum256
[[Return to contents]](#Contents)

## Digest
## free
[[Return to contents]](#Contents)

## reset
[[Return to contents]](#Contents)

## write
[[Return to contents]](#Contents)

## sum
[[Return to contents]](#Contents)

## size
[[Return to contents]](#Contents)

## block_size
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:55
