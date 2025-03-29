module models

import freeflowuniverse.herolib.data.ourtime
import freeflowuniverse.herolib.data.encoder

import freeflowuniverse.herolib.data.currency

// SaleStatus represents the status of a sale
pub enum SaleStatus {
	pending
	completed
	cancelled
}

// Sale represents a sale of products or services
pub struct Sale {
pub mut:
	id           u32
	company_id   u32
	buyer_name   string
	buyer_email  string
	total_amount currency.Currency
	status       SaleStatus
	sale_date    ourtime.OurTime
	created_at   ourtime.OurTime
	updated_at   ourtime.OurTime
	items        []SaleItem
}

pub struct SaleItem {
pub mut:
	id          u32
	sale_id     u32
	product_id  u32
	name        string
	quantity    int
	unit_price  currency.Currency
	subtotal    currency.Currency
	active_till ourtime.OurTime // after this product no longer active if e.g. a service
}


// dumps serializes the Sale to a byte array
pub fn (sale Sale) dumps() ![]u8 {
	mut enc := encoder.new()

	// Add unique encoding ID to identify this type of data
	enc.add_u16(410) // Unique ID for Sale type

	// Encode Sale fields
	enc.add_u32(sale.id)
	enc.add_u32(sale.company_id)
	enc.add_string(sale.buyer_name)
	enc.add_string(sale.buyer_email)
	
	// Store Currency as serialized data
	total_amount_bytes := sale.total_amount.to_bytes()!
	enc.add_bytes(total_amount_bytes.data)
	
	enc.add_u8(u8(sale.status))
	enc.add_string(sale.sale_date.str())
	enc.add_string(sale.created_at.str())
	enc.add_string(sale.updated_at.str())

	// Encode items array
	enc.add_u16(u16(sale.items.len))
	for item in sale.items {
		enc.add_u32(item.id)
		enc.add_u32(item.sale_id)
		enc.add_u32(item.product_id)
		enc.add_string(item.name)
		enc.add_int(item.quantity)
		
		// Store Currency as serialized data
		unit_price_bytes := item.unit_price.to_bytes()!
		enc.add_bytes(unit_price_bytes.data)
		
		subtotal_bytes := item.subtotal.to_bytes()!
		enc.add_bytes(subtotal_bytes.data)
		
		enc.add_string(item.active_till.str())
	}

	return enc.data
}

// loads deserializes a byte array to a Sale
pub fn sale_loads(data []u8) !Sale {
	mut d := encoder.decoder_new(data)
	mut sale := Sale{}

	// Check encoding ID to verify this is the correct type of data
	encoding_id := d.get_u16()!
	if encoding_id != 410 {
		return error('Wrong file type: expected encoding ID 410, got ${encoding_id}, for sale')
	}

	// Decode Sale fields
	sale.id = d.get_u32()!
	sale.company_id = d.get_u32()!
	sale.buyer_name = d.get_string()!
	sale.buyer_email = d.get_string()!
	
	// Decode Currency from bytes
	total_amount_bytes := d.get_bytes()!
	currency_bytes := currency.CurrencyBytes{data: total_amount_bytes}
	sale.total_amount = currency.from_bytes(currency_bytes)!
	
	sale.status = unsafe { SaleStatus(d.get_u8()!) }
	
	sale_date_str := d.get_string()!
	sale.sale_date = ourtime.new(sale_date_str)!
	
	created_at_str := d.get_string()!
	sale.created_at = ourtime.new(created_at_str)!
	
	updated_at_str := d.get_string()!
	sale.updated_at = ourtime.new(updated_at_str)!

	// Decode items array
	items_len := d.get_u16()!
	sale.items = []SaleItem{len: int(items_len)}
	for i in 0 .. items_len {
		mut item := SaleItem{}
		item.id = d.get_u32()!
		item.sale_id = d.get_u32()!
		item.product_id = d.get_u32()!
		item.name = d.get_string()!
		item.quantity = d.get_int()!
		
		// Decode Currency from bytes
		unit_price_bytes := d.get_bytes()!
		unit_price_currency_bytes := currency.CurrencyBytes{data: unit_price_bytes}
		item.unit_price = currency.from_bytes(unit_price_currency_bytes)!
		
		subtotal_bytes := d.get_bytes()!
		subtotal_currency_bytes := currency.CurrencyBytes{data: subtotal_bytes}
		item.subtotal = currency.from_bytes(subtotal_currency_bytes)!
		
		active_till_str := d.get_string()!
		item.active_till = ourtime.new(active_till_str)!
		
		sale.items[i] = item
	}

	return sale
}

// index_keys returns the keys to be indexed for this sale
pub fn (sale Sale) index_keys() map[string]string {
	mut keys := map[string]string{}
	keys['id'] = sale.id.str()
	keys['company_id'] = sale.company_id.str()
	return keys
}
