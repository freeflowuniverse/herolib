module bizmodel

import freeflowuniverse.herolib.biz.spreadsheet
import freeflowuniverse.herolib.core.playbook

__global (
	bizmodels shared map[string]&BizModel
)

pub fn get(name string) !&BizModel {
	rlock bizmodels {
		if name in bizmodels {
			return bizmodels[name] or { panic('bug') }
		}
		return error("cann't find biz model:'${name}' in global bizmodels ${bizmodels.keys()}")
	}
}

// get bizmodel from global
pub fn getset(name string) !&BizModel {
	lock bizmodels {
		if name !in bizmodels {
			mut sh := spreadsheet.sheet_new(name: 'bizmodel_${name}')!
			mut bizmodel := BizModel{
				sheet: sh
				name:  name
				// currencies: cs
			}
			bizmodels[bizmodel.name] = &bizmodel
		}
		return bizmodels[name] or { panic('bug') }
	}
	panic('bug')
}

pub fn generate(name string, path string) !&BizModel {
	mut model := getset(name)!
	mut pb := playbook.new(path: path)!
	model.play(mut pb)!
	return model
}

pub fn set(bizmodel BizModel) {
	lock bizmodels {
		bizmodels[bizmodel.name] = &bizmodel
	}
}
