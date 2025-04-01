module pugconvert

import freeflowuniverse.herolib.mcp
import x.json2 as json { Any }
import freeflowuniverse.herolib.mcp.logger
import freeflowuniverse.herolib.baobab.generator

const specs = mcp.Tool{
	name:         'pug_convert'
	description:  ''
	input_schema: mcp.ToolInputSchema{
		typ:        'object'
		properties: {
			'path': mcp.ToolProperty{
				typ:   'string'
			}
		}
		required:   ['path']
	}
}
