# Revenue 

```
!!bizmodel.revenue_define bizname:'test' name:'oem1' ...
```

## Params

- bizname, is the name of the biz model we are populating
- name, name of product, project
- descr, description of the revenue line item

## descrete revenue/cogs (not per item)

cogs stands for cost of goods

- revenue: one of revenue, is not extrapolated, a deal at certain time
- revenue_growth: is a revenue stream which is being extrapolated
- cogs_percent: percent of revenue
- cogs_delay: delay in months between cogs and revenue

## grouped per items sold

- nr_sold: how many do we sell per month (is in growth format e.g. 10:100,20:200, default is 1)
- nr_months_recurring: e.g. 60 is 5 years

- revenue_item_setup, revenue for 1 item '1000usd'
- revenue_item_setup_delay, delay between sell and recognition of sale in months
- revenue_item_monthly, revenue per month for 1 item
- revenue_item_monthly_delay, how many months before monthly revenue starts
- revenue_item_maintenance_perc, how much percent of revenue_item_setup will come back over months
- cogs_item_setup, cost of good for 1 item at setup
- cogs_item_setup_delay, how many months before setup cogs starts, after sales
- cogs_item_setup_perc: what is percentage of the cogs (can change over time) for setup e.g. 0:50%
- cogs_item_monthly, cost of goods for the monthly per 1 item
- cogs_item_monthly_delay, how many months before monthly cogs starts, after sales
- cogs_item_monthly_perc: what is percentage of the cogs (can change over time) for monthly e.g. 0:5%,12:10%

## results in 

follow rows in sheets

- {name}_ + all the arg names as mentioned above...
- {name}_revenue_total
- {name}_cogs_total

## to use

### basic example

```v

heroscript:='

Next will define an OEM product in month 10, 1 Million EUR, ... cogs is a percent which is 20% at start but goes to 10% after 20 months.

!!bizmodel.revenue_define bizname:'test' name:'oem1'
    descr:'OEM Deals'  
    revenue:'10:1000000EUR,15:3333,20:1200000'
    cogs_percent: '1:20%,20:10%'  
'

This time we have the cogs defined in fixed manner, the default currency is USD doesn't have to be mentioned.

!!bizmodel.revenue_define bizname:'test' name:'oem2'
    descr:'OEM Deals'  
    revenue:'10:1000000EUR,15:3333,20:1200000'
    cogs: '10:100000,15:1000,20:120000'  
'



```