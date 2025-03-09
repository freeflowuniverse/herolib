# Human Resources

| Name | Title | Nr People |
|------|-------|-------|
@for employee in model.employees.values()
| @{employee.name} | @{employee.title} | @{employee.nrpeople} |
@end