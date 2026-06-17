# Real Data

Treat this folder as the restricted data environment.

Open the project using the `.Rproj` / `.code-workspace` files with your editor to enforce this.

Do not use AI tools in this folder.

Run:

```r
source("extract-data-info.R")
```

The script writes metadata to `real-data-metadata/`. Review those files before copying any of them into `../sim-data/real-data-metadata/`.

After AI-assisted development is complete in `../sim-data/`, copy reviewed notebooks and scripts back here and run them against `data/nhanes_2021_2023_analysis.csv`.
