# BizTools Examples Test Results

## Working Examples
- `bizmodel.vsh` - This example works correctly and displays a spreadsheet with business model data.

## Non-Working Examples
All other examples have issues with the `bizmodel.play()` function:

1. `bizmodel1.vsh` - Error: Unknown field `heroscript` in struct literal of type `PlayBook`.
2. `bizmodel2.vsh` - Error: Unknown field `heroscript` in struct literal of type `PlayBook`.
3. `bizmodel_complete.vsh` - Error: Unknown field `heroscript_path` in struct literal of type `PlayBook`.
4. `bizmodel_export.vsh` - Error: Unknown field `heroscript_path` in struct literal of type `PlayBook`.
5. `bizmodel_full.vsh` - Error: Unknown field `heroscript_path` in struct literal of type `PlayBook`.
6. `costs.vsh` - Error: Unknown field `heroscript` in struct literal of type `PlayBook`.
7. `funding.vsh` - Error: Unknown field `heroscript` in struct literal of type `PlayBook`.
8. `hr.vsh` - Error: Unknown field `heroscript` in struct literal of type `PlayBook`.

## Common Error Pattern
All non-working examples have the same pattern of errors:

1. Unknown field (`heroscript` or `heroscript_path`) in struct literal of type `PlayBook`.
2. Reference field `PlayBook.session` must be initialized.
3. Function `bizmodel.play` parameter `plbook` is `mut`, so it requires `mut PlayBook{...}` instead.

## Environment Setup
- Tests were performed with V language version 0.4.11 a11de72
- Redis server was running during tests
- All tests were executed from the `/workspace/project/herolib/examples/biztools` directory