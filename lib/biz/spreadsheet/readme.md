# Sheet 

The idea is to have a module which allows us to make software representation of a spreadsheet.

The spreadsheet has a currency linked to it and also multi currency behavior, it also has powerful extra/intrapolation possibilities.

A sheet has following format

If we have 60 months representation (5 year), we have 60 columns

- rows, each row represent something e.g. salary for a person per month over 5 years
- the rows can be grouped per tags
- each row has 60 cols = cells, each cell has a value
- each row has a name

A sheet can also be represented per year or per quarter, if per year then there would be 5 columns only.

There is also functionality to export a sheet to wiki (markdown), html representation, or CSV format.

## Exporting to CSV

You can export sheet data to CSV format with pipe separation (or custom separator) using the `export_csv` method:

```v
// Create a sheet
mut sheet := sheet_new(name: 'my_sheet', nrcol: 12)!

// Add rows and data to the sheet
// ...

// Export to a CSV file with default pipe separator
sheet.export_csv(path: '~/output.csv')!

// Export with custom separator and include empty cells
csv_content := sheet.export_csv(
    path: '~/output.csv',
    separator: ',',
    include_empty: true
)!

// Export to string only (no file)
csv_string := sheet.export_csv(path: '')!
```

The CSV export includes the following features:
- Default pipe (`|`) separator (configurable)
- Proper handling of special characters in text fields
- Option to include or exclude empty cells
- Automatic formatting of numeric values

## offline

if you need to work offline e.g. for development do

```bash
export OFFLINE=1
```

## Macro's



```js
!!sheet.graph_pie_row sheetname:'tfgridsim_run1' 
    rowname:'revenue_usd'
    period_type:quarter 
    title:'a title'
```

- supported_actions:
  - 'sheet_wiki'
  - 'graph_pie_row' = pie chart for 1 row
  - 'graph_line_row'
  - 'graph_bar_row'
  - 'graph_title_row'
  - 'wiki_row_overview'


Properties to use in heroscript

- rowname       string   - if specified then its one name
- namefilter    []string - only include the exact names as specified for the rows
- includefilter []string - to use with tags filter e.g. ['location:belgium_*'] //would match all words starting with belgium
- excludefilter []string
- period_type   PeriodType       - year, month, quarter
- aggregate     bool = true - if more than 1 row matches should we aggregate or not
- aggregatetype RowAggregateType = .sum - important if used with include/exclude, because then we group
- unit          UnitType
- title         string
- title_sub     string
- size          string
- rowname_show  bool = true - show the name of the row
- descr_show    bool = false - show the description of the row, if this is on then rowname_show will be put on 0
- description   string	
