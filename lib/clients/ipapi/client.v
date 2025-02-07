module ipapi

import json

pub struct IPInfo {
pub:
	query        string
	status       string
	country      string
	country_code string @[json: 'countryCode']
	region       string
	region_name  string @[json: 'regionName']
	city         string
	zip          string
	lat          f32
	lon          f32
	timezone     string
	isp          string
	org          string
	as           string
}

pub fn (mut a IPApi) get_ip_info(ip string) !IPInfo {
	mut conn := a.connection()!
	res := conn.get_json(prefix: 'json/${ip}')!
	info := json.decode(IPInfo, res)!

	return info
}
