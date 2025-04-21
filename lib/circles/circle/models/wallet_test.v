module models

import freeflowuniverse.herolib.data.encoder

// Tests basic serialization/deserialization of a wallet
fn test_wallet_dumps_loads() {
	// Create a test wallet with sample data
	mut wallet := Wallet{
		id: 123
		name: 'Test Wallet'
		description: 'A test wallet for binary encoding'
		blockchain_name: 'Ethereum'
		pubkey: '0x123456789abcdef'
	}
	
	// Add assets
	wallet.assets << Asset{
		name: 'ETH'
		amount: 1.5
	}
	
	wallet.assets << Asset{
		name: 'USDC'
		amount: 1000.0
	}
	
	// Test binary encoding
	binary_data := wallet.dumps() or {
		assert false, 'Failed to encode wallet: ${err}'
		return
	}
	
	// Test binary decoding
	decoded_wallet := wallet_loads(binary_data) or {
		assert false, 'Failed to decode wallet: ${err}'
		return
	}
	
	// Verify the decoded data matches the original
	assert decoded_wallet.id == wallet.id
	assert decoded_wallet.name == wallet.name
	assert decoded_wallet.description == wallet.description
	assert decoded_wallet.blockchain_name == wallet.blockchain_name
	assert decoded_wallet.pubkey == wallet.pubkey
	
	// Verify assets
	assert decoded_wallet.assets.len == wallet.assets.len
	
	// Verify first asset
	assert decoded_wallet.assets[0].name == wallet.assets[0].name
	assert decoded_wallet.assets[0].amount == wallet.assets[0].amount
	
	// Verify second asset
	assert decoded_wallet.assets[1].name == wallet.assets[1].name
	assert decoded_wallet.assets[1].amount == wallet.assets[1].amount
	
	println('Wallet binary encoding/decoding test passed successfully')
}

// Tests the set_asset method of the Wallet struct
fn test_wallet_set_asset() {
	mut wallet := Wallet{
		id: 456
		name: 'Asset Test Wallet'
		blockchain_name: 'Bitcoin'
		pubkey: 'bc1q123456789'
	}
	
	// Test adding a new asset
	wallet.set_asset('BTC', 0.5)
	assert wallet.assets.len == 1
	assert wallet.assets[0].name == 'BTC'
	assert wallet.assets[0].amount == 0.5
	
	// Test updating an existing asset
	wallet.set_asset('BTC', 1.0)
	assert wallet.assets.len == 1 // Should still have only one asset
	assert wallet.assets[0].name == 'BTC'
	assert wallet.assets[0].amount == 1.0 // Amount should be updated
	
	// Add another asset
	wallet.set_asset('USDT', 500.0)
	assert wallet.assets.len == 2
	
	// Verify both assets are present with correct values
	for asset in wallet.assets {
		if asset.name == 'BTC' {
			assert asset.amount == 1.0
		} else if asset.name == 'USDT' {
			assert asset.amount == 500.0
		} else {
			assert false, 'Unexpected asset: ${asset.name}'
		}
	}
	
	println('Wallet set_asset test passed successfully')
}

// Tests the total_value method of the Wallet struct
fn test_wallet_total_value() {
	mut wallet := Wallet{
		id: 789
		name: 'Value Test Wallet'
		blockchain_name: 'Solana'
		pubkey: 'sol123456789'
	}
	
	// Empty wallet should have zero value
	assert wallet.total_value() == 0.0
	
	// Add first asset
	wallet.set_asset('SOL', 10.0)
	assert wallet.total_value() == 10.0
	
	// Add second asset
	wallet.set_asset('USDC', 50.0)
	assert wallet.total_value() == 60.0 // 10 SOL + 50 USDC
	
	// Update first asset
	wallet.set_asset('SOL', 15.0)
	assert wallet.total_value() == 65.0 // 15 SOL + 50 USDC
	
	// Add third asset with negative value
	wallet.set_asset('TEST', -5.0)
	assert wallet.total_value() == 60.0 // 15 SOL + 50 USDC - 5 TEST
	
	println('Wallet total_value test passed successfully')
}

