# module datatypes


## Contents
- [new_bloom_filter](#new_bloom_filter)
- [new_bloom_filter_fast](#new_bloom_filter_fast)
- [new_ringbuffer](#new_ringbuffer)
- [BSTree[T]](#BSTree[T])
  - [insert](#insert)
  - [contains](#contains)
  - [remove](#remove)
  - [is_empty](#is_empty)
  - [in_order_traversal](#in_order_traversal)
  - [post_order_traversal](#post_order_traversal)
  - [pre_order_traversal](#pre_order_traversal)
  - [to_left](#to_left)
  - [to_right](#to_right)
  - [max](#max)
  - [min](#min)
- [BloomFilter[T]](#BloomFilter[T])
  - [add](#add)
  - [exists](#exists)
  - [@union](#@union)
  - [intersection](#intersection)
- [DoublyLinkedList[T]](#DoublyLinkedList[T])
  - [is_empty](#is_empty)
  - [len](#len)
  - [first](#first)
  - [last](#last)
  - [push_back](#push_back)
  - [push_front](#push_front)
  - [push_many](#push_many)
  - [pop_back](#pop_back)
  - [pop_front](#pop_front)
  - [insert](#insert)
  - [index](#index)
  - [delete](#delete)
  - [str](#str)
  - [array](#array)
  - [next](#next)
  - [iterator](#iterator)
  - [back_iterator](#back_iterator)
- [DoublyListIterBack[T]](#DoublyListIterBack[T])
  - [next](#next)
- [DoublyListIter[T]](#DoublyListIter[T])
  - [next](#next)
- [LinkedList[T]](#LinkedList[T])
  - [is_empty](#is_empty)
  - [len](#len)
  - [first](#first)
  - [last](#last)
  - [index](#index)
  - [push](#push)
  - [push_many](#push_many)
  - [pop](#pop)
  - [shift](#shift)
  - [insert](#insert)
  - [prepend](#prepend)
  - [str](#str)
  - [array](#array)
  - [next](#next)
  - [iterator](#iterator)
- [ListIter[T]](#ListIter[T])
  - [next](#next)
- [MinHeap[T]](#MinHeap[T])
  - [insert](#insert)
  - [insert_many](#insert_many)
  - [pop](#pop)
  - [peek](#peek)
  - [len](#len)
- [Queue[T]](#Queue[T])
  - [is_empty](#is_empty)
  - [len](#len)
  - [peek](#peek)
  - [last](#last)
  - [index](#index)
  - [push](#push)
  - [pop](#pop)
  - [str](#str)
  - [array](#array)
- [RingBuffer[T]](#RingBuffer[T])
  - [push](#push)
  - [pop](#pop)
  - [push_many](#push_many)
  - [pop_many](#pop_many)
  - [is_empty](#is_empty)
  - [is_full](#is_full)
  - [capacity](#capacity)
  - [clear](#clear)
  - [occupied](#occupied)
  - [remaining](#remaining)
- [Set[T]](#Set[T])
  - [exists](#exists)
  - [add](#add)
  - [remove](#remove)
  - [pick](#pick)
  - [rest](#rest)
  - [pop](#pop)
  - [clear](#clear)
  - [==](#==)
  - [is_empty](#is_empty)
  - [size](#size)
  - [copy](#copy)
  - [add_all](#add_all)
  - [@union](#@union)
  - [intersection](#intersection)
  - [-](#-)
  - [subset](#subset)
- [Stack[T]](#Stack[T])
  - [is_empty](#is_empty)
  - [len](#len)
  - [peek](#peek)
  - [push](#push)
  - [pop](#pop)
  - [str](#str)
  - [array](#array)
- [Direction](#Direction)
- [AABB](#AABB)
- [BSTree](#BSTree)
- [DoublyLinkedList](#DoublyLinkedList)
- [DoublyListIter](#DoublyListIter)
- [DoublyListIterBack](#DoublyListIterBack)
- [LinkedList](#LinkedList)
- [ListIter](#ListIter)
- [ListNode](#ListNode)
- [MinHeap](#MinHeap)
- [Quadtree](#Quadtree)
  - [create](#create)
  - [insert](#insert)
  - [retrieve](#retrieve)
  - [clear](#clear)
  - [get_nodes](#get_nodes)
- [Queue](#Queue)
- [RingBuffer](#RingBuffer)
- [Set](#Set)
- [Stack](#Stack)

## new_bloom_filter
[[Return to contents]](#Contents)

## new_bloom_filter_fast
[[Return to contents]](#Contents)

## new_ringbuffer
[[Return to contents]](#Contents)

## BSTree[T]
## insert
[[Return to contents]](#Contents)

## contains
[[Return to contents]](#Contents)

## remove
[[Return to contents]](#Contents)

## is_empty
[[Return to contents]](#Contents)

## in_order_traversal
[[Return to contents]](#Contents)

## post_order_traversal
[[Return to contents]](#Contents)

## pre_order_traversal
[[Return to contents]](#Contents)

## to_left
[[Return to contents]](#Contents)

## to_right
[[Return to contents]](#Contents)

## max
[[Return to contents]](#Contents)

## min
[[Return to contents]](#Contents)

## BloomFilter[T]
## add
[[Return to contents]](#Contents)

## exists
[[Return to contents]](#Contents)

## @union
[[Return to contents]](#Contents)

## intersection
[[Return to contents]](#Contents)

## DoublyLinkedList[T]
## is_empty
[[Return to contents]](#Contents)

## len
[[Return to contents]](#Contents)

## first
[[Return to contents]](#Contents)

## last
[[Return to contents]](#Contents)

## push_back
[[Return to contents]](#Contents)

## push_front
[[Return to contents]](#Contents)

## push_many
[[Return to contents]](#Contents)

## pop_back
[[Return to contents]](#Contents)

## pop_front
[[Return to contents]](#Contents)

## insert
[[Return to contents]](#Contents)

## index
[[Return to contents]](#Contents)

## delete
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## array
[[Return to contents]](#Contents)

## next
[[Return to contents]](#Contents)

## iterator
[[Return to contents]](#Contents)

## back_iterator
[[Return to contents]](#Contents)

## DoublyListIterBack[T]
## next
[[Return to contents]](#Contents)

## DoublyListIter[T]
## next
[[Return to contents]](#Contents)

## LinkedList[T]
## is_empty
[[Return to contents]](#Contents)

## len
[[Return to contents]](#Contents)

## first
[[Return to contents]](#Contents)

## last
[[Return to contents]](#Contents)

## index
[[Return to contents]](#Contents)

## push
[[Return to contents]](#Contents)

## push_many
[[Return to contents]](#Contents)

## pop
[[Return to contents]](#Contents)

## shift
[[Return to contents]](#Contents)

## insert
[[Return to contents]](#Contents)

## prepend
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## array
[[Return to contents]](#Contents)

## next
[[Return to contents]](#Contents)

## iterator
[[Return to contents]](#Contents)

## ListIter[T]
## next
[[Return to contents]](#Contents)

## MinHeap[T]
## insert
[[Return to contents]](#Contents)

## insert_many
[[Return to contents]](#Contents)

## pop
[[Return to contents]](#Contents)

## peek
[[Return to contents]](#Contents)

## len
[[Return to contents]](#Contents)

## Queue[T]
## is_empty
[[Return to contents]](#Contents)

## len
[[Return to contents]](#Contents)

## peek
[[Return to contents]](#Contents)

## last
[[Return to contents]](#Contents)

## index
[[Return to contents]](#Contents)

## push
[[Return to contents]](#Contents)

## pop
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## array
[[Return to contents]](#Contents)

## RingBuffer[T]
## push
[[Return to contents]](#Contents)

## pop
[[Return to contents]](#Contents)

## push_many
[[Return to contents]](#Contents)

## pop_many
[[Return to contents]](#Contents)

## is_empty
[[Return to contents]](#Contents)

## is_full
[[Return to contents]](#Contents)

## capacity
[[Return to contents]](#Contents)

## clear
[[Return to contents]](#Contents)

## occupied
[[Return to contents]](#Contents)

## remaining
[[Return to contents]](#Contents)

## Set[T]
## exists
[[Return to contents]](#Contents)

## add
[[Return to contents]](#Contents)

## remove
[[Return to contents]](#Contents)

## pick
[[Return to contents]](#Contents)

## rest
[[Return to contents]](#Contents)

## pop
[[Return to contents]](#Contents)

## clear
[[Return to contents]](#Contents)

## ==
[[Return to contents]](#Contents)

## is_empty
[[Return to contents]](#Contents)

## size
[[Return to contents]](#Contents)

## copy
[[Return to contents]](#Contents)

## add_all
[[Return to contents]](#Contents)

## @union
[[Return to contents]](#Contents)

## intersection
[[Return to contents]](#Contents)

## -
[[Return to contents]](#Contents)

## subset
[[Return to contents]](#Contents)

## Stack[T]
## is_empty
[[Return to contents]](#Contents)

## len
[[Return to contents]](#Contents)

## peek
[[Return to contents]](#Contents)

## push
[[Return to contents]](#Contents)

## pop
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## array
[[Return to contents]](#Contents)

## Direction
[[Return to contents]](#Contents)

## AABB
[[Return to contents]](#Contents)

## BSTree
[[Return to contents]](#Contents)

## DoublyLinkedList
[[Return to contents]](#Contents)

## DoublyListIter
[[Return to contents]](#Contents)

## DoublyListIterBack
[[Return to contents]](#Contents)

## LinkedList
[[Return to contents]](#Contents)

## ListIter
[[Return to contents]](#Contents)

## ListNode
[[Return to contents]](#Contents)

## MinHeap
[[Return to contents]](#Contents)

## Quadtree
[[Return to contents]](#Contents)

## create
[[Return to contents]](#Contents)

## insert
[[Return to contents]](#Contents)

## retrieve
[[Return to contents]](#Contents)

## clear
[[Return to contents]](#Contents)

## get_nodes
[[Return to contents]](#Contents)

## Queue
[[Return to contents]](#Contents)

## RingBuffer
[[Return to contents]](#Contents)

## Set
[[Return to contents]](#Contents)

## Stack
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:55
