module countries

import os
import strings

// --- Embed the data file content at compile time ---
// The path is relative to the location of this `module.v` file.
const embedded_country_data = $embed_file('data/countryInfo.txt')

// get_all_countries parses the country data embedded in the executable.
// It returns a list of Country structs.
pub fn get_all_countries() ![]Country {
	mut countries_list := []Country{}

	// --- Parse the embedded string ---
	lines := embedded_country_data.split_into_lines()
	mut found_header := false

	for line in lines {
		// --- Skip empty lines and comments ---
		if line == '' || line.trim_space().starts_with('#') {
			continue
		}

		// --- Identify and skip the header ---
		// Check if this line looks like the header (contains key identifiers)
		if !found_header && line.contains('ISO') && line.contains('Country') && line.contains('CurrencyCode') {
			found_header = true
			continue // Skip the header line itself
		}

		// --- Process data lines ---
		// Split the line by tab character
		fields := line.split('\t')

		// Ensure we have the expected number of fields (header indicates 19)
		if fields.len < 19 {
			// Handle potential parsing errors or incomplete lines
			// println('Warning: Skipping line with insufficient fields (found ${fields.len}): "${line}"')
			continue
		}

		// --- Create Country struct instance ---
		// Map fields by index based on the header structure
		country := Country{
			iso:             fields[0].trim_space()
			iso3:            fields[1].trim_space()
			iso_numeric:     fields[2].trim_space()
			fips:            fields[3].trim_space()
			country_name:    fields[4].trim_space()
			capital:         fields[5].trim_space()
			area_sqkm:       fields[6].trim_space()
			population:      fields[7].trim_space()
			continent:       fields[8].trim_space()
			tld:             fields[9].trim_space()
			currency_code:   fields[10].trim_space()
			currency_name:   fields[11].trim_space()
			phone:           fields[12].trim_space()
			postal_format:   fields[13].trim_space()
			postal_regex:    fields[14].trim_space()
			languages:       fields[15].trim_space()
			geonameid:       fields[16].trim_space()
			neighbours:      fields[17].trim_space()
			equiv_fips_code: fields[18].trim_space() // Handle potential trailing empty fields or newlines
		}

		// --- Append to list ---
		countries_list << country
	}

	return countries_list
}
