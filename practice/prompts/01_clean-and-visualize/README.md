# Practice Task 1: Clean And Visualize

Open `practice/tasks/01_clean-and-visualize/`, or the matching folder copied into `practice/work/`, as the project for your agent tool. For security, only open the folder you are actively working in.

## Dataset

Use the files inside that task folder:

- `data/county_wellness_indicators_long.csv`
- `data/codebook.md`

Each row is one county-measure estimate.

## Goal

Use an AI tool to help clean, summarize, and visualize the dataset.

## Task Steps

1. Ask the AI tool to inspect the dataset and codebook.
2. Ask it to identify cleaning or checking steps needed before plotting.
3. Ask it to write code that creates one cleaned analysis dataset.
4. Ask it to summarize estimates by `measure` or `state_name`.
5. Ask it to create one visualization comparing estimates across measures, states, or counties.
6. Check the code and plot yourself.

## Prompt File

Start with `starter-prompt.txt`, then revise it for your tool and your own question. Paste the prompt into the agent rather than placing the prompt file in the task folder.

## Starter Notebook

Use `starter-notebook.qmd` in the task folder if you want a Quarto/R starting point. If you use a different analysis method, language, or tool, set up a workable file for that method and make sure it can load the local files in `data/`.

## What To Check

- Does the code run from the task folder?
- Are numeric columns treated as numeric?
- Does the plot use the intended unit of observation?
- Are labels and captions clear?
- Did the AI tool invent a variable, category, or interpretation?
- What did you change after checking the AI output?
