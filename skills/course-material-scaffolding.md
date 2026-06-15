# Course Material Scaffolding Skill

Use this guidance when creating or revising modules, demos, and practice tasks for this repository.

## Core Pattern

- Scaffold work for students to complete with AI tools; do not complete the analysis when the learning goal is to show how agentic AI works.
- Keep project folders clean for agent context. A folder opened in an agent should contain only the files the agent should inspect or edit.
- Put prompts and task instructions outside the project folder that students open with an agent.

## Module Idioms

- Put demo project files under `modules/<module-name>/`.
- Put demo prompts under `modules/prompts/<module-name>/`.
- Make demo folders self-contained with local `data/`, local codebooks, appropriately named notebooks, and `outputs/.gitkeep` when outputs are expected.
- Include a small `.Rproj` file and `.code-workspace` file when a module folder is meant to be opened directly in RStudio or Positron.
- Include a local `_quarto.yml` in each folder-level project so Quarto uses that folder, not the course repository root, as the project root when rendering.
- Do not rely on `.Rproj` or `.code-workspace` files alone for Quarto execution paths. Quarto walks up to the nearest `_quarto.yml`; without a local one, it may use the course repo root as the working directory.
- Do not put `prompt.txt`, prompt READMEs, or skill files inside the demo project folder unless the point of the demo is to show agent context behavior.
- Do not name module notebooks `starter-notebook.qmd`. Use names that describe the work stage, such as `01_data-cleaning.qmd`, `02_data-summary.qmd`, or `03_data-analysis.qmd`.
- Scaffold notebooks should usually contain only YAML with a clear `title`. Do not prefill code, explanations, TODOs, or analysis text unless the exercise specifically requires a setup check.

## Practice Idioms

- Put practice project folders under `practice/tasks/<task-name>/`.
- Put practice prompts and instructions under `practice/prompts/<task-name>/`.
- Keep `practice/tasks/<task-name>/` limited to data, codebooks, appropriately named notebooks, project files, and output placeholders.
- Include a small `.Rproj` file and `.code-workspace` file in each practice task folder so RStudio and Positron use that folder as the project root.
- Include a local `_quarto.yml` in each practice task folder so Quarto renders with that task folder as the project root.
- Use local `_quarto.yml` files when notebooks read local paths such as `data/file.csv`; this prevents Positron or RStudio renders from resolving paths against the parent course repo.
- The practice-task project files are part of the scaffold. They are there to make `data/...` paths resolve locally when students open the task folder directly.
- Do not put task READMEs or starter prompts inside `practice/tasks/<task-name>/`.
- Write practice tasks as realistic work students could encounter: cleaning, checking assumptions, plotting, modeling, debugging, summarizing limitations, or validating AI output.
- Use stage-specific notebook names for practice work, not generic `starter-notebook.qmd`, except for minimal setup checks such as `00_open-project-and-glimpse`.
- Scaffold notebooks should usually contain only YAML with a clear `title`; prompts outside the task folder should drive the work.
- Do not precompute final plots, final models, final tables, or final interpretations unless the exercise is specifically about critique or verification.

## Export And Student Workflow

- When adding published modules or practice tasks, update `index.qmd` and `student_repo/export-manifest.yml`.
- Keep public `modules/` as source/project materials, not rendered module HTML.
- Keep prompts trackable in the public repo but separate from agent project folders.
- Preserve `practice/work/` as the student-owned area. Do not overwrite student work.
- Rebuild the public repo with `Rscript scripts/build-student-repo.R` and verify the expected files are present or absent.
