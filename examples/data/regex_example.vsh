#!/usr/bin/env -S v -n -w -gc none -cg  -cc tcc -d use_openssl -enable-globals run

fn extract_image_markdown(s string) !(string, string) {
    start := s.index('![') or { return error('Missing ![') }
    alt_start := start + 2
    alt_end := s.index_after(']', alt_start) or { return error('Missing ]') }
    if s.len <= alt_end + 1 || s[alt_end + 1] != `(` {
        return error('Missing opening ( after ]')
    }
    url_start := alt_end + 2
    url_end := s.index_after(')', url_start) or { return error('Missing closing )') }

    alt := s[alt_start..alt_end]
    url := s[url_start..url_end]
    return alt, url
}

fn main() {
    text := 'Here is an image: ![Alt](http://example.com/image.png) and another ![Logo](https://site.org/logo.svg)'

    mut i := 0
    for {
        if i >= text.len { break }
        if text[i..].contains('![') {
            snippet := text[i..]
            alt, url := extract_image_markdown(snippet) or {
                break
            }
            println('Alt: "$alt" | URL: "$url"')
            i += snippet.index_after(')', 0) or { break } + 1
        } else {
            break
        }
    }
}
