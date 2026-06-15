# AI Tools for Data Science and Statistics

This repository contains the public course materials for AI Tools for Data Science and Statistics. Materials may be updated before each class.

## Start Here

1. Clone this repository with Git: `git clone https://github.com/erikwestlund/ai-tools-2026.git`.
2. Open `ai-tools-course.Rproj` in RStudio, or open this folder in Positron.
3. Open `index.html` for the rendered course website.
4. Open `git-workflow.html` for update and troubleshooting instructions.
5. Use `practice/work/` for your own notebooks, scripts, and rendered files.

## What Is In This Folder

- `index.html`: rendered course website.
- `syllabus.html` and `git-workflow.html`: course information and update instructions.
- `modules/`: Quarto source notebooks and task materials.
- `assignments/`: rendered assignment pages.
- `data/`: public and synthetic teaching datasets.
- `skills/`: reusable agent guidance used by modules and practice tasks.
- `practice/tasks/`: project folders for practice work.
- `practice/prompts/`: prompts and instructions kept outside task project folders.
- `practice/work/`: your own local work area.

When doing a practice task, open that task's `.Rproj` file in RStudio or that task's `.code-workspace` file in Positron. This makes the task folder the local project root while keeping prompts outside the agent context.

## Updating Course Materials

If you are using R or RStudio, run this at the start of each class from the course project root:

```r
source("updater.R")
```

This updates course materials and copies any missing practice-task starter files into `practice/work/` without overwriting files you already have there.

If you are not using R, open a terminal in this folder and run:

```bash
git pull
```

Then create your own files in `practice/work/` as needed.

Do not edit course-owned files in `practice/tasks/`, `modules/`, `assignments/`, `skills/`, or `data/`. Save your own work in `practice/work/`.

If Git says your local changes would be overwritten, see `git-workflow.html`.

## ZIP Download Fallback

Git is strongly recommended. If you cannot use Git, go to <https://github.com/erikwestlund/ai-tools-2026>, click the green **Code** button, and choose **Download ZIP**.

ZIP users must manually copy their old `practice/work/` folder into each fresh download. Do not overwrite your old folder until you have copied out your work.

## Rendering

The rendered site is already included. You normally do not need to rebuild it. Render your own work from `practice/work/`.

Some notebooks may require common R packages such as `dplyr`, `ggplot2`, `tidyr`, or `readr`.
