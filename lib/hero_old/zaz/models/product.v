module models

import freeflowuniverse.herolib.data.ourtime
import freeflowuniverse.herolib.data.encoder
import freeflowuniverse.herolib.data.currency
import freeflowuniverse.herolib.core.texttools { name_fix }

// ProductType represents the type of a product
pub enum ProductType {
	product
	service
}

// ProductStatus represents the status of a product
pub enum ProductStatus {
	available
	unavailable
}

// ProductComponent represents a component of a product
pub struct ProductComponent {
pub mut:
	id          u32
	name        string
	description string
	quantity    int
	created_at  ourtime.OurTime
	updated_at  ourtime.OurTime
}

// Product represents a product or service offered by the Freezone
pub struct Product {
pub mut:
	id            u32
	name          string
	description   string
	price         currency.Currency
	type_         ProductType
	category      string
	status        ProductStatus
	created_at    ourtime.OurTime
	updated_at    ourtime.OurTime
	max_amount    u16 // means allows us to define how many max of this there are
	purchase_till ourtime.OurTime
	active_till   ourtime.OurTime // after this product no longer active if e.g. a service
	components    []ProductComponent
}

// dumps serializes the Product to a byte array
pub fn (product Product) dumps() ![]u8 {
	mut enc := encoder.new()

	// Add unique encoding ID to identify this type of data
	enc.add_u16(409) // Unique ID for Product type

	// Encode Product fields
	enc.add_u32(product.id)
	enc.add_string(product.name)
	enc.add_string(product.description)

	// Store Currency as serialized data
	currency_bytes := product.price.to_bytes()!
	enc.add_bytes(currency_bytes.data)

	enc.add_u8(u8(product.type_))
	enc.add_string(name_fix(product.category))
	enc.add_u8(u8(product.status))
	enc.add_string(product.created_at.str())
	enc.add_string(product.updated_at.str())
	enc.add_u16(product.max_amount)
	enc.add_string(product.purchase_till.str())
	enc.add_string(product.active_till.str())

	// Encode components array
	enc.add_u16(u16(product.components.len))
	for component in product.components {
		enc.add_u32(component.id)
		enc.add_string(component.name)
		enc.add_string(component.description)
		enc.add_int(component.quantity)
		enc.add_string(component.created_at.str())
		enc.add_string(component.updated_at.str())
	}

	return enc.data
}

// loads deserializes a byte array to a Product
pub fn product_loads(data []u8) !Product {
	mut d := encoder.decoder_new(data)
	mut product := Product{}

	// Check encoding ID to verify this is the correct type of data
	encoding_id := d.get_u16()!
	if encoding_id != 409 {
		return error('Wrong file type: expected encoding ID 409, got ${encoding_id}, for product')
	}

	// Decode Product fields
	product.id = d.get_u32()!
	product.name = d.get_string()!
	product.description = d.get_string()!

	// Decode Currency from bytes
	price_bytes := d.get_bytes()!
	currency_bytes := currency.CurrencyBytes{
		data: price_bytes
	}
	product.price = currency.from_bytes(currency_bytes)!

	product.type_ = unsafe { ProductType(d.get_u8()!) }
	product.category = d.get_string()!
	product.status = unsafe { ProductStatus(d.get_u8()!) }

	created_at_str := d.get_string()!
	product.created_at = ourtime.new(created_at_str)!

	updated_at_str := d.get_string()!
	product.updated_at = ourtime.new(updated_at_str)!

	product.max_amount = d.get_u16()!

	purchase_till_str := d.get_string()!
	product.purchase_till = ourtime.new(purchase_till_str)!

	active_till_str := d.get_string()!
	product.active_till = ourtime.new(active_till_str)!

	// Decode components array
	components_len := d.get_u16()!
	product.components = []ProductComponent{len: int(components_len)}
	for i in 0 .. components_len {
		mut component := ProductComponent{}
		component.id = d.get_u32()!
		component.name = d.get_string()!
		component.description = d.get_string()!
		component.quantity = d.get_int()!

		component_created_at_str := d.get_string()!
		component.created_at = ourtime.new(component_created_at_str)!

		component_updated_at_str := d.get_string()!
		component.updated_at = ourtime.new(component_updated_at_str)!

		product.components[i] = component
	}

	return product
}

// index_keys returns the keys to be indexed for this product
pub fn (product Product) index_keys() map[string]string {
	mut keys := map[string]string{}
	keys['id'] = product.id.str()
	keys['name'] = product.name
	return keys
}
