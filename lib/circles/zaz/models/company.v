module models

import freeflowuniverse.herolib.data.ourtime
import freeflowuniverse.herolib.data.encoder

// CompanyStatus represents the status of a company
pub enum CompanyStatus {
	active
	inactive
	suspended
}

// BusinessType represents the type of a business
pub enum BusinessType {
	coop
	single
	twin
	starter
	global
}

// Company represents a company registered in the Freezone
pub struct Company {
pub mut:
	id                 u32
	name               string
	registration_number string
	incorporation_date  ourtime.OurTime
	fiscal_year_end     string
	email               string
	phone               string
	website             string
	address             string
	business_type       BusinessType
	industry            string
	description         string
	status              CompanyStatus
	created_at          ourtime.OurTime
	updated_at          ourtime.OurTime
	shareholders        []Shareholder
}

// dumps serializes the Company to a byte array
pub fn (company Company) dumps() ![]u8 {
	mut enc := encoder.new()

	// Add unique encoding ID to identify this type of data
	enc.add_u16(402) // Unique ID for Company type

	// Encode Company fields
	enc.add_u32(company.id)
	enc.add_string(company.name)
	enc.add_string(company.registration_number)
	enc.add_string(company.incorporation_date.str())
	enc.add_string(company.fiscal_year_end)
	enc.add_string(company.email)
	enc.add_string(company.phone)
	enc.add_string(company.website)
	enc.add_string(company.address)
	enc.add_u8(u8(company.business_type))
	enc.add_string(company.industry)
	enc.add_string(company.description)
	enc.add_u8(u8(company.status))
	enc.add_string(company.created_at.str())
	enc.add_string(company.updated_at.str())

	// Encode shareholders array
	enc.add_u16(u16(company.shareholders.len))
	for shareholder in company.shareholders {
		// Encode each shareholder's fields
	enc.add_u32(shareholder.id)
	enc.add_u32(shareholder.company_id)
	enc.add_u32(shareholder.user_id)
		enc.add_string(shareholder.name)
		enc.add_int(shareholder.shares)
		enc.add_string(shareholder.percentage.str()) // Store as string to preserve precision
		enc.add_u8(u8(shareholder.type_))
		enc.add_string(shareholder.since.str())
		enc.add_string(shareholder.created_at.str())
		enc.add_string(shareholder.updated_at.str())
	}

	return enc.data
}

// loads deserializes a byte array to a Company
pub fn company_loads(data []u8) !Company {
	mut d := encoder.decoder_new(data)
	mut company := Company{}

	// Check encoding ID to verify this is the correct type of data
	encoding_id := d.get_u16()!
	if encoding_id != 402 {
		return error('Wrong file type: expected encoding ID 402, got ${encoding_id}, for company')
	}

	// Decode Company fields
	company.id = d.get_u32()!
	company.name = d.get_string()!
	company.registration_number = d.get_string()!
	
	incorporation_date_str := d.get_string()!
	company.incorporation_date = ourtime.new(incorporation_date_str)!
	
	company.fiscal_year_end = d.get_string()!
	company.email = d.get_string()!
	company.phone = d.get_string()!
	company.website = d.get_string()!
	company.address = d.get_string()!
	company.business_type = BusinessType(d.get_u8()!)
	company.industry = d.get_string()!
	company.description = d.get_string()!
	company.status = CompanyStatus(d.get_u8()!)
	
	created_at_str := d.get_string()!
	company.created_at = ourtime.new(created_at_str)!
	
	updated_at_str := d.get_string()!
	company.updated_at = ourtime.new(updated_at_str)!

	// Decode shareholders array
	shareholders_len := d.get_u16()!
	company.shareholders = []Shareholder{len: int(shareholders_len)}
	for i in 0 .. shareholders_len {
		mut shareholder := Shareholder{}
		shareholder.id = d.get_u32()!
		shareholder.company_id = d.get_u32()!
		shareholder.user_id = d.get_u32()!
		shareholder.name = d.get_string()!
		shareholder.shares = d.get_int()!
		// Decode the percentage from string instead of f64
		percentage_str := d.get_string()!
		shareholder.percentage = percentage_str.f64()
		
		shareholder.type_ = ShareholderType(d.get_u8()!)
		
		since_str := d.get_string()!
		shareholder.since = ourtime.new(since_str)!
		
		shareholder_created_at_str := d.get_string()!
		shareholder.created_at = ourtime.new(shareholder_created_at_str)!
		
		shareholder_updated_at_str := d.get_string()!
		shareholder.updated_at = ourtime.new(shareholder_updated_at_str)!
		
		company.shareholders[i] = shareholder
	}

	return company
}

// index_keys returns the keys to be indexed for this company
pub fn (company Company) index_keys() map[string]string {
	mut keys := map[string]string{}
	keys['id'] = company.id.str()
	keys['name'] = company.name
	keys['registration_number'] = company.registration_number
	return keys
}
