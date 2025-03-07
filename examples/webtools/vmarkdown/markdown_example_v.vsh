#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

// import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.ui.console
import log
import os
import markdown
import mlib

path2:="${os.home_dir()}/code/github/freeflowuniverse/herolib/examples/webtools/mdbook_markdown/content/links.md"
path1:="${os.home_dir()}/code/github/freeflowuniverse/herolib/examples/webtools/mdbook_markdown/content/test.md"

text := os.read_file(path1)!

// Example 1: Using the built-in plaintext renderer
println('=== PLAINTEXT RENDERING ===')
println(markdown.to_plain(text))
println('')

// Example 2: Using our custom structure renderer to show markdown structure
println('=== STRUCTURE RENDERING ===')
println(mlib.to_structure(text))

// // Example 3: Using a simple markdown example to demonstrate structure
// println('\n=== STRUCTURE OF A SIMPLE MARKDOWN EXAMPLE ===')
// simple_md := '# Heading 1\n\nThis is a paragraph with **bold** and *italic* text.\n\n- List item 1\n- List item 2\n\n```v\nfn main() {\n\tprintln("Hello, world!")\n}\n```\n\n[Link to V language](https://vlang.io)'
// println(markdown.to_structure(simple_md))
