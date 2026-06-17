# Sim Data

You can use AI tools in this folder.

Open the project using the `.Rproj` / `.code-workspace` files with your editor to enforce this.

Before using AI, copy approved files from `../real-data/real-data-metadata/` into `real-data-metadata/` in this directory.

Then use AI to complete `generate-sim-data.R`. The script should write a simulated file to:

```text
data/nhanes_2021_2023_analysis.csv
```

That file name must match the real-data file name so notebooks developed here can be copied back to `../real-data/` and run without changing paths.
