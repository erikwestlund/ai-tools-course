# Sim Data

Use AI tools only in this folder.

Before using AI, copy approved files from `../real-data/outputs/` into `metadata/`.

Then use AI to complete `generate-sim-data.R`. The script should write a simulated file to:

```text
data/nhanes_2021_2023_analysis.csv
```

That file name must match the real-data file name so notebooks developed here can be copied back to `../real-data/` and run without changing paths.
