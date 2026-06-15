# Subgroup Estimate Data Codebook

File: `data/subgroup_estimates.csv`

## Unit Of Observation

Each row is a pre-aggregated estimate for a state, subgroup category, subgroup, measure, and year.

## Columns

- `State`: state name.
- `Subgroup Category`: broad category used to define the subgroup.
- `Sub Group`: subgroup label within the category.
- `Measure`: outcome or behavior being estimated.
- `Estimate`: percent estimate, stored as text in the raw file.
- `Year`: estimate year.

## Analysis Notes

- Estimates are percentages.
- Rows are already aggregated; do not treat them as individual records.
- Document any cleaning or recoding decisions before summarizing.
