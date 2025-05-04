module finance
import freeflowuniverse.herolib.hero.db.models.base


pub enum AssetType {
    erc20
    erc721
    erc1155
    native

}

pub struct Asset {
    base.Base
pub mut:
    name string
    description string
    amount f64
    address string //address of the asset on the blockchain or bank
    asset_type AssetType //type of the asset
    decimals u8 //number of decimals of the asset
}


pub fn (self Asset) index_keys() map[string]string {
	return {
		'name': self.name
	}
}

pub fn (self Asset) ftindex_keys() map[string]string {
	return map[string]string{}
}