// Tests the index_keys method of the Wallet struct
fn test_wallet_index_keys() {
	wallet := Wallet{
		id: 101
		name: 'Index Keys Test'
		blockchain_name: 'Polkadot'
		pubkey: 'dot123456789'
	}
	
	keys := wallet.index_keys()
	assert keys['name'] == 'Index Keys Test'
	assert keys['blockchain'] == 'Polkadot'
	assert keys.len == 2
	
	println('Wallet index_keys test passed successfully')
}

// Tests serialization/deserialization of a wallet with no assets
fn test_wallet_empty_assets() {
	// Test a wallet with no assets
	wallet := Wallet{
		id: 222
		name: 'Empty Wallet'
		description: 'A wallet with no assets'
		blockchain_name: 'Cardano'
		pubkey: 'ada123456789'
		assets: []
	}
	
	// Test binary encoding
	binary_data := wallet.dumps() or {
		assert false, 'Failed to encode empty wallet: ${err}'
		return
	}
	
	// Test binary decoding
	decoded_wallet := wallet_loads(binary_data) or {
		assert false, 'Failed to decode empty wallet: ${err}'
		return
	}
	
	// Verify the decoded data matches the original
	assert decoded_wallet.id == wallet.id
	assert decoded_wallet.name == wallet.name
	assert decoded_wallet.description == wallet.description
	assert decoded_wallet.blockchain_name == wallet.blockchain_name
	assert decoded_wallet.pubkey == wallet.pubkey
	assert decoded_wallet.assets.len == 0
	
	println('Empty wallet binary encoding/decoding test passed successfully')
}

// Tests serialization/deserialization of assets with precise decimal values
fn test_wallet_precision() {
	// Test a wallet with assets that have very precise decimal values
	mut wallet := Wallet{
		id: 333
		name: 'Precision Test Wallet'
		blockchain_name: 'Ethereum'
		pubkey: 'eth123456789'
	}
	
	// Add assets with precise values
	wallet.set_asset('ETH', 0.123456789012345)
	wallet.set_asset('BTC', 0.000000012345678)
	
	// Test binary encoding
	binary_data := wallet.dumps() or {
		assert false, 'Failed to encode precision wallet: ${err}'
		return
	}
	
	// Test binary decoding
	decoded_wallet := wallet_loads(binary_data) or {
		assert false, 'Failed to decode precision wallet: ${err}'
		return
	}
	
	// Verify the precise values are preserved
	for i, asset in wallet.assets {
		decoded_asset := decoded_wallet.assets[i]
		assert decoded_asset.name == asset.name
		assert decoded_asset.amount == asset.amount
	}
	
	println('Wallet precision test passed successfully')
}

// Tests error handling for wrong encoding ID
fn test_wallet_wrong_encoding_id() {
	// Create invalid data with wrong encoding ID
	mut e := encoder.new()
	e.add_u16(999) // Wrong ID (should be 202)
	
	// Attempt to deserialize and expect error
	result := wallet_loads(e.data) or {
		assert err.str() == 'Wrong file type: expected encoding ID 202, got 999, for wallet'
		println('Error handling test (wrong encoding ID) passed successfully')
		return
	}
	
	assert false, 'Should have returned an error for wrong encoding ID'
}

// Tests error handling for incomplete data
fn test_wallet_incomplete_data() {
	// Create incomplete data (missing fields)
	mut e := encoder.new()
	e.add_u16(202) // Correct ID
	e.add_u32(123) // ID
	// Missing other fields
	
	// Attempt to deserialize and expect error
	result := wallet_loads(e.data) or {
		assert err.str().contains('failed to read')
		println('Error handling test (incomplete data) passed successfully')
		return
	}
	
	assert false, 'Should have returned an error for incomplete data'
}