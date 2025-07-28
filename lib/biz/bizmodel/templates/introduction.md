# @{model.name}

@{model.description}

## FUNDING

@{model.sheet.wiki(includefilter:['funding']) or {panic(err)}}

## REVENUE vs COGS

@{model.sheet.wiki(includefilter:['rev']) or {panic(err)}}

#### Revenue

@{model.sheet.wiki(title:'Revenue Total', includefilter:['revtotal']) or {panic(err)}}

#### Cost of Goods

@{model.sheet.wiki(title:'COGS', includefilter:['cogstotal']) or {panic(err)}}

#### Margin

@{model.sheet.wiki(title:'COGS', includefilter:['margintotal']) or {panic(err)}}


## HR

@{model.sheet.wiki(title:'#### HR Teams', includefilter:['hrnr']) or {panic(err)}}

@{model.sheet.wiki(title:'#### HR Costs', includefilter:['hrcost']) or {panic(err)}}

## Operational Costs

@{model.sheet.wiki( includefilter:['ocost']) or {panic(err)}}

## P&L Overview

<!-- period is in months, 3 means every quarter -->

@{model.sheet.wiki(title:'P&L Overview', includefilter:['pl']) or {panic(err)}}

@{model.sheet.wiki(title:'P&L Result', includefilter:['summary']) or {panic(err)}}


@{model.sheet.bar_chart(rowname:'revenue_total', unit: .million, title:'Total Revenue', title_sub:'Sub') or {panic(err)}.mdx()}

Unit is in Million USD.

@{model.sheet.line_chart(rowname:'revenue_total', unit: .million) or {panic(err)}.mdx()}

@{model.sheet.pie_chart(rowname:'revenue_total', unit: .million, size:'80%') or {panic(err)}.mdx()}

<!-- ## Some Details

> show how we can do per month

@{model.sheet.wiki(includefilter:['pl'], period_type:.month) or {panic(err)}} -->