# ai-tools-course

Guidance for AI assistants working in this course repository.

## Course Structure

- `slides/temp_source/` contains draft slide materials that may be adapted later.
- `assignments/` contains student exercises and homework.
- `modules/` contains student-facing lessons and practice modules.
- `docs/` contains the syllabus, Git workflow guide, and course policy/support documents.
- `data/` contains public, synthetic, and simulated teaching datasets.

## Editing Guidelines

- Keep course-facing materials concise and student-readable.
- Use standard Quarto and R patterns.
- Do not add legacy project scaffolding or custom data-helper dependencies to new materials.
- Prefer simple explicit examples such as `read.csv()` or `readr::read_csv()` when a data-loading example is needed.
- Do not expose private or restricted data to AI tools; use simulated data for AI-assisted development.
- When adding modules, update `index.qmd` and `student_repo/export-manifest.yml`, then render and export the student repo.

## Public Export

The student-facing repository is built with:

```bash
Rscript scripts/build-student-repo.R
```

The default public repo path is configured in `student_repo/export-manifest.yml`.
