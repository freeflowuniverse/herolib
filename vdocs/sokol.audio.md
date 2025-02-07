# module sokol.audio


## Contents
- [buffer_frames](#buffer_frames)
- [channels](#channels)
- [expect](#expect)
- [fclamp](#fclamp)
- [is_valid](#is_valid)
- [max](#max)
- [min](#min)
- [push](#push)
- [query](#query)
- [sample_rate](#sample_rate)
- [setup](#setup)
- [shutdown](#shutdown)
- [suspended](#suspended)
- [user_data](#user_data)
- [FNStreamingCB](#FNStreamingCB)
  - [str](#str)
- [FnStreamingCBWithUserData](#FnStreamingCBWithUserData)
  - [str](#str)
- [C.saudio_allocator](#C.saudio_allocator)
- [C.saudio_desc](#C.saudio_desc)
- [C.saudio_logger](#C.saudio_logger)

## buffer_frames
[[Return to contents]](#Contents)

## channels
[[Return to contents]](#Contents)

## expect
[[Return to contents]](#Contents)

## fclamp
Example
```v

realsample := audio.fclamp(sample, -1.0, 1.0)

```

[[Return to contents]](#Contents)

## is_valid
[[Return to contents]](#Contents)

## max
Example
```v

larger := audio.max(1, 5) // larger == 5

```

[[Return to contents]](#Contents)

## min
Example
```v

smaller := audio.min(1, 5) // smaller == 1

```

[[Return to contents]](#Contents)

## push
[[Return to contents]](#Contents)

## query
[[Return to contents]](#Contents)

## sample_rate
[[Return to contents]](#Contents)

## setup
[[Return to contents]](#Contents)

## shutdown
[[Return to contents]](#Contents)

## suspended
[[Return to contents]](#Contents)

## user_data
[[Return to contents]](#Contents)

## FNStreamingCB
Examples
```v

unsafe { C.memcpy(buffer, &samples, samples.len * int(sizeof(f32))) }

unsafe { mut b := buffer; for i, sample in samples { b[i] = sample } }

```

[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## FnStreamingCBWithUserData
Examples
```v

mut soundbuffer := []f32

soundbuffer << previously_parsed_wavfile_bytes

audio.setup(stream_userdata_cb: mycallback, user_data: soundbuffer)

fn mycallback(buffer &f32, num_frames int, num_channels int, mut sb []f32) { ... }

```

[[Return to contents]](#Contents)

## str
[[Return to contents]](#Contents)

## C.saudio_allocator
[[Return to contents]](#Contents)

## C.saudio_desc
[[Return to contents]](#Contents)

## C.saudio_logger
[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 7 Feb 2025 12:06:55
