# Practice Task 02: Modeling Workflow

Open `practice/tasks/02_modeling-workflow/`, or the matching folder copied into `practice/work/`, as the project for your agent tool. For security, only open the folder you are actively working in.

## Goal

Use an AI agent to help build, run, and review a modeling workflow on maternal-health data.

## Data

Use the files inside that task folder:

- `data/maternal_health_data.csv`
- `data/codebook.md`

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

- Do not make causal claims.
- Ask the agent to work in steps rather than writing the full analysis at once.
- Paste the prompt into the agent rather than placing the prompt file in the task folder.

## Suggested Workflow

1. Open only the task folder, or its copy in `practice/work/`, in your agent tool.
2. Start with `starter-prompt.txt`.
3. Ask the agent for a plan before code.
4. Run each code section.
5. Paste errors back to the agent if needed.
6. Ask the agent to review the final model choice and interpretation.
7. Add your own notes about what you accepted, changed, or rejected.
