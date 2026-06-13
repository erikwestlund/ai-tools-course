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
- `modules/` and `assignments/`: rendered course materials.
- `data/`: public and synthetic teaching datasets.
- `skills/`: reusable agent guidance used by modules and practice tasks.
- `practice/tasks/`: instructor-provided practice tasks that update with `git pull`.
- `practice/work/`: your own local work area.

## Updating With Git

At the start of each class, open a terminal in this folder and run:

```bash
git pull
```

Do not edit course-owned files in `practice/tasks/`, `modules/`, `assignments/`, or `data/`. Save your own work in `practice/work/`.

If Git says your local changes would be overwritten, see `git-workflow.html`.

## ZIP Download Fallback

Git is strongly recommended. If you cannot use Git, go to <https://github.com/erikwestlund/ai-tools-2026>, click the green **Code** button, and choose **Download ZIP**.

ZIP users must manually copy their old `practice/work/` folder into each fresh download. Do not overwrite your old folder until you have copied out your work.

## Rendering

The rendered site is already included. You normally do not need to rebuild it. Render your own work from `practice/work/`.

Some notebooks may require common R packages such as `dplyr`, `ggplot2`, `tidyr`, or `readr`.
