# Cost Module Documentation

This module provides functionalities related to managing various costs within the business model.

## Actions

### `!!bizmodel.cost_define`

Defines a cost item and its associated properties.

**Parameters:**

* `bizname` (string, required): The name of the business model instance to which this cost belongs.
*   `descr` (string, required): Description of the cost item. If `name` is not provided, it will be derived from this.
*   `name` (string, optional): Unique name for the cost item. If not provided, it will be generated from `descr`.
*   `cost` (string, required): The cost value. Can be a fixed value (e.g., '1000USD') or a growth rate (e.g., '0:1000,59:2000'). If `indexation` is used, this should not contain a colon. This value is extrapolated.
*   `cost_one` (string, optional): A single cost value. If provided, `cost` will be ignored and extrapolation will be set to false.
*   `indexation` (percentage, optional, default: '0%'): Annual indexation rate for the cost. Applied over 6 years if specified.
*   `costcenter` (string, optional): The costcenter associated with this cost.
*   `cost_percent_revenue` (percentage, optional, default: '0%'): Ensures the cost is at least this percentage of the total revenue.

### `!!bizmodel.costcenter_define`

Defines a cost center.

**Parameters:**

* `bizname` (string, required): The name of the business model instance to which this cost belongs.
*   `descr` (string, required): Description of the cost center. If `name` is not provided, it will be derived from this.
*   `name` (string, optional): Unique name for the cost center. If not provided, it will be generated from `descr`.
*   `department` (string, optional): The department associated with this cost center.


## **Example:**

```js
!!bizmodel.costcenter_define bizname:'test' 
    descr:'Marketing Cost Center'
    name:'marketing_cc'
    department:'marketing'


!!bizmodel.cost_define bizname:'test' 
    descr:'Office Rent'
    cost:'5000USD'
    indexation:'3%'
    costcenter:'marketing_cc'
    cost_percent_revenue:'1%'

```

