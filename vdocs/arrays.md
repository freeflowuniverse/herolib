# module arrays


## Contents
- [append](#append)
- [binary_search](#binary_search)
- [carray_to_varray](#carray_to_varray)
- [chunk](#chunk)
- [chunk_while](#chunk_while)
- [concat](#concat)
- [copy](#copy)
- [distinct](#distinct)
- [each](#each)
- [each_indexed](#each_indexed)
- [filter_indexed](#filter_indexed)
- [find_first](#find_first)
- [find_last](#find_last)
- [flat_map](#flat_map)
- [flat_map_indexed](#flat_map_indexed)
- [flatten](#flatten)
- [fold](#fold)
- [fold_indexed](#fold_indexed)
- [group](#group)
- [group_by](#group_by)
- [idx_max](#idx_max)
- [idx_min](#idx_min)
- [index_of_first](#index_of_first)
- [index_of_last](#index_of_last)
- [join_to_string](#join_to_string)
- [lower_bound](#lower_bound)
- [map_indexed](#map_indexed)
- [map_of_counts](#map_of_counts)
- [map_of_indexes](#map_of_indexes)
- [max](#max)
- [merge](#merge)
- [min](#min)
- [partition](#partition)
- [reduce](#reduce)
- [reduce_indexed](#reduce_indexed)
- [rotate_left](#rotate_left)
- [rotate_right](#rotate_right)
- [sum](#sum)
- [uniq](#uniq)
- [uniq_all_repeated](#uniq_all_repeated)
- [uniq_only](#uniq_only)
- [uniq_only_repeated](#uniq_only_repeated)
- [upper_bound](#upper_bound)
- [window](#window)
- [WindowAttribute](#WindowAttribute)

## append
Example
```v

arrays.append([1, 3, 5, 7], [2, 4, 6, 8]) // => [1, 3, 5, 7, 2, 4, 6, 8]

```

[[Return to contents]](#Contents)

## binary_search
Example
```v

arrays.binary_search([1, 2, 3, 4], 4)! // => 3

```

[[Return to contents]](#Contents)

## carray_to_varray
[[Return to contents]](#Contents)

## chunk
Example
```v

arrays.chunk([1, 2, 3, 4, 5, 6, 7, 8, 9], 2)) // => [[1, 2], [3, 4], [5, 6], [7, 8], [9]]

```

[[Return to contents]](#Contents)

## chunk_while
Examples
```v

assert arrays.chunk_while([0,9,2,2,3,2,7,5,9,5],fn(x int,y int)bool{return x<=y})==[[0,9],[2,2,3],[2,7],[5,9],[5]]

assert arrays.chunk_while('aaaabbbcca'.runes(),fn(x rune,y rune)bool{return x==y})==[[`a`,`a`,`a`,`a`],[`b`,`b`,`b`],[`c`,`c`],[`a`]]

assert arrays.chunk_while('aaaabbbcca'.runes(),fn(x rune,y rune)bool{return x==y}).map({it[0]:it.len})==[{`a`:4},{`b`:3},{`c`:2},{`a`:1}]

```

[[Return to contents]](#Contents)

## concat
Examples
```v

arrays.concat([1, 2, 3], 4, 5, 6) == [1, 2, 3, 4, 5, 6] // => true

arrays.concat([1, 2, 3], ...[4, 5, 6]) == [1, 2, 3, 4, 5, 6] // => true

arr << [4, 5, 6] // does what you need if arr is mutable

```

[[Return to contents]](#Contents)

## copy
[[Return to contents]](#Contents)

## distinct
Example
```v

assert arrays.distinct( [5, 5, 1, 5, 2, 1, 1, 9] ) == [1, 2, 5, 9]

```

[[Return to contents]](#Contents)

## each
[[Return to contents]](#Contents)

## each_indexed
[[Return to contents]](#Contents)

## filter_indexed
[[Return to contents]](#Contents)

## find_first
Example
```v

arrays.find_first([1, 2, 3, 4, 5], fn (i int) bool { return i == 3 })? // => 3

```

[[Return to contents]](#Contents)

## find_last
Example
```v

arrays.find_last([1, 2, 3, 4, 5], fn (i int) bool { return i == 3})? // => 3

```

[[Return to contents]](#Contents)

## flat_map
[[Return to contents]](#Contents)

## flat_map_indexed
[[Return to contents]](#Contents)

## flatten
Example
```v

arrays.flatten[int]([[1, 2, 3], [4, 5]]) // => [1, 2, 3, 4, 5]

```

[[Return to contents]](#Contents)

## fold
Example
```v

// Sum the length of each string in an array
a := ['Hi', 'all']
r := arrays.fold[string, int](a, 0,
	fn (r int, t string) int { return r + t.len })
assert r == 5

```

[[Return to contents]](#Contents)

## fold_indexed
[[Return to contents]](#Contents)

## group
Example
```v

arrays.group[int]([1, 2, 3], [4, 5, 6]) // => [[1, 4], [2, 5], [3, 6]]

```

[[Return to contents]](#Contents)

## group_by
Example
```v

arrays.group_by[int, string](['H', 'el', 'lo'], fn (v string) int { return v.len }) // => {1: ['H'], 2: ['el', 'lo']}

```

[[Return to contents]](#Contents)

## idx_max
Example
```v

arrays.idx_max([1, 2, 3, 0, 9])! // => 4

```

[[Return to contents]](#Contents)

## idx_min
Example
```v

arrays.idx_min([1, 2, 3, 0, 9])! // => 3

```

[[Return to contents]](#Contents)

## index_of_first
Example
```v

arrays.index_of_first([4,5,0,7,0,9], fn(idx int, x int) bool { return x == 0 }) == 2

```

[[Return to contents]](#Contents)

## index_of_last
Example
```v

arrays.index_of_last([4,5,0,7,0,9], fn(idx int, x int) bool { return x == 0 }) == 4

```

[[Return to contents]](#Contents)

## join_to_string
[[Return to contents]](#Contents)

## lower_bound
Example
```v

arrays.lower_bound([2, 4, 6, 8], 3)! // => 4

```

[[Return to contents]](#Contents)

## map_indexed
[[Return to contents]](#Contents)

## map_of_counts
Example
```v

arrays.map_of_counts([1,2,3,4,4,2,1,4,4]) == {1: 2, 2: 2, 3: 1, 4: 4}

```

[[Return to contents]](#Contents)

## map_of_indexes
Example
```v

arrays.map_of_indexes([1,2,3,4,4,2,1,4,4,999]) == {1: [0, 6], 2: [1, 5], 3: [2], 4: [3, 4, 7, 8], 999: [9]}

```

[[Return to contents]](#Contents)

## max
Example
```v

arrays.max([1, 2, 3, 0, 9])! // => 9

```

[[Return to contents]](#Contents)

## merge
Example
```v

arrays.merge([1, 3, 5, 7], [2, 4, 6, 8]) // => [1, 2, 3, 4, 5, 6, 7, 8]

```

[[Return to contents]](#Contents)

## min
Example
```v

arrays.min([1, 2, 3, 0, 9])! // => 0

```

[[Return to contents]](#Contents)

## partition
[[Return to contents]](#Contents)

## reduce
Example
```v

arrays.reduce([1, 2, 3, 4, 5], fn (t1 int, t2 int) int { return t1 * t2 })! // => 120

```

[[Return to contents]](#Contents)

## reduce_indexed
[[Return to contents]](#Contents)

## rotate_left
Example
```v

mut x := [1,2,3,4,5,6]
arrays.rotate_left(mut x, 2)
println(x) // [3, 4, 5, 6, 1, 2]

```

[[Return to contents]](#Contents)

## rotate_right
Example
```v

mut x := [1,2,3,4,5,6]
arrays.rotate_right(mut x, 2)
println(x) // [5, 6, 1, 2, 3, 4]

```

[[Return to contents]](#Contents)

## sum
Example
```v

arrays.sum([1, 2, 3, 4, 5])! // => 15

```

[[Return to contents]](#Contents)

## uniq
Examples
```v

assert arrays.uniq( []int{} ) == []

assert arrays.uniq( [1, 1] ) == [1]

assert arrays.uniq( [2, 1] ) == [2, 1]

assert arrays.uniq( [5, 5, 1, 5, 2, 1, 1, 9] ) == [5, 1, 5, 2, 1, 9]

```

[[Return to contents]](#Contents)

## uniq_all_repeated
Examples
```v

assert arrays.uniq_all_repeated( []int{} ) == []

assert arrays.uniq_all_repeated( [1, 5] ) == []

assert arrays.uniq_all_repeated( [5, 5] ) == [5,5]

assert arrays.uniq_all_repeated( [5, 5, 1, 5, 2, 1, 1, 9] ) == [5, 5, 1, 1]

```

[[Return to contents]](#Contents)

## uniq_only
Examples
```v

assert arrays.uniq_only( []int{} ) == []

assert arrays.uniq_only( [1, 1] ) == []

assert arrays.uniq_only( [2, 1] ) == [2, 1]

assert arrays.uniq_only( [1, 5, 5, 1, 5, 2, 1, 1, 9] ) == [1, 1, 5, 2, 9]

```

[[Return to contents]](#Contents)

## uniq_only_repeated
Examples
```v

assert arrays.uniq_only_repeated( []int{} ) == []

assert arrays.uniq_only_repeated( [1, 5] ) == []

assert arrays.uniq_only_repeated( [5, 5] ) == [5]

assert arrays.uniq_only_repeated( [5, 5, 1, 5, 2, 1, 1, 9] ) == [5, 1]

```

[[Return to contents]](#Contents)

## upper_bound
Example
```v

arrays.upper_bound([2, 4, 6, 8], 3)! // => 2

```

[[Return to contents]](#Contents)

## window
Examples
```v

arrays.window([1, 2, 3, 4], size: 2) // => [[1, 2], [2, 3], [3, 4]]

arrays.window([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], size: 3, step: 2) // => [[1, 2, 3], [3, 4, 5], [5, 6, 7], [7, 8, 9]]

```

[[Return to contents]](#Contents)

## WindowAttribute
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:55
