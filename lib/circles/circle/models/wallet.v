module models

import freeflowuniverse.herolib.data.encoder

// Asset represents a cryptocurrency asset in a wallet
pub struct Asset {
pub mut:
	name   string // Asset name (e.g., "USDC")
	amount f64    // Amount of the asset
}

// Wallet represents a cryptocurrency wallet
pub struct Wallet {
pub mut:
	id              u32      // unique id
	name            string   // name of the wallet
	description     string   // optional description
	blockchain_name string   // name of the blockchain
	pubkey          string   // public key of the wallet
	assets          []Asset  // assets in the wallet
}

pub fn (w Wallet) index_keys() map[string]string {
	return {
		'name': w.name,
		'blockchain': w.blockchain_name
	}
}

// dumps serializes the Wallet struct to binary format using the encoder
// This implements the Serializer interface
pub fn (w Wallet) dumps() ![]u8 {
	mut e := encoder.new()

	// Add unique encoding ID to identify this type of data
	e.add_u16(202)

	// Encode Wallet fields
	e.add_u32(w.id)
	e.add_string(w.name)
	e.add_string(w.description)
	e.add_string(w.blockchain_name)
	e.add_string(w.pubkey)

	// Encode assets array
	e.add_u16(u16(w.assets.len))
	for asset in w.assets {
		// Encode Asset fields
		e.add_string(asset.name)
		e.add_f64(asset.amount)
	}

	return e.data
}

// loads deserializes binary data into a Wallet struct
pub fn wallet_loads(data []u8) !Wallet {
	mut d := encoder.decoder_new(data)
	mut wallet := Wallet{}

	// Check encoding ID to verify this is the correct type of data
	encoding_id := d.get_u16()!
	if encoding_id != 202 {
		return error('Wrong file type: expected encoding ID 202, got ${encoding_id}, for wallet')
	}

	// Decode Wallet fields
	wallet.id = d.get_u32()!
	wallet.name = d.get_string()!
	wallet.description = d.get_string()!
	wallet.blockchain_name = d.get_string()!
	wallet.pubkey = d.get_string()!

	// Decode assets array
	assets_len := d.get_u16()!
	wallet.assets = []Asset{len: int(assets_len)}
	for i in 0 .. assets_len {
		mut asset := Asset{}

		// Decode Asset fields
		asset.name = d.get_string()!
		asset.amount = d.get_f64()!

		wallet.assets[i] = asset
	}

	return wallet
}

// set_asset sets an asset in the wallet (replaces if exists, adds if not)
pub fn (mut w Wallet) set_asset(name string, amount f64) {
	// Check if the asset already exists
	for i, asset in w.assets {
		if asset.name == name {
			// Update the amount
			w.assets[i].amount = amount
			return
		}
	}
	
	// Add a new asset
	w.assets << Asset{
		name: name
		amount: amount
	}
}

// total_value gets the total value of all assets in the wallet
pub fn (w Wallet) total_value() f64 {
	mut total := f64(0)
	for asset in w.assets {
		total += asset.amount
	}
	return total
}