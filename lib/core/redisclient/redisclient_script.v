module redisclient

// load a script and return the hash
pub fn (mut r Redis) script_load(script string) !string {
	return r.send_expect_str(['SCRIPT LOAD', script])!
}
