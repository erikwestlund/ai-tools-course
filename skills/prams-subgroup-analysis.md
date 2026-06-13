# PRAMS-Style Subgroup Analysis Skill

Use this guidance when working on the simulated PRAMS-style subgroup estimate analysis in this repository.

## Scope

- Work only with the simulated dataset at `data/simulated/prams_messy_for_cleaning.csv` and its codebook.
- Treat each row as a pre-aggregated estimate for a state, subgroup category, subgroup, and measure.
- Do not make causal claims from these data.

## Output Paths

- Write derived files under `modules/01_agent-demo/outputs/`.
- Use explicit paths in code. The `.gitkeep` file only keeps the folder present when empty.
- Suggested filenames:
  - `prams_cleaned.csv`
  - `prams_summary_by_measure.csv`
  - `prams_summary_by_subgroup_category.csv`
  - `prams_subgroup_plot.png`

## Analysis Standards

- Preserve missing and suppressed estimates explicitly.
- Convert percent strings to numeric percentages only after documenting missing-value codes.
- Standardize obvious label inconsistencies conservatively.
- Keep interpretations close to the displayed summaries and plots.
- Flag uncertainty or ambiguity rather than inventing variable meanings.
