#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.clients.vastai
import json
import x.json2

// Create client with direct API key
// This uses VASTAI_API_KEY from environment
mut va := vastai.get()!

offers := va.search_offers()!
println('offers: ${offers}')

top_offers := va.get_top_offers(5)!
println('top offers: ${top_offers}')

create_instance_res := va.create_instance(
	id:     top_offers[0].id
	config: vastai.CreateInstanceConfig{
		image: 'pytorch/pytorch:2.5.1-cuda12.4-cudnn9-runtime'
		disk:  10
	}
)!
println('create instance res: ${create_instance_res}')
