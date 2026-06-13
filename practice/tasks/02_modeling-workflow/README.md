# Practice Task 02: Modeling Workflow

## Goal

Use an AI agent to help build, run, and review a modeling workflow on simulated maternal-health data.

## Data

- Dataset: `data/synthetic/simulated_maternal_health_data.csv`
- Work area: `practice/work/`

## Task

Create an analysis that:

1. Reads the dataset.
2. Checks variable names, types, row count, missingness, and suspicious values.
3. Builds `comorbidity_count` from these binary indicators:
   - `obesity`
   - `multiple_gestation`
   - `diabetes`
   - `heart_disease`
   - `placenta_previa`
   - `hypertension`
   - `gest_hypertension`
   - `preeclampsia`
4. Summarizes the outcome distribution.
5. Compares at least two plausible count-modeling approaches.
6. Fits a selected model.
7. Reports diagnostics, interpretable results, and limitations.

## Guardrails

- Save your own work in `practice/work/`.
- Do not edit files in `practice/tasks/` directly.
- Use `skills/matter-of-fact-language.md` for writing style.
- Do not make causal claims.
- Treat the dataset as simulated teaching data.
- Ask the agent to work in steps rather than writing the full analysis at once.

## Suggested Workflow

1. Copy or recreate the starter notebook in `practice/work/`.
2. Start with `starter-prompt.txt`.
3. Ask the agent for a plan before code.
4. Run each code section.
5. Paste errors back to the agent if needed.
6. Ask the agent to review the final model choice and interpretation.
7. Add your own notes about what you accepted, changed, or rejected.
