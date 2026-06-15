# Maternal Health Data Codebook

File: `data/maternal_health_data.csv`

## Unit Of Observation

Each row is one maternal-health record.

## Columns

- `id`: record identifier.
- `provider_id`: provider identifier.
- `state`: state abbreviation.
- `received_comprehensive_postnatal_care`: binary indicator for comprehensive postnatal care receipt.
- `self_report_income`: self-reported income category.
- `age`: age in years.
- `edu`: education category.
- `race_ethnicity`: race/ethnicity category.
- `insurance`: insurance category.
- `job_type`: job category.
- `dependents`: number of dependents.
- `distance_to_provider`: distance to provider.
- `obesity`: binary health indicator.
- `multiple_gestation`: binary health indicator.
- `diabetes`: binary health indicator.
- `heart_disease`: binary health indicator.
- `placenta_previa`: binary health indicator.
- `hypertension`: binary health indicator.
- `gest_hypertension`: binary health indicator.
- `preeclampsia`: binary health indicator.

## Modeling Notes

- A useful constructed outcome is `comorbidity_count`, the row-wise sum of the eight binary health indicators.
- The care variable and comorbidity indicators should be checked before modeling to confirm their coding.
- Identifiers should usually be treated as identifiers rather than substantive predictors.
- Interpret model output as associations in this file, not causal effects.
