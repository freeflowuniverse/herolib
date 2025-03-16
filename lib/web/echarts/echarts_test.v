module echarts

import json

const option_json = '{"title":{"text":"Main Title","subtext":"Subtitle","left":"center"},"tooltip":{"trigger":"axis"},"legend":{"data":["Example1","Example2"]},"grid":{"left":"3%","right":"4%","bottom":"3%","containLabel":true},"xAxis":{"type":"category","data":["Jan","Feb","Mar"]},"yAxis":{"type":"value"},"series":[{"name":"Example1","type":"line","stack":"Total","data":["10","20","30"]},{"name":"Example2","type":"line","stack":"Total","data":["15","25","35"]}]}'

fn test_echarts() {
	option := EChartsOption{
		title:   Title{
			text:    'Main Title'
			subtext: 'Subtitle'
			left:    'center'
		}
		tooltip: Tooltip{
			trigger: 'axis'
		}
		legend:  Legend{
			data: ['Example1', 'Example2']
		}
		grid:    Grid{
			left:          '3%'
			right:         '4%'
			bottom:        '3%'
			contain_label: true
		}
		toolbox: Toolbox{
			feature: ToolboxFeature{
				save_as_image: {}
			}
		}
		x_axis:  XAxis{
			type_:        'category'
			boundary_gap: false
			data:         ['Jan', 'Feb', 'Mar']
		}
		y_axis:  YAxis{
			type_: 'value'
		}
		series:  [
			Series{
				name:  'Example1'
				type_: 'line'
				stack: 'Total'
				data:  ['10', '20', '30']
			},
			Series{
				name:  'Example2'
				type_: 'line'
				stack: 'Total'
				data:  ['15', '25', '35']
			},
		]
	}
	assert json.encode(option) == option_json
}
