module siteconfig
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.core.base
import json

// new creates a new siteconfig and stores it in redis, or gets an existing one
pub fn new(path string) !&SiteConfig {
	mut context := base.context()!
	mut redis := context.redis()!
	if path == '' {
		return error('path is empty')
	}
	mut plbook := playbook.new(path: path)!
	play(plbook: plbook)! // Pass the config by mutable reference

	current_config_name := redis.get('siteconfigs:current')!
	if current_config_name == '' {
		return error('no current siteconfig found in redis')
	}
	mut sc := get(current_config_name)!
	return sc
}

// get gets siteconfig from redis
pub fn get(name_ string) !&SiteConfig {
	name := texttools.name_fix(name_)
	mut context := base.context()!
	mut redis := context.redis()!	json_config := redis.hget('siteconfigs', name)!
	if json_config == '' {
		return error('SiteConfig ${name} not found in redis')
	}
	mut sc := json.decode(SiteConfig, json_config)!
	return &sc
}

