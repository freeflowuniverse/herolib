module location

import db.pg

// // search searches for locations based on the provided options
// pub fn (l Location) search(query string, country_code string, limit int, fuzzy bool) ![]SearchResult {
// 	opts := SearchOptions{
// 		query: query
// 		country_code: country_code
// 		limit: limit
// 		fuzzy: fuzzy
// 	}
// 	return l.db.search_locations(opts)
// }

// // search_near searches for locations near the given coordinates
// pub fn (l Location) search_near(lat f64, lon f64, radius f64, limit int) ![]SearchResult {
// 	opts := CoordinateSearchOptions{
// 		coordinates: Coordinates{
// 			latitude: lat
// 			longitude: lon
// 		}
// 		radius: radius
// 		limit: limit
// 	}
// 	return l.db.search_by_coordinates(opts)
// }

// // search_locations searches for locations based on the provided options
// pub fn (l LocationDB) search_locations(opts SearchOptions) ![]SearchResult {
// 	mut query_conditions := []string{}
// 	mut params := []string{}

// 	if opts.query != '' {
// 		if opts.fuzzy {
// 			query_conditions << '(c.name ILIKE $${params.len + 1} OR c.ascii_name ILIKE $${params.len + 2})'
// 			params << '%${opts.query}%'
// 			params << '%${opts.query}%'
// 		} else {
// 			query_conditions << '(c.name = $${params.len + 1} OR c.ascii_name = $${params.len + 2})'
// 			params << opts.query
// 			params << opts.query
// 		}
// 	}

// 	if opts.country_code != '' {
// 		query_conditions << 'c.country_iso2 = $${params.len + 1}'
// 		params << opts.country_code
// 	}

// 	where_clause := if query_conditions.len > 0 { 'WHERE ' + query_conditions.join(' AND ') } else { '' }

// 	query := '
// 		SELECT c.*, co.* 
// 		FROM City c
// 		JOIN Country co ON c.country_iso2 = co.iso2
// 		${where_clause}
// 		ORDER BY c.search_priority DESC, c.population DESC 
// 		LIMIT ${opts.limit}
// 	'

// 	rows := l.db.exec_param_many(query, params)!
// 	mut results := []SearchResult{cap: rows.len}

// 	for row in rows {
// 		city := City{
// 			id: row.vals[0].int() or { 0 }
// 			name: row.vals[1] or { '' }
// 			ascii_name: row.vals[2] or { '' }
// 			country_iso2: row.vals[3] or { '' }
// 			postal_code: row.vals[4] or { '' }
// 			state_name: row.vals[5] or { '' }
// 			state_code: row.vals[6] or { '' }
// 			county_name: row.vals[7] or { '' }
// 			county_code: row.vals[8] or { '' }
// 			community_name: row.vals[9] or { '' }
// 			community_code: row.vals[10] or { '' }
// 			latitude: row.vals[11].f64() or { 0.0 }
// 			longitude: row.vals[12].f64() or { 0.0 }
// 			population: row.vals[13].i64() or { 0 }
// 			timezone: row.vals[14] or { '' }
// 			feature_class: row.vals[15] or { '' }
// 			feature_code: row.vals[16] or { '' }
// 			search_priority: row.vals[17].int() or { 0 }
// 			accuracy: u8(row.vals[18].int() or { 1 })
// 		}

// 		country := Country{
// 			iso2: row.vals[19] or { '' }
// 			name: row.vals[20] or { '' }
// 			iso3: row.vals[21] or { '' }
// 			continent: row.vals[22] or { '' }
// 			population: row.vals[23].i64() or { 0 }
// 			timezone: row.vals[24] or { '' }
// 			import_date: row.vals[25].i64() or { 0 }
// 		}

// 		results << SearchResult{
// 			city: city
// 			country: country
// 			similarity: 1.0 // TODO: implement proper similarity scoring
// 		}
// 	}

// 	return results
// }

// // search_by_coordinates finds locations near the given coordinates
// pub fn (l LocationDB) search_by_coordinates(opts CoordinateSearchOptions) ![]SearchResult {
// 	// Use the Haversine formula to calculate distances
// 	query := "
// 		WITH distances AS (
// 			SELECT c.*, co.*,
// 			(6371 * acos(cos(radians($1)) * cos(radians(latitude)) * 
// 			cos(radians(longitude) - radians($2)) + sin(radians($1)) * 
// 			sin(radians(latitude)))) AS distance
// 			FROM City c
// 			JOIN Country co ON c.country_iso2 = co.iso2
// 		)
// 		SELECT * FROM distances
// 		WHERE distance < $3
// 		ORDER BY distance
// 		LIMIT $4
// 	"
	
// 	params := [
// 		opts.coordinates.latitude.str(),
// 		opts.coordinates.longitude.str(),
// 		opts.radius.str(),
// 		opts.limit.str()
// 	]
// 	rows := l.db.exec_param_many(query, params)!

// 	mut results := []SearchResult{cap: rows.len}

// 	for row in rows {
// 		city := City{
// 			id: row.vals[0].int() or { 0 }
// 			name: row.vals[1] or { '' }
// 			ascii_name: row.vals[2] or { '' }
// 			country_iso2: row.vals[3] or { '' }
// 			postal_code: row.vals[4] or { '' }
// 			state_name: row.vals[5] or { '' }
// 			state_code: row.vals[6] or { '' }
// 			county_name: row.vals[7] or { '' }
// 			county_code: row.vals[8] or { '' }
// 			community_name: row.vals[9] or { '' }
// 			community_code: row.vals[10] or { '' }
// 			latitude: row.vals[11].f64() or { 0.0 }
// 			longitude: row.vals[12].f64() or { 0.0 }
// 			population: row.vals[13].i64() or { 0 }
// 			timezone: row.vals[14] or { '' }
// 			feature_class: row.vals[15] or { '' }
// 			feature_code: row.vals[16] or { '' }
// 			search_priority: row.vals[17].int() or { 0 }
// 			accuracy: u8(row.vals[18].int() or { 1 })
// 		}

// 		country := Country{
// 			iso2: row.vals[19] or { '' }
// 			name: row.vals[20] or { '' }
// 			iso3: row.vals[21] or { '' }
// 			continent: row.vals[22] or { '' }
// 			population: row.vals[23].i64() or { 0 }
// 			timezone: row.vals[24] or { '' }
// 			import_date: row.vals[25].i64() or { 0 }
// 		}

// 		results << SearchResult{
// 			city: city
// 			country: country
// 			similarity: 1.0
// 		}
// 	}

// 	return results
// }
