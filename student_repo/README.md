# AI Tools for Data Science and Statistics

This repository contains the public course materials for AI Tools for Data Science and Statistics.

## Start Here

1. Open `ai-tools-course.Rproj` in RStudio, or open this folder in Positron.
2. Open `docs/index.html` for the rendered course website.
3. Open `course_docs/syllabus.qmd` or `docs/course_docs/syllabus.html` for the syllabus.
4. Use `data/synthetic/` for AI-assisted demos and practice. Do not send private or regulated data to external AI tools.

## What Is In This Folder

- `docs/`: rendered public course website, slides, course docs, and demos.
- `slides/`: slide source files.
- `course_docs/`: syllabus and course project source files.
- `modules/`: course-owned lesson notebooks and activities.
- `demos/`: AI tool demonstrations and comparison notebooks.
- `data/`: public and synthetic teaching datasets.
- `output/`: generated public teaching artifacts from demos.
- `practice/work/`: your own local work area.

## Updating

If you cloned this repository with Git, run this from the R console at the project root:

```r
source("updater.R")
```

The updater runs `git pull --ff-only` and creates `practice/work/` if needed. It does not overwrite files in `practice/work/`.

## Rendering

The rendered site is already in `docs/`. To rebuild it from source, install Quarto and the required R packages, then run:

```bash
./render.sh
```

Required R packages for the core materials are listed in `settings.yml`. Some demo notebooks may require additional packages or command-line tools depending on the AI workflow being demonstrated.
