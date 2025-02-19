# Human Resources

| Name | Title | Nr People |
|------|-------|-------|
@for employee in model.employees.values().filter(it.department == dept.name)
| @{employee_names[employee.name]} | @{employee.title} | @{employee.nrpeople} |
@end

@end