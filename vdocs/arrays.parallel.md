# module arrays.parallel


## Contents
- [amap](#amap)
- [run](#run)
- [Params](#Params)

## amap
Example
```v

squares := parallel.amap([1, 2, 3, 4, 5], 2, fn (i) { return i * i })

```

[[Return to contents]](#Contents)

## run
Example
```v

parallel.run([1, 2, 3, 4, 5], 2, fn (i) { println(i) })

```

[[Return to contents]](#Contents)

## Params
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:55
