# Real Data

Treat this folder as the restricted data environment.

Do not use AI tools in this folder.

Run:

```r
source("extract-data-info.R")
```

The script writes metadata to `outputs/`. Review those files before copying any of them into `../sim-data/metadata/`.

After AI-assisted development is complete in `../sim-data/`, copy reviewed notebooks and scripts back here and run them against `data/nhanes_2021_2023_analysis.csv`.
