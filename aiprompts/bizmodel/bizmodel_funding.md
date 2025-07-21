# Funding Module Documentation

This module provides functionalities related to managing various funding sources within the business model.

## Actions

### `!!bizmodel.funding_define`

Defines a funding entity and its associated properties.

**Parameters:**

*   `bizname` (string, required): The name of the business model instance to which this funding belongs.
*   `name` (string, required): Identifier for the funding entity.
*   `descr` (string, optional): Human-readable description. If not provided, it will be derived from `description`.
*   `investment` (string, required): Format `month:amount`, e.g., '0:10000,12:5000'. This value is extrapolated.
*   `type` (string, optional, default: 'capital'): The type of funding. Allowed values: 'loan' or 'capital'.
*   `extrapolate`: If you want to extrapolate revenue or cogs do extrapolate:1, default is 0.

### `funding_total`

Calculates the total funding.

## **Example:**

```js
!!bizmodel.funding_define bizname:'test' name:'seed_capital'
    descr:'Initial Seed Capital Investment'
    investment:'0:500000,12:200000'
    type:'capital'

!!bizmodel.funding_define bizname:'test' name:'bank_loan'
    descr:'Bank Loan for Expansion'
    investment:'6:100000,18:50000'
    type:'loan'