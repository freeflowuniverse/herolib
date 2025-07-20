# Spreadsheet Module Overview

The `spreadsheet` module in `herolib` provides a software representation of a spreadsheet, designed for business modeling and data analysis. It supports multi-currency behavior, powerful extrapolation/interpolation, and various data manipulation and visualization capabilities.

## Core Concepts

### Sheet
A `Sheet` is the primary container, representing the entire spreadsheet. It holds a collection of `Row` objects and defines global properties such as the number of columns (`nrcol`), visualization parameters (`SheetParams`), and the associated currency.

**Key Properties:**
- `name`: A unique identifier for the sheet.
- `rows`: A map of `Row` objects, indexed by their names.
- `nrcol`: The number of columns in the sheet, typically representing periods (e.g., 60 months for 5 years).
- `params`: Configuration parameters for the sheet, such as `visualize_cur` (whether to display currency symbols).
- `currency`: The default currency for the sheet, used for currency exchange operations.

### Row
A `Row` represents a single horizontal line of data within a `Sheet`. Each row has a name, an optional alias, a description, and can be associated with tags for grouping and filtering. It contains a series of `Cell` objects, each holding a value for a specific column.

**Key Properties:**
- `name`: A unique identifier for the row within the sheet.
- `alias`: An optional alternative name for the row.
- `description`: A textual description of the row's purpose.
- `tags`: A string of space-separated tags used for categorization and filtering (e.g., "location:belgium_*, department:finance").
- `cells`: A list of `Cell` objects, representing the data points across columns.
- `aggregatetype`: Defines how values in this row should be aggregated (e.g., sum, average, min, max).

### Cell
A `Cell` is the fundamental unit of data in the spreadsheet, residing at the intersection of a row and a column. It stores a floating-point value (`f64`) and a flag indicating if it's empty.

**Key Properties:**
- `val`: The numeric value stored in the cell.
- `empty`: A boolean flag, `true` if the cell is empty, `false` otherwise.

**Key Operations:**
- `set(v string)`: Sets the cell's value. This method intelligently handles currency inputs, converting them to the sheet's base currency if necessary.
- `add(v f64)`: Adds a numeric value to the existing cell value.
- `repr()`: Returns a string representation of the cell's value, displaying '-' for empty cells and formatting numbers appropriately.

## Multi-Currency Support

The spreadsheet module inherently supports multi-currency operations. When a value is set in a cell using a currency string (e.g., "100 EUR"), the system automatically converts it to the sheet's defined currency based on exchange rates.

## Period Representation

Sheets can represent data over various periods:
- **Months:** Typically 60 columns for a 5-year period.
- **Years:** Data can be aggregated into yearly columns.
- **Quarters:** Data can be aggregated into quarterly columns.

This flexibility allows for different levels of granularity in financial and business modeling.