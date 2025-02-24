# This is our business model planner

## P&L Overview


<!-- period is in months, 3 means every quarter -->


!!bizmodel.graph_bar_row rowname:revenue_total unit:million title:'A Title' title_sub:'Sub' sheetname:'bizmodel_test'

Unit is in Million USD.

!!bizmodel.graph_bar_row rowname:revenue_total unit:million sheetname:'bizmodel_test'

!!bizmodel.graph_line_row rowname:revenue_total unit:million sheetname:'bizmodel_test'

!!bizmodel.graph_pie_row rowname:revenue_total unit:million size:'80%' sheetname:'bizmodel_test'

## FUNDING

!!bizmodel.sheet_wiki includefilter:'funding' sheetname:'bizmodel_test'

!!bizmodel.sheet_wiki title:'REVENUE' includefilter:rev sheetname:'bizmodel_test'

!!bizmodel.sheet_wiki title:'Revenue Total' includefilter:'revtotal' sheetname:'bizmodel_test'

!!bizmodel.sheet_wiki title:'REVENUE' includefilter:'revtotal2' sheetname:'bizmodel_test'

!!bizmodel.sheet_wiki title:'COGS' includefilter:'cogs' sheetname:'bizmodel_test'

!!bizmodel.sheet_wiki title:'Margin' includefilter:'margin' sheetname:'bizmodel_test'

!!bizmodel.sheet_wiki title:'HR Teams' includefilter:'hrnr' sheetname:'bizmodel_test'

!!bizmodel.sheet_wiki title:'HR Costs' includefilter:'hrcost' sheetname:'bizmodel_test'

!!bizmodel.sheet_wiki title:'COSTS' includefilter:'ocost' sheetname:'bizmodel_test'

!!bizmodel.sheet_wiki title:'HR Costs' includefilter:'hrcost' sheetname:'bizmodel_test'

!!bizmodel.sheet_wiki title:'P&L Overview' includefilter:'pl' sheetname:'bizmodel_test'

!!bizmodel.sheet_wiki title:'P&L Overview' includefilter:'pl' sheetname:'bizmodel_test'

## Some Details

> show how we can do per month

!!bizmodel.sheet_wiki includefilter:'pl' period_months:1 sheetname:'bizmodel_test'



