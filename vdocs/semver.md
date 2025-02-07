# module semver


## Contents
- [build](#build)
- [coerce](#coerce)
- [from](#from)
- [is_valid](#is_valid)
- [EmptyInputError](#EmptyInputError)
  - [msg](#msg)
- [InvalidVersionFormatError](#InvalidVersionFormatError)
  - [msg](#msg)
- [Increment](#Increment)
- [Version](#Version)
  - [increment](#increment)
  - [satisfies](#satisfies)
  - [==](#==)
  - [<](#<)
  - [str](#str)

## build
[[Return to contents]](#Contents)

## coerce
[[Return to contents]](#Contents)

## from
[[Return to contents]](#Contents)

## is_valid
[[Return to contents]](#Contents)

## EmptyInputError
## msg
[[Return to contents]](#Contents)

## InvalidVersionFormatError
## msg
[[Return to contents]](#Contents)

## Increment
[[Return to contents]](#Contents)

## Version
[[Return to contents]](#Contents)

## increment
[[Return to contents]](#Contents)

## satisfies
Examples
```v

assert semver.build(1,0,0).satisfies('<=2.0.0') == true

assert semver.build(1,0,0).satisfies('>=2.0.0') == false

```

[[Return to contents]](#Contents)

## ==
[[Return to contents]](#Contents)

## <
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:55
