#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

// import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.ui.console
import log
import os
import markdown
import freeflowuniverse.herolib.data.markdownparser2

path1 := '${os.home_dir()}/code/github/freeflowuniverse/herolib/examples/web/mdbook_markdown/content/cybercity.md'

text := os.read_file(path1)!

// Example 1: Using the built-in plaintext renderer
println('=== PLAINTEXT RENDERING ===')
println(markdown.to_plain(text))
println('')
