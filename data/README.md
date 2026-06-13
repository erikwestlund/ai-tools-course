# Course Data

This folder contains datasets for course demos, student practice, and privacy-safe workflow exercises.

## Included Files

- `data/synthetic/simulated_maternal_health_data.csv`
  - Synthetic individual-level maternal health dataset for visualization and modeling practice.
  - No real patients; suitable for AI-assisted classroom demos.

- `data/synthetic/simulated_data.csv`
  - Alternate synthetic dataset with a similar schema for quick exercises.
  - Useful when you want students to run the same workflow on a second dataset.

- `data/simulated/prams_messy_for_cleaning.csv`
  - Deliberately messy PRAMS-shaped teaching dataset for data-cleaning practice.
  - Includes inconsistent names, missing-value encodings, percent strings, and category label problems.

- `data/public/cdc_prams_df_final.rds`
  - Public-data-derived PRAMS object used in prior course materials.
  - Good for demonstrations that connect to maternal and child health topics.

## Data Visualization Course Datasets

The data visualization course dataset collection has also been copied into this course:

- `data/real/`: cleaned real public teaching datasets.
- `data/real/wide/`: derived wide versions of selected real datasets.
- `data/simulated/`: simulated analog datasets with different topics but matching column names to real datasets.
- `data/codebooks/`: codebooks for CSV files listed in the manifest.
- `data/manifest.csv`: inventory of real, simulated, and metadata CSV files.
- `data/data.md`: source for the data index.

Use `data/manifest.csv` to find datasets, codebooks, and simulated analogs. The key workflow pattern is to develop with simulated datasets and then apply verified code to real public datasets or restricted environments as appropriate.

## Recommended Public Biomedical Sources (for future additions)

- CDC PRAMStat (Maternal and Child Health):
  - https://data.cdc.gov/Maternal-Child-Health/CDC-PRAMStat-Data-for-2011/ese6-rqpq/about_data

- CDC Influenza Vaccination Coverage:
  - https://data.cdc.gov/Flu-Vaccinations/Influenza-Vaccination-Coverage-for-All-Ages-6-Mont/vh55-3he6/about_data

- NHANES (CDC):
  - https://wwwn.cdc.gov/nchs/nhanes/

## Teaching Notes

- For external AI tools, use synthetic datasets only.
- For classroom agent practice, prefer `data/synthetic/` and `data/simulated/` unless an exercise explicitly uses public real data.
- For restricted data environments, move code and metadata between environments, not raw sensitive data.
- Keep classroom examples simple and explicit about which files they read and write.
