module echarts

import json
import x.json2

pub struct Title {
pub:
	text    string @[json: 'text'; omitempty]
	subtext string @[json: 'subtext'; omitempty]
	left    string @[json: 'left'; omitempty]
}

pub struct Tooltip {
pub:
	trigger string @[json: 'trigger'; omitempty]
}

pub struct Legend {
pub:
	data   []string @[json: 'data'; omitempty]
	orient string   @[omitempty]
	left   string   @[omitempty]
}

pub struct Grid {
pub:
	left          string @[json: 'left'; omitempty]
	right         string @[json: 'right'; omitempty]
	bottom        string @[json: 'bottom'; omitempty]
	contain_label bool   @[json: 'containLabel'; omitempty]
}

pub struct ToolboxFeature {
pub:
	save_as_image map[string]string @[json: 'saveAsImage'; omitempty]
}

pub struct Toolbox {
pub:
	feature ToolboxFeature @[json: 'feature'; omitempty]
}

pub struct XAxis {
pub:
	type_        string   @[json: 'type'; omitempty]
	boundary_gap bool     @[json: 'boundaryGap'; omitempty]
	data         []string @[json: 'data'; omitempty]
}

pub struct YAxis {
pub:
	type_ string @[json: 'type'; omitempty]
}

pub struct Series {
pub:
	name     string   @[json: 'name'; omitempty]
	type_    string   @[json: 'type'; omitempty]
	stack    string   @[json: 'stack'; omitempty]
	data     []string @[json: 'data'; omitempty]
	radius   int      @[omitempty]
	emphasis Emphasis @[omitempty]
}

pub struct Emphasis {
pub:
	item_style ItemStyle @[json: 'itemStyle'; omitempty]
}

pub struct ItemStyle {
pub:
	shadow_blur     int    @[json: 'shadowBlur'; omitempty]
	shadow_offset_x int    @[json: 'shadowOffsetX'; omitempty]
	shadow_color    string @[json: 'shadowColor'; omitempty]
}

pub struct EChartsOption {
pub:
	title   Title    @[json: 'title'; omitempty]
	tooltip Tooltip  @[json: 'tooltip'; omitempty]
	legend  Legend   @[json: 'legend'; omitempty]
	grid    Grid     @[json: 'grid'; omitempty]
	toolbox Toolbox  @[json: 'toolbox'; omitempty]
	x_axis  XAxis    @[json: 'xAxis'; omitempty]
	y_axis  YAxis    @[json: 'yAxis'; omitempty]
	series  []Series @[json: 'series'; omitempty]
}
