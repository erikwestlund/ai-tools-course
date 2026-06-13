# AGENTS.md

## Rules for ggplot2

- Use `theme_minimal(base_size = 14)` as the base theme.
- Set `legend.position = "bottom"` in `theme()`.
- Use `scale_color_brewer(palette = "Dark2")` for discrete color scales.
- Axis labels must include units when applicable, such as "Age (years)" or "Systolic blood pressure (mm Hg)".
- Add a subtitle describing the data source.
- Add a caption beginning with "Source: ".
- Drop rows with missing values for the variables used in the plot before plotting.
- Do not use causal language in the interpretation.

## Examples

- Good axis label: "Age (years)".
- Good interpretation: "Older respondents tended to have higher systolic blood pressure in this sample."
- Bad interpretation: "Age causes systolic blood pressure to increase."
