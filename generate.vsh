#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.code.generator.generic

mut fp := flag.new_flag_parser(os.args)
fp.application('generate.vsh')
fp.version('v0.1.0')
fp.description('Generate code')
fp.skip_executable()

path := fp.string('path', `p`, "", 'Path where to generate a module, if not mentioned will scan over all installers & clients')
reset := fp.bool('reset', `r`, false, 'If we want to reset')
is_installer := fp.bool('installer', `i`, false, 'If we want an installer, otherwise will be client')
help_requested := fp.bool('help', `h`, false, 'Show help message')

if help_requested {
    println(fp.usage())
    exit(0)
}

additional_args := fp.finalize() or {
    eprintln(err)
    println(fp.usage())
    exit(1)
}

if additional_args.len > 0 {
    eprintln('Unexpected arguments: ${additional_args.join(' ')}')
    println(fp.usage())
    exit(1)
}


if path!=""{
	//TODO: create path
}

generic.scan(path:"~/code/github/freeflowuniverse/herolib/lib/installers",force:true, add:true)!
