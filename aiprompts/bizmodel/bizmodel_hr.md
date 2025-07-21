# HR Module Documentation

This module provides functionalities related to Human Resources within the business model.

## Actions

All actions in the `bizmodel` module accept a `bizname` parameter (string, required) which specifies the business model instance to which the action applies.

### `bizmodel.employee_define`

Defines an employee and their associated costs within the business model.

**Parameters:**

* `bizname` (string, required): The name of the business model instance to which this cost belongs.
*   `descr` (string, required): Description of the employee (e.g., 'Junior Engineer'). If `name` is not provided, it will be derived from this.
*   `name` (string, optional): Unique name for the employee. If not provided, it will be generated from `descr`.
*   `cost` (string, required): The cost associated with the employee. Can be a fixed value (e.g., '4000USD') or a growth rate (e.g., '1:5,60:30'). If `indexation` is used, this should not contain a colon.
*   `nrpeople` (string, optional, default: '1'): The number of people for this employee definition. Can be a fixed number or a growth rate (e.g., '1:5,60:30').
*   `indexation` (percentage, optional, default: '0%'): Annual indexation rate for the cost. Applied over 6 years if specified.
*   `department` (string, optional): The department the employee belongs to.
*   `cost_percent_revenue` (percentage, optional, default: '0%'): Ensures the employee cost is at least this percentage of the total revenue.
*   `costcenter` (string, optional, default: 'default_costcenter'): The cost center for the employee.
*   `page` (string, optional): A reference to a page or document related to this employee.
*   `fulltime` (percentage, optional, default: '100%'): The full-time percentage of the employee.


### `bizmodel.department_define`

Defines a department within the business model.

**Parameters:**

* `bizname` (string, required): The name of the business model instance to which this cost belongs.
*   `name` (string, required): Unique name for the department.
*   `descr` (string, optional): Description of the department. If not provided, `description` will be used.
*   `description` (string, optional): Description of the department. Used if `descr` is not provided.
*   `title` (string, optional): A title for the department.
*   `page` (string, optional): A reference to a page or document related to this department.

## **Example:**

```js

!!bizmodel.department_define bizname:'test' 
    name:'engineering'
    descr:'Software Development Department'
    title:'Engineering Division'
    //optional, if set overrules the hr_params
    //avg_monthly_cost:'6000USD' avg_indexation:'5%'

!!bizmodel.employee_define bizname:'test'
    name:'ourclo'
    descr:'CLO'
    cost:'10000EUR'
    indexation:'5%'

!!bizmodel.employee_define bizname:'test' 
    name:'junior_engineer'
    descr:'Junior Engineer'
    nrpeople:'1:5,60:30'
    cost:'4000USD'
    indexation:'5%'
    department:'engineering'
    cost_percent_revenue:'4%'


```

