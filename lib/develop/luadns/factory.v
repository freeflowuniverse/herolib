module luadns

import freeflowuniverse.herolib.develop.gittools

struct LuaDNS {
pub mut:
	url     string
	configs []DNSConfig
}

// returns the path of the fetched repo
pub fn load(url string) !LuaDNS {
	mut gs := gittools.new()!
	mut repo := gs.get_repo(
		url:  url
		pull: true
	)!

	repo_path := repo.path()

	return LuaDNS{
		url:     url
		configs: parse_dns_configs(repo_path)!
	}
}
