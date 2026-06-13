# Simulated PRAMS Messy Cleaning Dataset

File: `data/simulated/prams_messy_for_cleaning.csv`

This deliberately messy teaching dataset is based on the shape of PRAMS subgroup estimates. Use it only for classroom practice.

## Unit Of Observation

Each row is a pre-aggregated estimate for a state, subgroup category, subgroup, and measure.

## Intended Cleaning Problems

- Non-syntactic column names with spaces.
- Percentage estimates stored as strings with `%` symbols.
- Multiple missing-value encodings: `NA`, `--`, `Suppressed`, `not available`.
- Inconsistent capitalization in categorical variables.
- Inconsistent subgroup labels, such as `35+`, `25 to 34`, and `College Grad+`.
- Leading whitespace in one measure value.

## Target Clean Structure

The cleaning exercise should produce columns similar to:

- `state`
- `subgroup_category`
- `subgroup`
- `measure`
- `estimate_percent`
- `estimate_available`
- `year`

Students should document every recoding decision.
