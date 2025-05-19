module siteconfig
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.core.redisclient
import json

@[params]
pub struct SiteConfigArgsGet {
pub mut:
	name          string
	path 		string
}

// new creates a new siteconfig and stores it in redis, or gets an existing one
pub fn new(args_ SiteConfigArgsGet) !&SiteConfig {
	mut args := args_
	mut redis := redisclient.core_get()!

	if args.path != '' {
		if args.name != '' {
			return error('can not set name and path at the same time')
		}
		mut plbook := playbook.new(path: args.path)!
		mut config := SiteConfig{} // Create a new SiteConfig to be populated by play
		play(plbook:plbook, mut config)! // Pass the config by mutable reference
		set(config)! // Save the populated config to Redis
		args.name = config.name // Use the name from the played config
	}

	args.name = texttools.name_fix(args.name)
	if args.name == '' {
		// Get the current siteconfig name from Redis set
		current_configs := redis.smembers('siteconfigs:current')!
		if current_configs.len == 0 {
			return error('no current siteconfig found in redis')
		}
		args.name = current_configs[0] // Use the first one as current
	}

	mut sc := get(args.name)!
	return sc
}

// get gets siteconfig from redis
pub fn get(name string) !&SiteConfig {
	mut redis := redisclient.core_get()!
	json_config := redis.hget('siteconfigs', name)!
	if json_config == '' {
		return error('SiteConfig ${name} not found in redis')
	}
	mut sc := json.decode(SiteConfig, json_config)!
	return &sc
}

// set stores siteconfig in redis
pub fn set(siteconfig SiteConfig) ! {
	mut redis := redisclient.core_get()!
	json_config := json.encode(siteconfig)! // Added error handling for json.encode
	redis.hset('siteconfigs', siteconfig.name, json_config)!
	redis.sadd('siteconfigs:current', siteconfig.name)!
}
