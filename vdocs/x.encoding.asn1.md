# module x.encoding.asn1


## Contents
- [Constants](#Constants)
- [decode](#decode)
- [decode_with_field_options](#decode_with_field_options)
- [decode_with_options](#decode_with_options)
- [encode](#encode)
- [encode_with_field_options](#encode_with_field_options)
- [encode_with_options](#encode_with_options)
- [encoded_len](#encoded_len)
- [make_payload](#make_payload)
- [new_key_default](#new_key_default)
- [AnyDefinedBy.new](#AnyDefinedBy.new)
- [ApplicationElement.from_element](#ApplicationElement.from_element)
- [ApplicationElement.new](#ApplicationElement.new)
- [BitString.from_binary_string](#BitString.from_binary_string)
- [BitString.new](#BitString.new)
- [Boolean.new](#Boolean.new)
- [Boolean.parse](#Boolean.parse)
- [Choice.new](#Choice.new)
- [ContextElement.explicit_context](#ContextElement.explicit_context)
- [ContextElement.from_element](#ContextElement.from_element)
- [ContextElement.implicit_context](#ContextElement.implicit_context)
- [ContextElement.new](#ContextElement.new)
- [Element.from_object](#Element.from_object)
- [ElementList.from_bytes](#ElementList.from_bytes)
- [Enumerated.new](#Enumerated.new)
- [FieldOptions.from_attrs](#FieldOptions.from_attrs)
- [FieldOptions.from_string](#FieldOptions.from_string)
- [GeneralString.new](#GeneralString.new)
- [GeneralizedTime.from_time](#GeneralizedTime.from_time)
- [GeneralizedTime.new](#GeneralizedTime.new)
- [IA5String.new](#IA5String.new)
- [Integer.from_bigint](#Integer.from_bigint)
- [Integer.from_hex](#Integer.from_hex)
- [Integer.from_i64](#Integer.from_i64)
- [Integer.from_int](#Integer.from_int)
- [Integer.from_string](#Integer.from_string)
- [Length.from_bytes](#Length.from_bytes)
- [Length.new](#Length.new)
- [NumericString.new](#NumericString.new)
- [ObjectIdentifier.from_ints](#ObjectIdentifier.from_ints)
- [ObjectIdentifier.new](#ObjectIdentifier.new)
- [OctetString.from_hexstring](#OctetString.from_hexstring)
- [OctetString.new](#OctetString.new)
- [Optional.new](#Optional.new)
- [Parser.new](#Parser.new)
- [PrintableString.new](#PrintableString.new)
- [PrivateELement.from_element](#PrivateELement.from_element)
- [PrivateELement.new](#PrivateELement.new)
- [RawElement.from_element](#RawElement.from_element)
- [RawElement.new](#RawElement.new)
- [Sequence.from_list](#Sequence.from_list)
- [Sequence.new](#Sequence.new)
- [SequenceOf.from_list](#SequenceOf.from_list)
- [SequenceOf.new](#SequenceOf.new)
- [Set.from_list](#Set.from_list)
- [Set.new](#Set.new)
- [SetOf.from_list](#SetOf.from_list)
- [SetOf.new](#SetOf.new)
- [Tag.from_bytes](#Tag.from_bytes)
- [Tag.new](#Tag.new)
- [UtcTime.from_time](#UtcTime.from_time)
- [UtcTime.new](#UtcTime.new)
- [Utf8String.from_bytes](#Utf8String.from_bytes)
- [Utf8String.new](#Utf8String.new)
- [VisibleString.new](#VisibleString.new)
- [Element](#Element)
  - [encoded_len](#encoded_len)
  - [equal](#equal)
  - [into_object](#into_object)
  - [length](#length)
  - [set_default_value](#set_default_value)
  - [unwrap_with_field_options](#unwrap_with_field_options)
  - [unwrap_with_options](#unwrap_with_options)
- [ElementList](#ElementList)
  - [payload](#payload)
  - [encoded_len](#encoded_len)
- [KeyDefault](#KeyDefault)
- [Length](#Length)
  - [encode](#encode)
- [SequenceOf[T]](#SequenceOf[T])
  - [tag](#tag)
  - [payload](#payload)
  - [fields](#fields)
- [SetOf[T]](#SetOf[T])
  - [tag](#tag)
  - [fields](#fields)
  - [payload](#payload)
  - [add_element](#add_element)
- [EncodingRule](#EncodingRule)
- [TagClass](#TagClass)
- [TagType](#TagType)
- [TaggedMode](#TaggedMode)
- [AnyDefinedBy](#AnyDefinedBy)
  - [tag](#tag)
  - [payload](#payload)
- [ApplicationElement](#ApplicationElement)
  - [tag](#tag)
  - [payload](#payload)
- [BitString](#BitString)
  - [data](#data)
  - [pad](#pad)
  - [tag](#tag)
  - [payload](#payload)
- [Boolean](#Boolean)
  - [tag](#tag)
  - [payload](#payload)
  - [value](#value)
- [Choice](#Choice)
  - [set_size](#set_size)
  - [choose](#choose)
  - [tag](#tag)
  - [payload](#payload)
- [ContextElement](#ContextElement)
  - [tag](#tag)
  - [payload](#payload)
- [Enumerated](#Enumerated)
  - [tag](#tag)
  - [payload](#payload)
- [FieldOptions](#FieldOptions)
  - [install_default](#install_default)
- [GeneralString](#GeneralString)
  - [tag](#tag)
  - [payload](#payload)
- [GeneralizedTime](#GeneralizedTime)
  - [into_utctime](#into_utctime)
  - [tag](#tag)
  - [payload](#payload)
- [IA5String](#IA5String)
  - [tag](#tag)
  - [payload](#payload)
- [Integer](#Integer)
  - [hex](#hex)
  - [tag](#tag)
  - [payload](#payload)
  - [equal](#equal)
  - [as_bigint](#as_bigint)
  - [as_i64](#as_i64)
- [Null](#Null)
  - [tag](#tag)
  - [payload](#payload)
- [NumericString](#NumericString)
  - [tag](#tag)
  - [payload](#payload)
- [ObjectIdentifier](#ObjectIdentifier)
  - [value](#value)
  - [tag](#tag)
  - [payload](#payload)
  - [equal](#equal)
- [OctetString](#OctetString)
  - [tag](#tag)
  - [payload](#payload)
- [Optional](#Optional)
  - [set_present_bit](#set_present_bit)
  - [tag](#tag)
  - [payload](#payload)
  - [encode](#encode)
  - [into_element](#into_element)
  - [into_object](#into_object)
- [Parser](#Parser)
  - [reset](#reset)
  - [peek_tag](#peek_tag)
  - [read_tag](#read_tag)
  - [read_length](#read_length)
  - [read_bytes](#read_bytes)
  - [read_tlv](#read_tlv)
  - [finish](#finish)
  - [is_empty](#is_empty)
- [PrintableString](#PrintableString)
  - [tag](#tag)
  - [payload](#payload)
- [PrivateELement](#PrivateELement)
  - [tag](#tag)
  - [payload](#payload)
- [RawElement](#RawElement)
  - [tag](#tag)
  - [payload](#payload)
  - [set_mode](#set_mode)
  - [set_inner_tag](#set_inner_tag)
  - [inner_tag](#inner_tag)
  - [inner_element](#inner_element)
- [Sequence](#Sequence)
  - [tag](#tag)
  - [payload](#payload)
  - [encoded_len](#encoded_len)
  - [fields](#fields)
  - [set_size](#set_size)
  - [add_element](#add_element)
  - [is_sequence_of](#is_sequence_of)
  - [into_sequence_of](#into_sequence_of)
- [SequenceOf](#SequenceOf)
- [Set](#Set)
  - [tag](#tag)
  - [payload](#payload)
  - [fields](#fields)
  - [add_element](#add_element)
  - [set_size](#set_size)
- [SetOf](#SetOf)
- [Tag](#Tag)
  - [tag_class](#tag_class)
  - [is_constructed](#is_constructed)
  - [tag_number](#tag_number)
  - [encode](#encode)
  - [equal](#equal)
  - [tag_size](#tag_size)
  - [universal_tag_type](#universal_tag_type)
- [UtcTime](#UtcTime)
  - [tag](#tag)
  - [payload](#payload)
  - [into_utctime](#into_utctime)
- [Utf8String](#Utf8String)
  - [tag](#tag)
  - [payload](#payload)
- [VisibleString](#VisibleString)
  - [tag](#tag)
  - [payload](#payload)

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

## decode
[[Return to contents]](#Contents)

## decode_with_field_options
[[Return to contents]](#Contents)

## decode_with_options
[[Return to contents]](#Contents)

## encode
[[Return to contents]](#Contents)

## encode_with_field_options
[[Return to contents]](#Contents)

## encode_with_options
[[Return to contents]](#Contents)

## encoded_len
[[Return to contents]](#Contents)

## make_payload
[[Return to contents]](#Contents)

## new_key_default
[[Return to contents]](#Contents)

## AnyDefinedBy.new
[[Return to contents]](#Contents)

## ApplicationElement.from_element
[[Return to contents]](#Contents)

## ApplicationElement.new
[[Return to contents]](#Contents)

## BitString.from_binary_string
Example
```v

import x.encoding.asn1

bs := asn1.BitString.from_binary_string('011010001')!
	assert (bs.pad == 7 && bs.data == [u8(0x68), 0x80]) == true

```

[[Return to contents]](#Contents)

## BitString.new
[[Return to contents]](#Contents)

## Boolean.new
[[Return to contents]](#Contents)

## Boolean.parse
[[Return to contents]](#Contents)

## Choice.new
[[Return to contents]](#Contents)

## ContextElement.explicit_context
[[Return to contents]](#Contents)

## ContextElement.from_element
[[Return to contents]](#Contents)

## ContextElement.implicit_context
[[Return to contents]](#Contents)

## ContextElement.new
[[Return to contents]](#Contents)

## Element.from_object
[[Return to contents]](#Contents)

## ElementList.from_bytes
[[Return to contents]](#Contents)

## Enumerated.new
[[Return to contents]](#Contents)

## FieldOptions.from_attrs
[[Return to contents]](#Contents)

## FieldOptions.from_string
[[Return to contents]](#Contents)

## GeneralString.new
[[Return to contents]](#Contents)

## GeneralizedTime.from_time
[[Return to contents]](#Contents)

## GeneralizedTime.new
[[Return to contents]](#Contents)

## IA5String.new
[[Return to contents]](#Contents)

## Integer.from_bigint
[[Return to contents]](#Contents)

## Integer.from_hex
[[Return to contents]](#Contents)

## Integer.from_i64
[[Return to contents]](#Contents)

## Integer.from_int
[[Return to contents]](#Contents)

## Integer.from_string
[[Return to contents]](#Contents)

## Length.from_bytes
[[Return to contents]](#Contents)

## Length.new
[[Return to contents]](#Contents)

## NumericString.new
[[Return to contents]](#Contents)

## ObjectIdentifier.from_ints
[[Return to contents]](#Contents)

## ObjectIdentifier.new
[[Return to contents]](#Contents)

## OctetString.from_hexstring
[[Return to contents]](#Contents)

## OctetString.new
[[Return to contents]](#Contents)

## Optional.new
[[Return to contents]](#Contents)

## Parser.new
[[Return to contents]](#Contents)

## PrintableString.new
[[Return to contents]](#Contents)

## PrivateELement.from_element
[[Return to contents]](#Contents)

## PrivateELement.new
[[Return to contents]](#Contents)

## RawElement.from_element
[[Return to contents]](#Contents)

## RawElement.new
[[Return to contents]](#Contents)

## Sequence.from_list
[[Return to contents]](#Contents)

## Sequence.new
[[Return to contents]](#Contents)

## SequenceOf.from_list
[[Return to contents]](#Contents)

## SequenceOf.new
[[Return to contents]](#Contents)

## Set.from_list
[[Return to contents]](#Contents)

## Set.new
[[Return to contents]](#Contents)

## SetOf.from_list
[[Return to contents]](#Contents)

## SetOf.new
[[Return to contents]](#Contents)

## Tag.from_bytes
[[Return to contents]](#Contents)

## Tag.new
[[Return to contents]](#Contents)

## UtcTime.from_time
[[Return to contents]](#Contents)

## UtcTime.new
[[Return to contents]](#Contents)

## Utf8String.from_bytes
[[Return to contents]](#Contents)

## Utf8String.new
[[Return to contents]](#Contents)

## VisibleString.new
[[Return to contents]](#Contents)

## Element
[[Return to contents]](#Contents)

## encoded_len
[[Return to contents]](#Contents)

## equal
[[Return to contents]](#Contents)

## into_object
[[Return to contents]](#Contents)

## length
[[Return to contents]](#Contents)

## set_default_value
[[Return to contents]](#Contents)

## unwrap_with_field_options
[[Return to contents]](#Contents)

## unwrap_with_options
[[Return to contents]](#Contents)

## ElementList
[[Return to contents]](#Contents)

## payload
[[Return to contents]](#Contents)

## encoded_len
[[Return to contents]](#Contents)

## KeyDefault
[[Return to contents]](#Contents)

## Length
[[Return to contents]](#Contents)

## encode
[[Return to contents]](#Contents)

## SequenceOf[T]
## tag
[[Return to contents]](#Contents)

## payload
[[Return to contents]](#Contents)

## fields
[[Return to contents]](#Contents)

## SetOf[T]
## tag
[[Return to contents]](#Contents)

## fields
[[Return to contents]](#Contents)

## payload
[[Return to contents]](#Contents)

## add_element
[[Return to contents]](#Contents)

## EncodingRule
[[Return to contents]](#Contents)

## TagClass
[[Return to contents]](#Contents)

## TagType
[[Return to contents]](#Contents)

## TaggedMode
[[Return to contents]](#Contents)

## AnyDefinedBy
[[Return to contents]](#Contents)

## tag
[[Return to contents]](#Contents)

## payload
[[Return to contents]](#Contents)

## ApplicationElement
[[Return to contents]](#Contents)

## tag
[[Return to contents]](#Contents)

## payload
[[Return to contents]](#Contents)

## BitString
[[Return to contents]](#Contents)

## data
[[Return to contents]](#Contents)

## pad
[[Return to contents]](#Contents)

## tag
[[Return to contents]](#Contents)

## payload
[[Return to contents]](#Contents)

## Boolean
[[Return to contents]](#Contents)

## tag
[[Return to contents]](#Contents)

## payload
[[Return to contents]](#Contents)

## value
[[Return to contents]](#Contents)

## Choice
[[Return to contents]](#Contents)

## set_size
[[Return to contents]](#Contents)

## choose
[[Return to contents]](#Contents)

## tag
[[Return to contents]](#Contents)

## payload
[[Return to contents]](#Contents)

## ContextElement
[[Return to contents]](#Contents)

## tag
[[Return to contents]](#Contents)

## payload
[[Return to contents]](#Contents)

## Enumerated
[[Return to contents]](#Contents)

## tag
[[Return to contents]](#Contents)

## payload
[[Return to contents]](#Contents)

## FieldOptions
[[Return to contents]](#Contents)

## install_default
[[Return to contents]](#Contents)

## GeneralString
[[Return to contents]](#Contents)

## tag
[[Return to contents]](#Contents)

## payload
[[Return to contents]](#Contents)

## GeneralizedTime
[[Return to contents]](#Contents)

## into_utctime
[[Return to contents]](#Contents)

## tag
[[Return to contents]](#Contents)

## payload
[[Return to contents]](#Contents)

## IA5String
[[Return to contents]](#Contents)

## tag
[[Return to contents]](#Contents)

## payload
[[Return to contents]](#Contents)

## Integer
[[Return to contents]](#Contents)

## hex
[[Return to contents]](#Contents)

## tag
[[Return to contents]](#Contents)

## payload
[[Return to contents]](#Contents)

## equal
[[Return to contents]](#Contents)

## as_bigint
[[Return to contents]](#Contents)

## as_i64
[[Return to contents]](#Contents)

## Null
[[Return to contents]](#Contents)

## tag
[[Return to contents]](#Contents)

## payload
[[Return to contents]](#Contents)

## NumericString
[[Return to contents]](#Contents)

## tag
[[Return to contents]](#Contents)

## payload
[[Return to contents]](#Contents)

## ObjectIdentifier
[[Return to contents]](#Contents)

## value
[[Return to contents]](#Contents)

## tag
[[Return to contents]](#Contents)

## payload
[[Return to contents]](#Contents)

## equal
[[Return to contents]](#Contents)

## OctetString
[[Return to contents]](#Contents)

## tag
[[Return to contents]](#Contents)

## payload
[[Return to contents]](#Contents)

## Optional
[[Return to contents]](#Contents)

## set_present_bit
[[Return to contents]](#Contents)

## tag
[[Return to contents]](#Contents)

## payload
[[Return to contents]](#Contents)

## encode
[[Return to contents]](#Contents)

## into_element
[[Return to contents]](#Contents)

## into_object
[[Return to contents]](#Contents)

## Parser
[[Return to contents]](#Contents)

## reset
[[Return to contents]](#Contents)

## peek_tag
[[Return to contents]](#Contents)

## read_tag
[[Return to contents]](#Contents)

## read_length
[[Return to contents]](#Contents)

## read_bytes
[[Return to contents]](#Contents)

## read_tlv
[[Return to contents]](#Contents)

## finish
[[Return to contents]](#Contents)

## is_empty
[[Return to contents]](#Contents)

## PrintableString
[[Return to contents]](#Contents)

## tag
[[Return to contents]](#Contents)

## payload
[[Return to contents]](#Contents)

## PrivateELement
[[Return to contents]](#Contents)

## tag
[[Return to contents]](#Contents)

## payload
[[Return to contents]](#Contents)

## RawElement
[[Return to contents]](#Contents)

## tag
[[Return to contents]](#Contents)

## payload
[[Return to contents]](#Contents)

## set_mode
[[Return to contents]](#Contents)

## set_inner_tag
[[Return to contents]](#Contents)

## inner_tag
[[Return to contents]](#Contents)

## inner_element
[[Return to contents]](#Contents)

## Sequence
[[Return to contents]](#Contents)

## tag
[[Return to contents]](#Contents)

## payload
[[Return to contents]](#Contents)

## encoded_len
[[Return to contents]](#Contents)

## fields
[[Return to contents]](#Contents)

## set_size
[[Return to contents]](#Contents)

## add_element
[[Return to contents]](#Contents)

## is_sequence_of
[[Return to contents]](#Contents)

## into_sequence_of
[[Return to contents]](#Contents)

## SequenceOf
[[Return to contents]](#Contents)

## Set
[[Return to contents]](#Contents)

## tag
[[Return to contents]](#Contents)

## payload
[[Return to contents]](#Contents)

## fields
[[Return to contents]](#Contents)

## add_element
[[Return to contents]](#Contents)

## set_size
[[Return to contents]](#Contents)

## SetOf
[[Return to contents]](#Contents)

## Tag
[[Return to contents]](#Contents)

## tag_class
[[Return to contents]](#Contents)

## is_constructed
[[Return to contents]](#Contents)

## tag_number
[[Return to contents]](#Contents)

## encode
[[Return to contents]](#Contents)

## equal
[[Return to contents]](#Contents)

## tag_size
[[Return to contents]](#Contents)

## universal_tag_type
[[Return to contents]](#Contents)

## UtcTime
[[Return to contents]](#Contents)

## tag
[[Return to contents]](#Contents)

## payload
[[Return to contents]](#Contents)

## into_utctime
[[Return to contents]](#Contents)

## Utf8String
[[Return to contents]](#Contents)

## tag
[[Return to contents]](#Contents)

## payload
[[Return to contents]](#Contents)

## VisibleString
[[Return to contents]](#Contents)

## tag
[[Return to contents]](#Contents)

## payload
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:56
