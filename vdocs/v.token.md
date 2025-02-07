# module v.token


## Contents
- [Constants](#Constants)
- [assign_op_to_infix_op](#assign_op_to_infix_op)
- [build_precedences](#build_precedences)
- [is_decl](#is_decl)
- [is_key](#is_key)
- [kind_to_string](#kind_to_string)
- [new_keywords_matcher_from_array_trie](#new_keywords_matcher_from_array_trie)
- [new_keywords_matcher_trie](#new_keywords_matcher_trie)
- [new_trie_node](#new_trie_node)
- [KeywordsMatcherTrie.new](#KeywordsMatcherTrie.new)
- [AtKind](#AtKind)
- [Kind](#Kind)
  - [is_assign](#is_assign)
  - [str](#str)
  - [precedence](#precedence)
  - [is_relational](#is_relational)
  - [is_start_of_type](#is_start_of_type)
  - [is_prefix](#is_prefix)
  - [is_infix](#is_infix)
  - [is_postfix](#is_postfix)
- [Precedence](#Precedence)
- [KeywordsMatcherTrie](#KeywordsMatcherTrie)
  - [find](#find)
  - [matches](#matches)
  - [add_word](#add_word)
- [Pos](#Pos)
  - [free](#free)
  - [line_str](#line_str)
  - [extend](#extend)
  - [extend_with_last_line](#extend_with_last_line)
  - [update_last_line](#update_last_line)
- [Token](#Token)
  - [debug](#debug)
  - [is_next_to](#is_next_to)
  - [is_scalar](#is_scalar)
  - [is_unary](#is_unary)
  - [pos](#pos)
  - [precedence](#precedence)
  - [str](#str)
- [TrieNode](#TrieNode)
  - [show](#show)
  - [add_word](#add_word)
  - [find](#find)

## Constants
[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

[[Return to contents]](#Contents)

## assign_op_to_infix_op
[[Return to contents]](#Contents)

## build_precedences
[[Return to contents]](#Contents)

## is_decl
[[Return to contents]](#Contents)

## is_key
[[Return to contents]](#Contents)

## kind_to_string
[[Return to contents]](#Contents)

## new_keywords_matcher_from_array_trie
[[Return to contents]](#Contents)

## new_keywords_matcher_trie
[[Return to contents]](#Contents)

## new_trie_node
[[Return to contents]](#Contents)

## KeywordsMatcherTrie.new
[[Return to contents]](#Contents)

## AtKind
[[Return to contents]](#Contents)

## Kind
[[Return to contents]](#Contents)

## is_assign
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## precedence
[[Return to contents]](#Contents)

## is_relational
[[Return to contents]](#Contents)

## is_start_of_type
[[Return to contents]](#Contents)

## is_prefix
[[Return to contents]](#Contents)

## is_infix
[[Return to contents]](#Contents)

## is_postfix
[[Return to contents]](#Contents)

## Precedence
[[Return to contents]](#Contents)

## KeywordsMatcherTrie
[[Return to contents]](#Contents)

## find
[[Return to contents]](#Contents)

## matches
[[Return to contents]](#Contents)

## add_word
[[Return to contents]](#Contents)

## Pos
[[Return to contents]](#Contents)

## free
[[Return to contents]](#Contents)

## line_str
[[Return to contents]](#Contents)

## extend
[[Return to contents]](#Contents)

## extend_with_last_line
[[Return to contents]](#Contents)

## update_last_line
[[Return to contents]](#Contents)

## Token
[[Return to contents]](#Contents)

## debug
[[Return to contents]](#Contents)

## is_next_to
[[Return to contents]](#Contents)

## is_scalar
[[Return to contents]](#Contents)

## is_unary
[[Return to contents]](#Contents)

## pos
[[Return to contents]](#Contents)

## precedence
[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## TrieNode
[[Return to contents]](#Contents)

## show
[[Return to contents]](#Contents)

## add_word
[[Return to contents]](#Contents)

## find
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:56
