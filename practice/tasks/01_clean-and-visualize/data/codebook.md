# County Wellness Indicators Codebook

File: `data/county_wellness_indicators_long.csv`

## Unit Of Observation

Each row is one county-measure estimate for one year.

## Columns

- `year`: estimate year.
- `state`: state abbreviation.
- `state_name`: state name.
- `county_fips`: county FIPS code.
- `county_name`: county label.
- `tract_count`: number of tracts represented in the county.
- `total_population`: total county population.
- `total_adult_population`: adult county population.
- `measure_id`: short measure identifier.
- `measure_key`: machine-readable measure name.
- `measure`: display name for the measure.
- `estimate`: county estimate.
- `ci_lower`: lower confidence interval bound.
- `ci_upper`: upper confidence interval bound.

## Analysis Notes

- Estimates are percentages.
- Use `measure` or `measure_key` to choose or group indicators.
- Check whether a plot should show all measures or a focused subset.
- Use `county_fips` or `county_name` only after checking the intended unit of analysis.
