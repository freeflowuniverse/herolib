module location

import db.sqlite
import os
import encoding.csv
import freeflowuniverse.herolib.osal

const (
	db_file = os.join_path(os.cache_dir(), 'location.db')
	geonames_url = 'https://download.geonames.org/export/dump'
	cities_url = '${geonames_url}/cities500.zip'
)

// LocationDB handles all database operations for locations
pub struct LocationDB {
mut:
	db sqlite.DB
}

// new_location_db creates a new LocationDB instance
pub fn new_location_db() !LocationDB {
	db := sqlite.connect(db_file)!
	mut loc_db := LocationDB{
		db: db
	}
	loc_db.init_tables()!
	return loc_db
}

// init_tables creates the necessary database tables if they don't exist
fn (mut l LocationDB) init_tables() ! {
	l.db.exec('
		CREATE TABLE IF NOT EXISTS countries (
			id INTEGER PRIMARY KEY,
			name TEXT NOT NULL,
			iso2 TEXT NOT NULL,
			iso3 TEXT NOT NULL,
			continent TEXT,
			population INTEGER,
			timezone TEXT,
			UNIQUE(iso2),
			UNIQUE(iso3)
		)
	')!

	l.db.exec('
		CREATE TABLE IF NOT EXISTS cities (
			id INTEGER PRIMARY KEY,
			name TEXT NOT NULL,
			ascii_name TEXT NOT NULL,
			country_id INTEGER NOT NULL,
			admin1_code TEXT,
			latitude REAL,
			longitude REAL,
			population INTEGER,
			timezone TEXT,
			feature_class TEXT,
			feature_code TEXT,
			search_priority INTEGER DEFAULT 0,
			FOREIGN KEY(country_id) REFERENCES countries(id)
		)
	')!

	l.db.exec('
		CREATE TABLE IF NOT EXISTS alternate_names (
			id INTEGER PRIMARY KEY,
			city_id INTEGER NOT NULL,
			name TEXT NOT NULL,
			language_code TEXT,
			is_preferred INTEGER,
			is_short INTEGER,
			FOREIGN KEY(city_id) REFERENCES cities(id)
		)
	')!

	// Create indexes for better search performance
	l.db.exec('CREATE INDEX IF NOT EXISTS idx_city_name ON cities(name)')!
	l.db.exec('CREATE INDEX IF NOT EXISTS idx_city_ascii ON cities(ascii_name)')!
	l.db.exec('CREATE INDEX IF NOT EXISTS idx_city_coords ON cities(latitude, longitude)')!
	l.db.exec('CREATE INDEX IF NOT EXISTS idx_alt_name ON alternate_names(name)')!
}

// download_and_import_data downloads and imports GeoNames data
pub fn (mut l LocationDB) download_and_import_data() ! {
	// Download country info
	country_file := osal.download(
		url: '${geonames_url}/countryInfo.txt'
		dest: os.join_path(os.cache_dir(), 'countryInfo.txt')
	)!
	country_data := os.read_file(country_file.path)!
	l.import_country_data(country_data)!

	// Download and process cities
	cities_file := osal.download(
		url: cities_url
		dest: os.join_path(os.cache_dir(), 'cities500.zip')
		expand_file: os.join_path(os.cache_dir(), 'cities500.txt')
	)!
	cities_data := os.read_file(cities_file.path)!
	l.import_city_data(cities_data)!
}

// import_country_data imports country information
fn (mut l LocationDB) import_country_data(data string) ! {
	mut tx := l.db.begin()!
	
	for line in data.split_into_lines() {
		if line.starts_with('#') {
			continue
		}
		fields := line.split('\t')
		if fields.len < 5 {
			continue
		}

		tx.exec('
			INSERT OR REPLACE INTO countries (
				iso2, iso3, name, continent, population, timezone
			) VALUES (?, ?, ?, ?, ?, ?)
		', [
			fields[0], // iso2
			fields[1], // iso3
			fields[4], // name
			fields[8], // continent
			fields[7].i64(), // population
			fields[17] // timezone
		])!
	}
	
	tx.commit()!
}

// import_city_data imports city information
fn (mut l LocationDB) import_city_data(data string) ! {
	mut tx := l.db.begin()!
	
	for line in data.split_into_lines() {
		fields := line.split('\t')
		if fields.len < 15 {
			continue
		}

		// Get country_id from iso2 code
		country_id := l.get_country_id_by_iso2(fields[8]) or { continue }

		tx.exec('
			INSERT OR REPLACE INTO cities (
				id, name, ascii_name, country_id, admin1_code,
				latitude, longitude, population, feature_class,
				feature_code, timezone
			) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
		', [
			fields[0].int(), // id
			fields[1], // name
			fields[2], // ascii_name
			country_id,
			fields[10], // admin1_code
			fields[4].f64(), // latitude
			fields[5].f64(), // longitude
			fields[14].i64(), // population
			fields[6], // feature_class
			fields[7], // feature_code
			fields[17] // timezone
		])!
	}
	
	tx.commit()!
}

// get_country_id_by_iso2 retrieves a country's ID using its ISO2 code
fn (l LocationDB) get_country_id_by_iso2(iso2 string) !int {
	row := l.db.query('SELECT id FROM countries WHERE iso2 = ?', [iso2])!
	return row.vals[0].int()
}

// search_locations searches for locations based on the provided options
pub fn (l LocationDB) search_locations(opts SearchOptions) ![]SearchResult {
	mut query := '
		SELECT c.*, co.* 
		FROM cities c
		JOIN countries co ON c.country_id = co.id
		WHERE 1=1
	'
	mut params := []string{}

	if opts.query != '' {
		if opts.fuzzy {
			query += ' AND (c.name LIKE ? OR c.ascii_name LIKE ?)'
			params << '%${opts.query}%'
			params << '%${opts.query}%'
		} else {
			query += ' AND (c.name = ? OR c.ascii_name = ?)'
			params << opts.query
			params << opts.query
		}
	}

	if opts.country_code != '' {
		query += ' AND co.iso2 = ?'
		params << opts.country_code
	}

	query += ' ORDER BY c.search_priority DESC, c.population DESC LIMIT ?'
	params << opts.limit.str()

	rows := l.db.query(query, params)!
	mut results := []SearchResult{cap: rows.len}

	for row in rows {
		city := City{
			id: row.vals[0].int()
			name: row.vals[1]
			ascii_name: row.vals[2]
			country_id: row.vals[3].int()
			admin1_code: row.vals[4]
			latitude: row.vals[5].f64()
			longitude: row.vals[6].f64()
			population: row.vals[7].i64()
			timezone: row.vals[8]
			feature_class: row.vals[9]
			feature_code: row.vals[10]
			search_priority: row.vals[11].int()
		}

		country := Country{
			id: row.vals[12].int()
			name: row.vals[13]
			iso2: row.vals[14]
			iso3: row.vals[15]
			continent: row.vals[16]
			population: row.vals[17].i64()
			timezone: row.vals[18]
		}

		results << SearchResult{
			city: city
			country: country
			similarity: 1.0 // TODO: implement proper similarity scoring
		}
	}

	return results
}

// search_by_coordinates finds locations near the given coordinates
pub fn (l LocationDB) search_by_coordinates(opts CoordinateSearchOptions) ![]SearchResult {
	// Use the Haversine formula to calculate distances
	query := "
		SELECT c.*, co.*,
		(6371 * acos(cos(radians(?)) * cos(radians(latitude)) * 
		cos(radians(longitude) - radians(?)) + sin(radians(?)) * 
		sin(radians(latitude)))) AS distance
		FROM cities c
		JOIN countries co ON c.country_id = co.id
		HAVING distance < ?
		ORDER BY distance
		LIMIT ?
	"
	
	rows := l.db.query(query, [
		opts.coordinates.latitude.str(),
		opts.coordinates.longitude.str(),
		opts.coordinates.latitude.str(),
		opts.radius.str(),
		opts.limit.str()
	])!

	mut results := []SearchResult{cap: rows.len}

	for row in rows {
		city := City{
			id: row.vals[0].int()
			name: row.vals[1]
			ascii_name: row.vals[2]
			country_id: row.vals[3].int()
			admin1_code: row.vals[4]
			latitude: row.vals[5].f64()
			longitude: row.vals[6].f64()
			population: row.vals[7].i64()
			timezone: row.vals[8]
			feature_class: row.vals[9]
			feature_code: row.vals[10]
			search_priority: row.vals[11].int()
		}

		country := Country{
			id: row.vals[12].int()
			name: row.vals[13]
			iso2: row.vals[14]
			iso3: row.vals[15]
			continent: row.vals[16]
			population: row.vals[17].i64()
			timezone: row.vals[18]
		}

		results << SearchResult{
			city: city
			country: country
			similarity: 1.0
		}
	}

	return results
}

// close closes the database connection
pub fn (mut l LocationDB) close() {
	l.db.close()
}
