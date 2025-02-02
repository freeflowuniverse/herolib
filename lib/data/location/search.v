module location

import db.sqlite


// search searches for locations based on the provided options
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
// 			query_conditions << '(c.name LIKE ? OR c.ascii_name LIKE ?)'
// 			params << '%${opts.query}%'
// 			params << '%${opts.query}%'
// 		} else {
// 			query_conditions << '(c.name = ? OR c.ascii_name = ?)'
// 			params << opts.query
// 			params << opts.query
// 		}
// 	}

// 	if opts.country_code != '' {
// 		query_conditions << 'co.iso2 = ?'
// 		params << opts.country_code
// 	}

// 	where_clause := if query_conditions.len > 0 { 'WHERE ' + query_conditions.join(' AND ') } else { '' }

// 	query := '
// 		SELECT c.*, co.* 
// 		FROM City c
// 		JOIN Country co ON c.country_id = co.id
// 		${where_clause}
// 		ORDER BY c.search_priority DESC, c.population DESC 
// 		LIMIT ${opts.limit}
// 	'

// 	query_with_params := sql l.db {
// 		raw(query, params)
// 	}!
// 	rows := l.db.exec(query_with_params)!
// 	mut results := []SearchResult{cap: rows.len}

// 	for row in rows {
// 		city := City{
// 			id: row.vals[0].int()
// 			name: row.vals[1]
// 			ascii_name: row.vals[2]
// 			country_id: row.vals[3].int()
// 			admin1_code: row.vals[4]
// 			latitude: row.vals[5].f64()
// 			longitude: row.vals[6].f64()
// 			population: row.vals[7].i64()
// 			timezone: row.vals[8]
// 			feature_class: row.vals[9]
// 			feature_code: row.vals[10]
// 			search_priority: row.vals[11].int()
// 		}

// 		country := Country{
// 			id: row.vals[12].int()
// 			name: row.vals[13]
// 			iso2: row.vals[14]
// 			iso3: row.vals[15]
// 			continent: row.vals[16]
// 			population: row.vals[17].i64()
// 			timezone: row.vals[18]
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
// 		SELECT c.*, co.*,
// 		(6371 * acos(cos(radians(?)) * cos(radians(latitude)) * 
// 		cos(radians(longitude) - radians(?)) + sin(radians(?)) * 
// 		sin(radians(latitude)))) AS distance
// 		FROM City c
// 		JOIN Country co ON c.country_id = co.id
// 		HAVING distance < ?
// 		ORDER BY distance
// 		LIMIT ?
// 	"
	
// 	params := [
// 		opts.coordinates.latitude.str(),
// 		opts.coordinates.longitude.str(),
// 		opts.coordinates.latitude.str(),
// 		opts.radius.str(),
// 		opts.limit.str()
// 	]
// 	query_with_params := sql l.db {
// 		raw(query, params)
// 	}!
// 	rows := l.db.exec(query_with_params)!

// 	mut results := []SearchResult{cap: rows.len}

// 	for row in rows {
// 		city := City{
// 			id: row.vals[0].int()
// 			name: row.vals[1]
// 			ascii_name: row.vals[2]
// 			country_id: row.vals[3].int()
// 			admin1_code: row.vals[4]
// 			latitude: row.vals[5].f64()
// 			longitude: row.vals[6].f64()
// 			population: row.vals[7].i64()
// 			timezone: row.vals[8]
// 			feature_class: row.vals[9]
// 			feature_code: row.vals[10]
// 			search_priority: row.vals[11].int()
// 		}

// 		country := Country{
// 			id: row.vals[12].int()
// 			name: row.vals[13]
// 			iso2: row.vals[14]
// 			iso3: row.vals[15]
// 			continent: row.vals[16]
// 			population: row.vals[17].i64()
// 			timezone: row.vals[18]
// 		}

// 		results << SearchResult{
// 			city: city
// 			country: country
// 			similarity: 1.0
// 		}
// 	}

// 	return results
// }
